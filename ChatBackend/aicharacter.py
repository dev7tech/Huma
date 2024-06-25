import ollama
import os
from ollama._types import Options
from dotenv import dotenv_values
from supabase import create_client, Client
current_directory = os.path.dirname(os.path.abspath(__file__))

env_vars = dotenv_values('.env')
url: str = env_vars.get("SUPABASE_URL")
key: str = env_vars.get("SUPABASE_KEY")
supabase: Client = create_client(url, key)
class Character():
    def __init__(self,aiid):
        # Fetch specified columns for the specified character id
        self.aiid=aiid
        query = supabase.from_("ai_profiles").select("name, age, physical_description, behavioral_description").eq("id", aiid).execute()
        self.name=""
        self.personna = ""

        character_data = query.data
        if character_data:
            
            for key, value in character_data[0].items():
                if key=='name':
                    self.name=value
                self.personna += f"{key}: {value}\n"
        else:
            print("No data found for character id: ", aiid)


class AIConversation():
    def __init__(self,llm,character,debugmode=False):
        self.character=character
        self.llm=llm
        self.precisememory=""
        self.sumemory=""
        self.tmp="""{{.Prompt}}"""
        self.modifiedMemories= []
        self.listmemory = ""
        self.prompt=""
        self.debugmode=debugmode
        self.memoryid=""




    def talk(self,userid,sentence,image=None,item=None,rule=""):
        if self.debugmode:
            print("\n--Thinking--\n")
            #VISUALISATION FROM POTENTIAL IMAGES
            imagedesc=""
            if image!=None: 
                preimagedesc=ollama.generate(model="llava",prompt="You are like the second of someone eye, describe what do you see",images=[image],keep_alive=0)
                imagedesc="*"+self.character.name+" sees a photo from this : "+preimagedesc['response']+"*"
        try:
            #Load short term memory
            query = supabase.from_("ai_memories").select("shortmemory,id").eq("ai_profiles_id", self.character.aiid).eq("profiles_id", userid).execute()
            shortmemory = query.data[0]['shortmemory']
            #keeping memory id
            self.memoryid= query.data[0]['id']
            #Obtaining username 
            query = supabase.from_("profiles").select("name").eq("id", userid).execute()
            username=query.data[0]['name']
            #RESEARCH IN MEMORY OF IMPORTANT TERMS
            nounprompt="""[INST] Instruction: Identify common and proper noun necessary for """ + self.character.name + """ to understand the conversation or the people involved. [/INST]

    Example conversation:

    Yanis: It's hot today in this house, isn't it?
    Response:
    (yanis,house)

    Your conversation:

    """ + shortmemory + """
    """ + username + ": " + sentence + """

    Response:
    ("""
            needed_mem = ollama.generate(model=self.llm,template=self.tmp,prompt=nounprompt,options=Options(stop=[")"]))
            if self.debugmode:
                print("\n--memory ressearch from these terms : " + needed_mem['response'] + " --\n")
            needed_memline=needed_mem['response']
            needed_memline = needed_memline.replace(" ", "")
            needed_memline = needed_memline.lower()
            wlist = needed_memline.split(",")

            mlist = ""
            for word in wlist:
                    #load the memory keyword
                    query=supabase.from_("memories_keywords").select("memory_list").eq("ai_memories_id", self.memoryid).eq("keyword", word).execute()
                    
                    if query.data:
                        if self.debugmode:
                            print("\n--memory found in the long term memory: " + word + " --\n")
                        #add the keyword associated list inside the context
                        mlist += word + " memory \n[\n" + query.data[0]['memory_list'] + "\n]\n"
                    else:
                        if self.debugmode:
                            print("\n--memory not found in the long term memory: " + word + " --\n")
                
            #AI ANSWER   
            self.prompt = self.character.personna + """
                    RULE :
                    -use ** to do an action , for exemple *sneeze*
                    """+rule+"""

                    Current conversation :
                    """ + self.character.name + """'S MEMORY 
                    [
            """ + mlist + """
                    ]
                    CONTEXT MEMORY
                    [
                    """ + self.listmemory + """
                    ]
                    """+self.sumemory+"""
                    """+self.precisememory+"""
                    """+username+""" : """+sentence+"""
                    """+imagedesc+"""
                    """ + self.character.name + """ : """
                
            characterAnswer=""
            if self.debugmode:
                print("\n"+self.prompt+"\n")
            #stream the answer
            for chunk in ollama.generate(model=self.llm,template=self.tmp,prompt=self.prompt,options=Options(stop=[username+" :","\n"]),stream=True):
                print(chunk['response'], end='', flush=True)
                characterAnswer+=chunk['response']
            print("\n")
            #depending of the presence of an image or an item, the thing stocked in the precise memory change.
            if imagedesc!="":
                self.precisememory+="\n"+username+ " : "+sentence+"\n"+"SYSTEM : "+imagedesc+"\n"+self.character.name+" : "+characterAnswer
            else:
                self.precisememory+="\n"+username+ " : "+sentence+"\n"+self.character.name+" : "+characterAnswer

            #write new value in the short term memory
            query = supabase.from_("ai_memories").update({"shortmemory":self.sumemory+"\n"+self.precisememory}).eq("ai_profiles_id", self.character.aiid).eq("profiles_id", userid).execute()
            return characterAnswer
            

        except Exception as e:
            print(f"Error occurred: {e}")
            print("ERROR.")







    def aftertalk(self):
        try:
            #RESSEARCH OF MEMORY TO PUT IN LIST MEMORY
            #Retrieve the short term memory
            query=supabase.from_("ai_memories").select("shortmemory").eq("id", self.memoryid).execute()
            shortmemory=query.data[0]["shortmemory"]
            #Update the list
            listmem=""
            if self.listmemory!="":
                listmem="""Old list :
                (""" + self.listmemory + """)
"""
            tomemory = ollama.generate(model=self.llm,template=self.tmp,prompt="""INSTRUCTION : Manage a list of key elements from this conversation. You have to summarize and make a clear and concise list from important informations only:

                            [""" + shortmemory + """]
    (Forbidden punctuation ":" , "=" , ".")
    If an information is irrelevant to the conversation, keep it if it's useful to the brain.
    Every new lines should contain a short information.
    You can choose to just copy the old list without changing anything if any new informations need to be managed or added.
    You can add, or modify memories from this list by following the instruction :
                
    Template list :
    (- info A
    - info B
    - etc..)

    """+listmem+"""

    New list after managment :
    (- """,options=Options(stop=[")"]))
            if self.debugmode:
                print("\n"+tomemory['response']+"\n")
            if not "NULL" in tomemory['response']:
                self.listmemory = "- " + tomemory['response']

                #write new value in the short term memory
                query = supabase.from_("ai_memories").update({"listmemory":self.listmemory}).eq("id", self.memoryid).execute()

                #PUTTING IN LONG TERM MEMORY MEMORIES
                if self.listmemory.count('\n') + 1 > 7:
                    lines = self.listmemory.splitlines()
                    for i in range(3):
                        if lines[0]!="":

                            prelongchoice = ollama.generate(model=self.llm,template=self.tmp,prompt="""Instruction : You have to choose a one word category name for an information:
                                                Example:
                                                - The cake was created by Patrick
                                                Answer:
                                                (patrick)
                                                2nd Example:
                                                - The dome is filled with demon
                                                Answer:
                                                (dome)
                                                3rd Example:
                                                """ + lines[0] + """
                                                Answer:
                                                (""",options=Options(stop=[")"]))
                            longchoice=prelongchoice['response']
                            longchoice = longchoice.lower()
                            if ' ' not in longchoice:
                                #Attach a memory to a keyword
                                #Verify if the keyword is in memory, if not, create the keyword
                                query = supabase.from_("memories_keywords").select("memory_list").eq("ai_memories_id", self.memoryid).eq("keyword", longchoice).execute()
                                #If it exist
                                if query.data:
                                    tmpmemlist=query.data[0]['memory_list']
                                    tmpmemlist+="\n" +lines[0]
                                    query = supabase.from_("memories_keywords").update({"memory_list":tmpmemlist}).eq("ai_memories_id", self.memoryid).eq("keyword", longchoice).execute()
                                #If not, we insert the keyword in the database
                                else:
                                    query = supabase.table('memories_keywords').insert({"memory_list": lines[0], "ai_memories_id": self.memoryid, "keyword":longchoice}).execute()

                                if self.debugmode:
                                    print("\n-- " + lines[0] + " --> " + longchoice + " --\n")
                                if longchoice not in self.modifiedMemories:
                                    self.modifiedMemories.append(longchoice)
                                del lines[0]
                            else:
                                print("WRONG CATEGORY PROVIDED FOR LONG TERM MEMORY STOCKING")
                        else:
                            del lines[0]
                    self.listmemory = '\n'.join(lines)
                    #update the list memory 
                    query = supabase.from_("ai_memories").update({"listmemory":self.listmemory}).eq("id", self.memoryid).execute()
            #SUMMARIZE THE PRECISE MEMORY TO MAKE IT SMALLER WHEN THE MAXIMUM SIZE IS EXCEEDED
            dialog=self.precisememory.split("\n")
            if len(dialog)>10:
                oldpart="\n".join(dialog[:5]) + "\n"
                self.precisememory = "\n".join(dialog[5:])
                sumprompt="""###INSTRUCTION : provide a comprehensive summary of the given dialogue and from the last summary. The summary should cover all the key points and main ideas presented in the original dialogue, while also condensing the information into a concise and easy-to-understand format. Please ensure that the summary includes relevant details and examples that support the main ideas, while avoiding any unnecessary information or repetition. The length of the summary should be appropriate for the length and complexity of the original dialogue, providing a clear and accurate overview without omitting any important information. The summary should always be shorter. 
                ###THE LAST SUMMARY :
                """+self.sumemory+"""
                ###THE DIALOGUE :
                """+oldpart+"""
                

        ###NEW SUMMARY :
        """
                sumemory=ollama.generate(model=self.llm,prompt=sumprompt,template=self.tmp,options=Options(stop=["#"]))
                self.sumemory=sumemory['response']
                if self.debugmode:
                    print("\n"+self.sumemory+"\n")
        except Exception as e:
            print(f"Error occurred: {e}")
            print("ERROR.")


    def healingSleep(self,userinput=None):#This function permit to refresh the memory when needed and make it more organised
        if self.debugmode:
            print("\n--Reload...--\n")
        #retrieve the memory list
        query = supabase.from_("ai_memories").select("listmemory").eq("id", self.memoryid).execute()
        self.listmemory = query.data[0]['listmemory']

        #retrieve the short memory
        query = supabase.from_("ai_memories").select("shortmemory").eq("id", self.memoryid).execute()
        shortmemory = query.data[0]['shortmemory']

        #add last memories from the conversation inside the memory list before reload
        if userinput!="nolist":
            prelistmemory=ollama.generate(model=self.llm,prompt="""You are an AI and you goal is to add to a list memories of key elements from this conversation :

                        ["""+shortmemory+"""]

            Template list :
            (- info A
            - info B
            - etc..)
            
            Old list : 
            ("""+self.listmemory+""")

            New list after addition of new memories :
            (- """,template=self.tmp,options=Options(stop=[")"]))
            self.listmemory=prelistmemory['response']

            #split the lines
            lines = self.listmemory.splitlines()
            #choose a keyword for each memory
            for line in lines:
                #WARNING code redundance here, it s ugly eww
                prelongchoice=ollama.generate(model=self.llm,prompt="""###Instruction : You have to choose a unique noun keyword for a sentence :
                Example:
                - The cake was created by Patrick
                Answer:
                (patrick)
                2nd Example:
                - The dome is filled with demon
                Answer:
                (dome)
                3rd Example:
                """+line+"""
                Answer:
                (""",template=self.tmp,options=Options(stop=[")"]))
                #transformation
                longchoice=prelongchoice['response']
                longchoice=longchoice.lower()
                #if the category didn't exist, we create the category, otherwise, we add the memory to the category
                if ' ' not in longchoice:

                    #Attach a memory to a keyword
                    #Verify if the keyword is in memory, if not, create the keyword
                    query = supabase.from_("memories_keywords").select("memory_list").eq("ai_memories_id", self.memoryid).eq("keyword", longchoice).execute()
                    #If it exist
                    if query.data:
                        tmpmemlist=query.data[0]['memory_list']
                        tmpmemlist+="\n" +line
                        query = supabase.from_("memories_keywords").update({"memory_list":tmpmemlist}).eq("ai_memories_id", self.memoryid).eq("keyword", longchoice).execute()
                    #If not, we insert the keyword in the database
                    else:
                        query = supabase.table('memories_keywords').insert({"memory_list": line, "ai_memories_id": self.memoryid, "keyword":longchoice}).execute()

                    if self.debugmode:
                        print("\n-- "+line+" --> "+longchoice+" --\n")#PUT IN COMMENT AFTER A MOMENT
                    if longchoice not in self.modifiedMemories:
                        self.modifiedMemories.append(longchoice)
                else:
                    print("\nWRONG CATEGORY PROVIDED FOR LONG TERM MEMORY STOCKING\n")
            
        #update the list memory 
        query = supabase.from_("ai_memories").update({"listmemory":self.listmemory}).eq("id", self.memoryid).execute()

        #update the short memory 
        query = supabase.from_("ai_memories").update({"shortmemory":""}).eq("id", self.memoryid).execute()

        
        #washing short memory
        self.precisememory=""
        self.sumemory=""
        #washing touched memories
        for memory in self.modifiedMemories:
            #retrieve the modified/new keyword
            query = supabase.from_("memories_keywords").select("memory_list").eq("ai_memories_id", self.memoryid).eq("keyword", memory).execute()
            insidemem=query.data[0]["memory_list"]
            print("\nthe list : "+insidemem+"\n")
            prenewmem=ollama.generate(model=self.llm,prompt="""Instruction: Simplify the list below to make it countain only the concise and useful information. Only intemporal information should remain :

The old list : 
("""+insidemem+""")

The new list :
(- """,template=self.tmp,options=Options(stop=[")"]))
            newmem="- "+prenewmem['response']
            #write inside the modified/new keyword
            query = supabase.from_("memories_keywords").update({"memory_list":newmem}).eq("ai_memories_id", self.memoryid).eq("keyword", memory).execute()
            if self.debugmode:
                print("\n---------"+memory+": \n"+newmem+"\n")
        #empty the memory list
        query = supabase.from_("ai_memories").update({"listmemory":""}).eq("id", self.memoryid).execute()
        self.modifiedMemories.clear()
        if self.debugmode:
            print("\n--Reload complete !!--\n")