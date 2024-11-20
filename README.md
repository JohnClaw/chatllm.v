# chatllm.v
V-lang api wrapper for llm-inference chatllm.cpp

All credits go to original repo: https://github.com/foldl/chatllm.cpp and DeepSeek AI (https://chat.deepseek.com/) which made 99% of work. I only guided it with prompts. 

A few days ago i wrote a question in V-Discord community about V-lang bindings/wrapper for llama.cpp. And i got an answer that nobody has created them yet. I found an alternative for llama.cpp. It is called chatllm.cpp - https://github.com/foldl/chatllm.cpp. It has some limitations in comparision with llama.cpp: 1) can be run only on cpu (gpu backend is in development) 2) can be used with less model types/architectures (full list of supported models can be found here: https://github.com/foldl/chatllm.cpp/blob/master/docs/models.md) 3) as far as i know chatllm.cpp supports only q8 quantization (here it is called int8), but i'm not sure, maybe q4/int4 is also supported. However, llama.cpp hasn't c bindings. And converting a lot of c++ code to v-lang is a hard task. As for chatllm.cpp it has c bindings. I used Deepseek (https://chat.deepseek.com/) to convert c bindings to v-lang. You can compile V-code using the following command:

v main.v

Compilation also needs libchatllm.dll, libchatllm.lib, libchatllm.h. These files can be downloaded from this repo. Or you can manually download libchatllm.h from chatllm.cpp repo: https://github.com/foldl/chatllm.cpp/blob/af41d093944e7343f616df1eceae07c096e9de69/bindings/libchatllm.h Libchatllm.dll (and ggml.dll which is also needed) can be taken from WritingTools (official gui for chatllm.cpp) release zip-archive: https://github.com/foldl/WritingTools/releases/download/v1.4/Release.zip Libchatllm.lib can be produced using polib tool from Pelles C compiler suite (http://www.smorgasbordet.com/pellesc/1200/setup.exe): polib  libchatllm.dll /OUT:libchatllm.lib After compilation you should place main.exe, libchatllm.dll and ggml.dll to one folder.

To chat with main.exe you should download some ai model.
For example, qwen 2.5 1.5b: https://modelscope.cn/api/v1/models/judd2024/chatllm_quantized_qwen2.5/repo?Revision=master&FilePath=qwen2.5-1.5b.bin
Or another one: https://modelscope.cn/api/v1/models/judd2024/chatllm_quantized_gemma2_2b/repo?Revision=master&FilePath=gemma2-2b.bin
To download more models use this python script https://github.com/foldl/chatllm.cpp/blob/master/scripts/model_downloader.py as follows:
python model_downloader.py

You can also convert a custom model to int8 using this script: https://github.com/foldl/chatllm.cpp/blob/master/convert.py
python convert.py -i path/to/model -t q8_0 -o quantized.bin
After downloading some model you should put it's file to the same folder where main.exe, libchatllm.dll and ggml.dll are.
Then you can start chat app by executing this command via cmd or via .bat file: main.exe  -m gemma2-2b.bin
Here's a screenshot of V-lang compiled main.exe answering my question:
![image](https://github.com/user-attachments/assets/51377613-ce37-4664-846d-2544f6a4efef)

