Insert your supabase informations inside the .env.example file and rename it .env

Due to the large size of the LLM, the LLM won't be in the repo.
Here is the link to download it : 

https://huggingface.co/cognitivecomputations/dolphin-2.9-llama3-8b-gguf/blob/main/dolphin-2.9-llama3-8b-q4_K_M.gguf

When downloaded, put in inside the model folder.

When this is done, launch this command to install the custom model :
ollama create dllama3 -f ./Modelfile2

Here is an explanation from every relevant files

|||examplemulti:

-Made to test the aiConversationManager
-derived from the first example program

|||aiConversationManager:

-is a queue system
-can manage many messages at the same time
-a maximum thread number is asked at first. Some testing need to be done
-read messages appearing inside the database
-send back messages from the AI in the database

|||aicharactermulti:

-the module permitting aiConversationManager to work
-derived from aicharacter

