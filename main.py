from util import get_client, get_logger
from prompts import *
import os
import json
import subprocess
from datasets import load_dataset
import concurrent.futures
import tempfile
import asyncio
import csv
import argparse
from openai import OpenAI, AsyncOpenAI
from datetime import datetime


def cleanup(path, logger):
    logger.info(f"Cleaning up temporary files in {path}...")
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


def query_model(
    client: OpenAI,
    model_name: str,
    system_prompt: str,
    user_prompt: str,
    temperature: float = 0.0,
):
    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_prompt},
    ]
    completion = client.chat.completions.create(
        model=model_name,
        temperature=temperature,
        messages=messages,
        timeout=300,
        # frequency_penalty=0.01,
    )
    response = completion.choices[0].message.content
    return response


def split_function_into_cbs(
    client: OpenAI, model_name: str, c_code: str, temperature: float = 0.0
):
    """Split C code into control blocks using the model."""
    response = client.chat.completions.create(
        model=model_name,
        messages=[
            {
                "role": "system",
                "content": lego_split_prompt,
            },
            {
                "role": "user",
                "content": c_code,
            },
        ],
        response_format={
            "type": "json_schema",
            "json_schema": {
                "name": "code_snippets",
                "strict": True,
                "schema": {
                    "type": "object",
                    "properties": {
                        "code_snippets": {
                            "type": "array",
                            "description": "An array of code snippets containing control blocks.",
                            "items": {
                                "type": "string",
                                "description": "A string representing a code snippet which may contain control blocks.",
                            },
                        }
                    },
                    "required": ["code_snippets"],
                    "additionalProperties": False,
                },
            },
        },
        temperature=0,
        max_completion_tokens=4096,
        top_p=1,
        # frequency_penalty=0,
        # presence_penalty=0,
        store=False,
    )
    # parse the response as json
    parsed_response = json.loads(response.choices[0].message.content)
    # get the code_snippets
    code_snippets: list = parsed_response["code_snippets"]
    return code_snippets

def construct_prompt(prompt, c_code):
    messages = [
        {"role": "system", "content": prompt},
        {"role": "user", "content": c_code},
    ]
    return messages

# LEGO translation
"""workflow:
1. first perform similar workflow to get a symbol tabele
2. analyze program, split program into control blocks
3. feed LLM with each control block and the global symbol table, get the assembly code in each block
4. concatenate the assembly code together
5. fix trivial errors that may caused by the split/merge process
"""

def process_item(
    case_id,
    data,
    logger,
    failed_id,
    passed_id,
    base_dir,
    fail_dir,
    model_name,
    client: OpenAI,
    prompt_style="simple",
    temperature=0.0,
):
    logger.info(f"--- Processing case {case_id} ---")
    try:
        id = 0
        x86_id = None
        for name in data["asm"]["target"]:
            if name == "real_gcc_x86_O0":
                x86_id = id
            else:
                id += 1
        if x86_id is None:
            logger.warning(f"Case {case_id} FAILED: No x86 assembly found. Skipping.")
            failed_id.append(case_id)
            return
        x86_code = data["asm"]["code"][x86_id]
        c_deps: str = data["real_deps"]
        c_deps = c_deps[: c_deps.rfind("# 1")]
        c_code = c_deps
        c_code += data["func_def"]
        c_exe = data["real_exe_wrapper"]
        if c_exe == None:
            logger.warning(
                f"Case {case_id} FAILED: No executable wrapper found. Skipping."
            )
            failed_id.append(case_id)
            return
        c_exe_cleaned = c_exe
        start = c_exe.find("""extern "C" {""")
        end = c_exe.find("}", start + 1)
        func_decl = data["func_def"]
        end2 = func_decl.find("{", start + 1)
        func_decl = func_decl[:end2]
        c_exe_cleaned = (
            c_exe[:start] + 'extern "C" {\n' + func_decl + ";\n}\n" + c_exe[end + 1 :]
        )
        start = c_exe_cleaned.find("#include <clib/synthesizer.h")
        end = c_exe_cleaned.find(">", start + 1)
        c_exe_cleaned2 = c_exe_cleaned[:start] + c_exe_cleaned[end + 1 :]
        final_c_exe = c_exe_cleaned2
        inputs = data["real_io_pairs"]["input"]
        outputs = data["real_io_pairs"]["output"]
        if len(inputs) == 0 and len(outputs) == 0:
            logger.warning(f"Case {case_id}: No inputs or outputs found. Skipping.")
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
        input_dir = os.path.join(base_dir, f"input_{case_id}")
        output_dir = os.path.join(base_dir, f"output_{case_id}")
        os.makedirs(input_dir, exist_ok=True)
        os.makedirs(output_dir, exist_ok=True)
        try:
            logger.debug(f"Case {case_id}: Writing input JSON files to {input_dir}")
            for i in range(input_count):
                with open(os.path.join(input_dir, f"in{i}.json"), "w") as data_file:
                    data_file.write("{\n")
                    for j, (k, v) in enumerate(var_values_dict.items()):
                        value = v[i]
                        data_file.write(f'    "{k}": {value}')
                        if j != len(var_values_dict) - 1:
                            data_file.write(",")
                        data_file.write("\n")
                    data_file.write("}")
            logger.debug(f"Case {case_id}: Writing output JSON files to {output_dir}")
            for i in range(out_count):
                with open(os.path.join(output_dir, f"out{i}.json"), "w") as data_file:
                    data_file.write("{\n")
                    for j, (k, v) in enumerate(out_dict.items()):
                        value = v[i]
                        data_file.write(f'    "{k}": {value}')
                        if j != len(out_dict) - 1:
                            data_file.write(",")
                        data_file.write("\n")
                    data_file.write("}\n")
            c_file_path = os.path.join(base_dir, f"tmp_{case_id}.c")
            logger.debug(f"Case {case_id}: Writing C code to {c_file_path}")
            with open(c_file_path, "w") as f:
                if c_code is not None:
                    f.write(c_code)
            logger.debug(f"Case {case_id}: C code content:\n{c_code}")
            ref_asm_path = os.path.join(base_dir, f"tmp_ref_{case_id}.s")
            logger.debug(
                f"Case {case_id}: Writing reference x86 assembly to {ref_asm_path}"
            )
            with open(ref_asm_path, "w") as f:
                if x86_code is not None:
                    f.write(x86_code)
            driver_cpp_path = os.path.join(base_dir, f"tmp_driver_{case_id}.cpp")
            logger.debug(
                f"Case {case_id}: Writing driver C++ code to {driver_cpp_path}"
            )
            with open(driver_cpp_path, "w") as f:
                if final_c_exe is not None:
                    f.write(final_c_exe)
            logger.debug(f"Case {case_id}: Driver C++ content:\n{final_c_exe}")
        except IOError as e:
            logger.error(f"Case {case_id} FAILED: File writing error: {e}")
            failed_id.append(case_id)
            return
        driver_asm_path = os.path.join(base_dir, f"tmp_driver_{case_id}.s")
        if prompt_style == "riscv_simple":
            compile_cmd = [
                "riscv64-unknown-elf-g++",
                "-S",
                driver_cpp_path,
                "-o",
                driver_asm_path,
            ]
        else:
            compile_cmd = ["g++", "-S", driver_cpp_path, "-o", driver_asm_path]
        logger.debug(f"Case {case_id}: Compiling driver code: {' '.join(compile_cmd)}")
        try:
            ret = subprocess.run(
                compile_cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                cwd=base_dir,
                check=True,
                timeout=30,
            )
            logger.debug(f"Case {case_id}: Driver compilation successful.")
        except subprocess.CalledProcessError as e:
            logger.error(
                f"Case {case_id} FAILED: Driver compilation failed. Return code: {e.returncode}"
            )
            logger.error(f"Stderr: {e.stderr.decode()}")
            failed_id.append(case_id)
            return
        except subprocess.TimeoutExpired:
            logger.error(f"Case {case_id} FAILED: Driver compilation timed out.")
            failed_id.append(case_id)
            return
        except Exception as e:
            logger.error(
                f"Case {case_id} FAILED: An unexpected error occurred during driver compilation: {e}"
            )
            failed_id.append(case_id)
            return
        logger.debug(f"Case {case_id}: Preparing request for model {model_name}")
        if prompt_style == "simple":
            messages = construct_prompt(
                x86_compile_prompt_simple, c_code
            )
        elif prompt_style == "arm_simple":
            messages = construct_prompt(
                arm_compile_prompt, c_code
            )
        elif prompt_style == "riscv_simple":
            messages = construct_prompt(
                riscv_compile_prompt, c_code
            )
        else:
            messages = construct_prompt(
                x86_compile_prompt_simple if prompt_style == "simple" else x86_compile_prompt,
                c_code,
            )
        x86_asm = None
        try:
            logger.info(f"Case {case_id}: Sending request to {model_name}...")

            completion = client.chat.completions.create(
                model=model_name,
                temperature=temperature,
                messages=messages,
                timeout=300,
                # frequency_penalty=0.01,
            )
            response = completion.choices[0].message.content

            logger.debug(f"Case {case_id}: Received response from {model_name}.")
            logger.debug(f"Case {case_id}: Raw response:\n{response}")
            try:
                if "</think>" in response:
                    thought = response.split("</think>")[0].strip()
                    logger.debug(f"Case {case_id}: Thought process:\n{thought}")
                    response_content = response.split("</think>")[-1].strip()
                else:
                    response_content = response
                # get asm from response_content, between '```asm' and '```'
                if "```asm" in response_content:
                    x86_asm = (
                        response_content.split("```asm")[-1].split("```")[0].strip()
                    )
                    logger.info(f"Case {case_id}: C source code:\n{c_code}")
                    logger.debug(
                        f"Case {case_id}: Extracted assembly:\n{x86_asm}"
                    )  # DEBUG
                else:
                    logger.warning(
                        f"Case {case_id}: No assembly found in response. Using raw response."
                    )
                    x86_asm = response_content
            except Exception as e:
                logger.error(
                    f"Case {case_id}: Error processing LLM response content: {e}"
                )
                x86_asm = response
        except Exception as e:
            logger.error(f"Case {case_id} FAILED: API call to {model_name} failed: {e}")
            failed_id.append(case_id)
            return
        if x86_asm is None or not x86_asm.strip():
            logger.error(
                f"Case {case_id} FAILED: Failed to obtain valid assembly code from the model."
            )
            failed_id.append(case_id)
            return
        logger.debug(f"Case {case_id}: Final assembly code to be used:\n{x86_asm}")
        out_asm_path = os.path.join(base_dir, f"tmp_{case_id}.s")
        try:
            logger.info(f"Case {case_id}: Writing generated assembly to {out_asm_path}")
            with open(out_asm_path, "w") as f:
                f.write(x86_asm)
        except IOError as e:
            logger.error(
                f"Case {case_id} FAILED: Failed to write generated assembly file: {e}"
            )
            failed_id.append(case_id)
            return
        executable_path = os.path.join(base_dir, f"tmp_{case_id}")
        # for riscv64, use riscv64-unknown-elf-*
        if prompt_style == "riscv_simple":
            compile_cmd = [
                "riscv64-unknown-elf-g++",
                out_asm_path,
                driver_asm_path,
                "-o",
                executable_path,
            ]
        else:
            compile_cmd = ["g++", out_asm_path, driver_asm_path, "-o", executable_path]
        logger.debug(
            f"Case {case_id}: Compiling final executable: {' '.join(compile_cmd)}"
        )
        try:
            ret = subprocess.run(
                compile_cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                cwd=base_dir,
                check=True,
                timeout=30,
            )
            logger.debug(f"Case {case_id}: Final compilation successful.")
        except subprocess.CalledProcessError as e:
            logger.error(
                f"Case {case_id} FAILED: Final compilation failed. Return code: {e.returncode}"
            )
            logger.error(f"Stderr: {e.stderr.decode()}")
            # for compilation error, we will save it as a fail reason to the file
            # we can directly append the error message to the tmp_{case_id}.s file
            with open(out_asm_path, "a") as f:
                # e.stderr.decode() may be multiple lines, so we need to join them
                compile_error_message: str = e.stderr.decode()
                # split it by lines
                compile_error_lines = compile_error_message.splitlines()
                f.write("\n# Compilation error:\n")
                for line in compile_error_lines:
                    f.write(f"# {line}\n")
                f.close()
            # copy to fail_dir
            fail_dir = os.path.join(fail_dir, f"failed_{case_id}")
            os.makedirs(fail_dir, exist_ok=True)
            with open(out_asm_path, "r") as f:
                asm_content = f.read()
            with open(os.path.join(fail_dir, f"tmp_{case_id}.c"), "w") as f:
                f.write(c_code)
            with open(os.path.join(fail_dir, f"tmp_driver_{case_id}.cpp"), "w") as f:
                f.write(final_c_exe)
            with open(os.path.join(fail_dir, f"tmp_{case_id}.s"), "w") as f:
                f.write(asm_content)
            failed_id.append(case_id)
            return
        except subprocess.TimeoutExpired:
            logger.error(f"Case {case_id} FAILED: Final compilation timed out.")
            failed_id.append(case_id)
            return
        except Exception as e:
            logger.error(
                f"Case {case_id} FAILED: An unexpected error occurred during final compilation: {e}"
            )
            failed_id.append(case_id)
            return
        local_err = 0
        local_succ = 0
        logger.debug(
            f"Case {case_id}: Starting execution and validation for {input_count} inputs."
        )
        for j in range(input_count):
            input_json_path = os.path.join(input_dir, f"in{j}.json")
            output_json_path = os.path.join(output_dir, f"out{j}.json")
            real_output_json_path = os.path.join(output_dir, f"out{j}_real.json")
            if prompt_style == "riscv_simple":
                exec_cmd = [
                    "spike",
                    "pk",
                    executable_path,
                    input_json_path,
                    real_output_json_path,
                ]
            else:
                exec_cmd = [executable_path, input_json_path, real_output_json_path]
            logger.debug(f"Case {case_id}, Input {j}: Executing: {' '.join(exec_cmd)}")
            try:
                ret = subprocess.run(
                    exec_cmd,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    timeout=10,
                    check=True,
                )
                logger.debug(f"Case {case_id}, Input {j}: Execution successful.")
                try:
                    with open(real_output_json_path, "r") as f_real:
                        real_output = f_real.read()
                    with open(output_json_path, "r") as f_expected:
                        expected_output = f_expected.read()
                    json_my = json.loads(real_output)
                    json_ref = json.loads(expected_output)
                    if json_my == json_ref:
                        logger.debug(
                            f"Case {case_id}, Input {j}: Output matches expected."
                        )
                        local_succ += 1
                    else:
                        logger.warning(f"Case {case_id}, Input {j}: Output mismatch.")
                        logger.warning(f"Expected: {json_ref}")
                        logger.warning(f"Got: {json_my}")
                        local_err += 1
                except FileNotFoundError as e:
                    logger.error(
                        f"Case {case_id}, Input {j}: Output file not found: {e}. Marking as error."
                    )
                    local_err += 1
                except json.JSONDecodeError as e:
                    logger.error(
                        f"Case {case_id}, Input {j}: JSON decode failed for output comparison: {e}. Marking as error."
                    )
                    logger.error(f"Real output content: {real_output}")
                    logger.error(f"Expected output content: {expected_output}")
                    local_err += 1
                    break
                except Exception as e:
                    logger.error(
                        f"Case {case_id}, Input {j}: Unexpected error during output comparison: {e}. Marking as error."
                    )
                    local_err += 1
                    break
            except subprocess.TimeoutExpired:
                logger.warning(f"Case {case_id}, Input {j}: Execution timed out.")
                local_err += 1
                break
            except subprocess.CalledProcessError as e:
                logger.warning(
                    f"Case {case_id}, Input {j}: Execution failed. Return code: {e.returncode}"
                )
                logger.warning(f"Stderr: {e.stderr.decode()}")
                local_err += 1
                break
            except Exception as e:
                logger.error(
                    f"Case {case_id}, Input {j}: Unexpected error during execution: {e}"
                )
                local_err += 1
                break
        if local_err == 0 and local_succ == input_count:
            logger.info(
                f"Case {case_id}: PASSED ({local_succ}/{input_count} inputs correct)."
            )
            passed_id.append(case_id)
            logger.info(f"Passed assembly code {case_id}:\n{x86_asm}")
        else:
            logger.info(
                f"Case {case_id}: FAILED ({local_err}/{input_count} inputs failed or errored)."
            )
            failed_id.append(case_id)
            logger.info(f"Failed assembly code {case_id}:\n{x86_asm}")
    except Exception as e:
        logger.error(
            f"Case {case_id} FAILED: UNEXPECTED ERROR during processing: {e}",
            exc_info=True,
        )
        if case_id not in failed_id:
            failed_id.append(case_id)
    finally:
        logger.info(f"--- Finished processing case {case_id} ---")


def test_dataset(
    dataset_name="mistral0105/exebench_io_hard2_full_cleaned",
    model_name="gemini-2.5-flash-preview-04-17",
    begin_id=0,
    end_id=994,
    logger=None,
    mask_id=None,
    prompt_style="arm_simple",
    log_name=None,
    temperature=0.0,
    max_concurrent=4,
):
    ds = load_dataset(dataset_name)["train"]
    logger.info(f"Loaded dataset {dataset_name} with {len(ds)} samples.")
    tmp_dir = "sandbox/tmp"
    fail_dir = f"sandbox/failed_{log_name}"
    os.makedirs(tmp_dir, exist_ok=True)
    os.makedirs(fail_dir, exist_ok=True)
    base_dir = os.path.abspath(tmp_dir)
    logger.info(f"Temporary directory created at {base_dir}.")
    cleanup(base_dir, logger)
    logger.info("Initial Cleanup complete.")
    client: OpenAI = get_client(model_name)

    passed_id = []
    failed_id = []

    with concurrent.futures.ThreadPoolExecutor(max_workers=max_concurrent) as executor:
        futures = []
        for case_id, data in enumerate(ds):
            if case_id < begin_id:
                continue
            if mask_id is not None and case_id in mask_id:
                logger.info(f"Case {case_id} is masked. Considered PASSED. Skipping.")
                passed_id.append(case_id)
                continue
            if case_id >= end_id:
                break
            futures.append(
                executor.submit(
                    process_item,
                    case_id,
                    data,
                    logger,
                    failed_id,
                    passed_id,
                    base_dir,
                    fail_dir,
                    model_name,
                    client,
                    prompt_style,
                    temperature,
                )
            )
        for future in concurrent.futures.as_completed(futures):
            try:
                future.result()
            except Exception as e:
                logger.error(f"Error processing case: {e}")

    logger.info("All tasks completed.")
    total_processed = len(passed_id) + len(failed_id)
    logger.info(f"--- Final Summary ---")
    logger.info(f"Model: {model_name}")
    logger.info(
        f"Processed cases: {begin_id} to {end_id-1} (Attempted: {end_id - begin_id})"
    )
    logger.info(f"Total successfully processed and validated: {len(passed_id)}")
    logger.info(f"Total failed or errored: {len(failed_id)}")
    logger.info(f"Passed IDs: {sorted(passed_id)}")
    logger.info(f"Failed IDs: {sorted(failed_id)}")
    if (end_id - begin_id) > 0:
        pass_rate = len(passed_id) * 100 / (end_id - begin_id)
        logger.info(f"Pass rate (based on attempted range): {pass_rate:.2f}%")
    else:
        logger.info("Pass rate: N/A (no cases attempted)")
    logger.info(f"---------------------")
    return failed_id, passed_id


def main():
    parser = argparse.ArgumentParser(description='LLM-as-compiler test, LEGO translation will be available soon')
    
    parser.add_argument('--dataset', type=str, default="mistral0105/exebench_io_hard2_full_cleaned",
                        help='Datasets options: mistral0105/exebench_io_validated_full_cleaned(17121) or mistral0105/exebench_io_hard2_full_cleaned (1996)')
    parser.add_argument('--model', type=str, default="gpt-4.1",
                        help='Model options')
    parser.add_argument('--prompt-style', type=str, default="arm_simple",
                        choices=["simple", "full", "arm_simple", "riscv_simple"],
                        help='translation style')
    parser.add_argument('--begin-id', type=int, default=0,
                        help='begin ID')
    parser.add_argument('--end-id', type=int, default=10,
                        help='end ID (exclusive)')
    parser.add_argument('--max-concurrent', type=int, default=1,
                        help='max concurrent tasks')
    parser.add_argument('--temperature', type=float, default=0.0,
                        help='temperature for sampling')
    parser.add_argument('--no-log', action='store_true',
                        help='no log to file')
    parser.add_argument('--use-mask', action='store_true',
                        help='use mask file to skip certain IDs, can be helpful to skip already passed IDs')
    parser.add_argument('--mask-file', type=str, default=None,
                        help='mask file path, if use --use-mask, this file should be provided')
    
    args = parser.parse_args()
    
    dataset_name = args.dataset
    model_name = args.model
    prompt_style = args.prompt_style
    begin_id = args.begin_id
    end_id = args.end_id
    max_concurrent = args.max_concurrent
    temperature = args.temperature
    need_log = not args.no_log
    use_mask = args.use_mask
    mask_csv_file = args.mask_file
    
    failed_id = []

    if not need_log:
        logger = get_logger("INFO")
        log_name = NotImplementedError
    else:
        log_dir = "logs"

        os.makedirs(log_dir, exist_ok=True)
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        log_name = f"{model_name.replace('/', '_')}_{prompt_style}_{begin_id}_{end_id}_{timestamp}"
        log_file = os.path.join(log_dir, f"{log_name}.log")
        logger = get_logger("INFO", log_file)
        logger.info(f"Logging to {log_file}")

    if use_mask:
        # if provided mask_csv_file, load the csv and get the ids as failed_id
        if mask_csv_file and os.path.exists(mask_csv_file):
            try:
                with open(mask_csv_file, "r", newline="") as csvfile:
                    reader = csv.reader(csvfile)
                    # Assuming the first row contains the comma-separated failed IDs
                    failed_id = [int(id_str) for id_str in next(reader)]
                logger.info(f"Loaded {len(failed_id)} failed IDs from {mask_csv_file}")
            except FileNotFoundError:
                logger.warning(
                    f"Mask CSV file not found: {mask_csv_file}. Proceeding without mask."
                )
                failed_id = []
            except Exception as e:
                logger.error(
                    f"Error reading mask CSV file {mask_csv_file}: {e}. Proceeding without mask."
                )
                failed_id = []
        else:
            logger.warning(
                f"Mask CSV file path not provided or file does not exist. Proceeding without mask."
            )
            failed_id = []
        if use_mask:
            mask_id = [i for i in range(begin_id, end_id) if i not in failed_id]
        else:
            mask_id = None

        logger.info(
            f"Using !IDs from {mask_csv_file} as mask (skipping these IDs): {mask_id}"
        )

    else:
        mask_id = None
    failed_id2, passed_id2 = test_dataset(
        dataset_name=dataset_name,
        model_name=model_name,
        begin_id=begin_id,
        end_id=end_id,
        logger=logger,
        mask_id=mask_id,
        prompt_style=prompt_style,
        log_name=log_name,
        max_concurrent=max_concurrent,
        temperature=temperature,
    )
    logger.info("--- Final Summary ---")
    logger.info(f"Final PASSED ids: {sorted(passed_id2)}")
    logger.info(f"Final FAILED ids: {sorted(failed_id2)}")
    if need_log and log_name:
        mask_output_dir = "masks"
        os.makedirs(mask_output_dir, exist_ok=True)
        output_csv_path = os.path.join(mask_output_dir, f"failed_ids_{log_name}.csv")
        try:
            with open(output_csv_path, "w", newline="") as csvfile:
                writer = csv.writer(csvfile)
                writer.writerow(sorted(failed_id2))
            logger.info(f"Saved {len(failed_id2)} failed IDs to {output_csv_path}")
        except Exception as e:
            logger.error(f"Error saving failed IDs to CSV {output_csv_path}: {e}")

    logger.info(
        f"Final passrate: {len(passed_id2) * 100 / (len(passed_id2) + len(failed_id2)):.3f}%"
    )


if __name__ == "__main__":
    main()
