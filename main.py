from util import get_client, get_logger
from prompts import x86_compile_prompt
import os
import json
import subprocess
from datasets import load_dataset
import asyncio
import tempfile


logger = get_logger("INFO", "temp.log")

# base class
class Chat:
    def __init__(self, client, model_name, system_prompt = "You are a helpful assistant.",allow_system_prompt=True):
        self.client = client
        self.model_name = model_name
        self.messages = []
        self.allow_system_prompt = allow_system_prompt
        self.system_prompt = system_prompt
        self.reset()
        
    # arbitrary chat
    def chat(self, user_input=None):
        if user_input is None:
            user_input = input("User: \n")
        self.messages.append({"role": "user", "content": user_input})
        response = self.client.chat.completions.create(
            model = self.model_name,
            temperature = 0.0,
            messages = self.messages,
        )
        rsp_content = response.choices[0].message.content
        self.messages.append({"role": "assistant", "content": rsp_content})
    
    # clear the chat history
    def reset(self):
        self.messages = []
        if self.allow_system_prompt:
            self.messages.append(
                {"role": "system", "content": self.system_prompt}
            )
            
    # print all the chat history
    def print_history(self):
        logger.debug("-----Chat History-----")
        for message in self.messages:
            logger.debug(f"###{message['role']}: {message['content']}")
        logger.debug("-----------------------")
            
    # get the last message
    def get_response(self):
        return self.messages[-1]['content']

def llm_compile(chatbot: Chat, code, case_id):
    logger.debug(f"Compiling code:\n\n{code}")
    chatbot.chat(code)
    response = chatbot.get_response()
    try:
        thought = response.split("</think>")[0].strip()
        logger.debug(f"Thought process:\n\n{thought}")
        response = response.split("</think>")[-1].strip()
        parsed_response = json.loads(response)
        x86_asm = parsed_response["x86"]
    except json.JSONDecodeError:
        logger.warning("Failed to parse JSON response. Using raw response.")
        x86_asm = response
    logger.debug(f"Final assembly code:\n\n{x86_asm}")
    logger.debug(f"Sample {case_id}:\n{code}\nOutput:\n{x86_asm}")
    with open(f"tmp_{case_id}.s", "w") as f:
        if x86_asm is not None:
            f.write(x86_asm)
            f.close()
    return
    
def cleanup(path):
    logger.info("Cleaning up temporary files...")
    # remove all files and directories in the path
    for root, dirs, files in os.walk(path, topdown=False):
        for name in files:
            file_path = os.path.join(root, name)
            try:
                os.remove(file_path)
            except Exception as e:
                logger.error(f"Error removing file {file_path}: {e}")
        for name in dirs:
            dir_path = os.path.join(root, name)
            try:
                os.rmdir(dir_path)
            except Exception as e:
                logger.error(f"Error removing directory {dir_path}: {e}")
    logger.info("Cleanup complete.")

async def test_dataset(chatbot: Chat, begin_id = 0, end_id = 10):
    dataset_name = "mistral0105/exebench_io_validated_full_cleaned"
    ds = load_dataset(dataset_name)["train"]
    logger.info(f"Loaded dataset {dataset_name} with {len(ds)} samples.")
    tmp_dir = "sandbox/tmp"
    os.makedirs(tmp_dir, exist_ok=True)
    logger.info(f"Temporary directory created at {tmp_dir}.")
    cleanup(tmp_dir)
    logger.info("Initial Cleanup complete.")
    os.chdir(tmp_dir)
    logger.info(f"Changed working directory to {tmp_dir}.")

    
    passed_id = []
    failed_id = []
    
    async def process_item(case_id, data, sem):
        async with sem:
            id = 0
            x86_id = None
            for name in data["asm"]["target"]:
                if name == "real_gcc_x86_O0":
                    x86_id = id
                else:
                    id += 1
            if x86_id is None:
                logger.warning(f"No x86 assembly found for sample {case_id}.")
                return
            x86_code = data["asm"]["code"][x86_id]
            c_deps: str = data["real_deps"]
            c_deps = c_deps[: c_deps.rfind("# 1")]
            c_code = c_deps
            c_code += data["func_def"]
            c_exe = data["real_exe_wrapper"]
            if c_exe == None:
                logger.warning(f"No executable found for sample {case_id}.")
                return
            c_exe_cleaned = c_exe
            start = c_exe.find("""extern "C" {""")
            end = c_exe.find("}", start + 1)
            func_decl = data["func_def"]
            end2 = func_decl.find("{", start + 1)
            func_decl = func_decl[:end2]
            c_exe_cleaned = (
                c_exe[:start]
                + 'extern "C" {\n'
                + func_decl
                + ";\n}\n"
                + c_exe[end + 1 :]
            )
            start = c_exe_cleaned.find("#include <clib/synthesizer.h")
            end = c_exe_cleaned.find(">", start + 1)
            c_exe_cleaned2 = c_exe_cleaned[:start] + c_exe_cleaned[end + 1 :]
            final_c_exe = c_exe_cleaned2
            inputs = data["real_io_pairs"]["input"]
            outputs = data["real_io_pairs"]["output"]
            if len(inputs) == 0 and len(outputs) == 0:
                logger.warning(f"No inputs or outputs found for sample {case_id}.")
                return
            var_values_dict: dict = {}
            out_dict: dict = {}
            out_count = 0
            input_count = 0
            for pair in inputs:
                input_count += 1
                for i in range(len(pair["var"])):
                    var = pair["var"][i]
                    value = pair["value"][i]
                    if var not in var_values_dict:
                        var_values_dict[var] = []
                    cur_values = var_values_dict[var]
                    cur_values.append(value)
            for pair in outputs:
                out_count += 1
                for i in range(len(pair["var"])):
                    var = pair["var"][i]
                    value = pair["value"][i]
                    if var not in out_dict:
                        out_dict[var] = []
                    out_dict[var].append(value)
            if not os.path.exists(f"input_{case_id}"):
                os.mkdir(f"input_{case_id}")
            os.chdir(f"input_{case_id}")
            for i in range(input_count):
                data_file = open(f"in{i}.json", "w")
                data_file.write("{\n")
                for j, (k, v) in enumerate(var_values_dict.items()):
                    value = v[i]
                    data_file.write(f'    "{k}": {value}')
                    if j != len(var_values_dict) - 1:
                        data_file.write(",")
                    data_file.write("\n")
                data_file.write("}")
                data_file.close()
            os.chdir("..")
            if not os.path.exists(f"output_{case_id}"):
                os.mkdir(f"output_{case_id}")
            os.chdir(f"output_{case_id}")
            for i in range(out_count):
                data_file = open(f"out{i}.json", "w")
                data_file.write("{\n")

                for j, (k, v) in enumerate(out_dict.items()):
                    value = v[i]
                    data_file.write(f'    "{k}": {value}')
                    if j != len(out_dict) - 1:
                        data_file.write(",")
                    data_file.write("\n")
                data_file.write("}\n")
                data_file.close()
            os.chdir("..")
            
            with open(f"tmp_{case_id}.c", "w") as f:
                if c_code is not None:
                    f.write(c_code)
                    f.close()
            logger.info(f"C code {case_id}:\n{c_code}")

            with open(f"tmp_ref_{case_id}.s", "w") as f:
                if x86_code is not None:
                    f.write(x86_code)
                    f.close()
            with open(f"tmp_driver_{case_id}.cpp", "w") as f:
                if final_c_exe is not None:
                    f.write(final_c_exe)
                    f.close()
            ret = subprocess.run(
                ["g++", "-S", f"tmp_driver_{case_id}.cpp", "-o", f"tmp_driver_{case_id}.s"],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
            if ret.returncode != 0:
                logger.warning(f"Driver Code Compilation error: {ret.stderr.decode()}")
                return
            
            with open(f"tmp_{case_id}.c", "r") as f:
                c_code = f.read()
            
                    
            await asyncio.to_thread(
                llm_compile,
                chatbot,
                c_code,
                case_id,
            )
            ret = subprocess.run(
                ["g++", f"tmp_{case_id}.s", f"tmp_driver_{case_id}.s", "-o", f"tmp_{case_id}"],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
            if ret.returncode != 0:
                logger.warning(f"Compilation error: {ret.stderr.decode()}")
                return
            local_err = 0
            local_succ = 0
            for j in range(input_count):
                try:
                    ret = subprocess.run(
                        [f"./tmp_{case_id}", f"input_{case_id}/in{j}.json", f"output_{case_id}/out{j}_real.json"],
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE,
                        timeout=10,
                    )
                except subprocess.TimeoutExpired:
                    logger.warning(
                        f"WARNING: code execute timeout for input {j} in case {case_id}"
                    )
                    local_err += 1
                    break
                if ret.returncode != 0:
                    logger.warning(
                        f"WARNING: code failed to execute for input {j} in case {case_id}"
                    )
                    local_err += 1
                    break
                # compare the output with the expected output
                with open(f"output_{case_id}/out{j}_real.json", "r") as f:
                    real_output = f.read()
                with open(f"output_{case_id}/out{j}.json", "r") as f:
                    expected_output = f.read()
                try:
                    json_my = json.loads(real_output)
                    json_ref = json.loads(expected_output)
                except json.JSONDecodeError:
                    logger.error(f"SKIP: json decode failed for input {j}")
                    local_err += 1
                    break
                if json_my == json_ref:
                    local_succ += 1
                else:
                    local_err += 1
            logger.info(f"Local error rate {case_id}: {local_err*100/input_count}%")
            if local_err == 0:
                logger.info(f"Sample {case_id} passed.")
                passed_id.append(case_id)
            else:
                logger.info(f"Sample {case_id} failed.")
                # log failed asm
                with open(f"tmp_{case_id}.s", "r") as f:
                    failed_asm = f.read()
                logger.info(f"Failed assembly code {case_id}:\n{failed_asm}")
                failed_id.append(case_id)
    tasks = []
    sem = asyncio.Semaphore(20)  # Limit concurrent tasks
    for case_id, data in enumerate(ds):
        if case_id < begin_id:
            continue
        if case_id >= end_id:
            break
        tasks.append(asyncio.create_task(
            process_item(case_id, data, sem)
        ))
    await asyncio.gather(*tasks)
    logger.info("All tasks completed.")
    logger.info(f"Passed IDs: {passed_id}")
    logger.info(f"Failed IDs: {failed_id}")
    logger.info(f"Pass rate:{len(passed_id)*100 / (end_id - begin_id)}%")
            
            
    

def main():
    model_name = "deepseek-chat"  # Example model name
    client = get_client(model_name)
    logger.info(f"Client created for model {model_name}.")
    chatbot = Chat(client, model_name, system_prompt=x86_compile_prompt)
    logger.info("Starting test_dataset...")
    asyncio.run(
        test_dataset(
            chatbot,
            begin_id=0,
            end_id=20,
        )
    )

if __name__ == "__main__":
    main()