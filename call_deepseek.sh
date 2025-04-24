# bin bash
# bash call_deepseek.sh system_message user_message
curl https://api.deepseek.com/chat/completions -H "Content-Type: application/json" -H "Authorization: Bearer xxxx" -d '{ "model": "deepseek-chat", "messages": [ {"role": "system", "content": xxx}, {"role": "user", "content": yyy}],"stream": false, "temperature": 0.0,}'