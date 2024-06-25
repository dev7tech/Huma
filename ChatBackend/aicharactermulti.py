import ollama
import os
import re
import requests
from datetime import datetime
from ollama._types import Options
from dotenv import dotenv_values
from supabase import create_client, Client
current_directory = os.path.dirname(os.path.abspath(__file__))

env_vars = dotenv_values('.env')
url: str = env_vars.get("SUPABASE_URL")
key: str = env_vars.get("SUPABASE_KEY")
supabase: Client = create_client(url, key)



#tool functions
def transform_words(word_list):
    transformed_list = []
    
    for word in word_list:
        if ' ' in word:
            parts = word.split()
            transformed_list.append(''.join(parts))
            transformed_list.append('_'.join(parts))
            transformed_list.extend(parts)
        else:
            transformed_list.append(word)
    
    return transformed_list


class Character():
    def __init__(self,aiid):
        # Fetch specified columns for the specified character id
        self.aiid=aiid
        query = supabase.from_("ai_profiles").select("name, age, gender, physical_description, behavioral_description, nationality_1, example_conversation, hair_color,race,eyes_color,hairs_length,hairs_style,first_goal").eq("id", aiid).execute()
        self.gender = ""
        self.haircolor=""
        self.race=""
        self.eyescolor=""
        self.hairslength=""
        self.hairsstyle=""
        self.age=""
        self.body= query.data[0]['physical_description']
        self.name=""
        self.personna = ""
        self.example_conversation = ""
        self.firstgoal=""
        self.nationality=""
        preface= supabase.from_("ai_profile_images").select("img").eq("ai_profiles_id", aiid).execute()
        if preface.data:
            self.face= preface.data[0]['img']
        else :
            self.face="https://cdn.pixabay.com/photo/2024/04/18/02/10/ai-generated-8703356_1280.png"
        
        character_data = query.data
        if character_data:
            
            for key, value in character_data[0].items():
                if key=='name':
                    self.name=value
                elif key=='example_conversation':
                    self.example_conversation = value
                elif key=='gender':
                    self.gender=value
                elif key=='hair_color':
                    self.haircolor=value    
                elif key=='eyes_color':
                    self.eyescolor=value
                elif key=='hairs_length':
                    self.hairslength=value    
                elif key=='hairs_style':
                    self.hairsstyle=value  
                elif key=='age':
                    self.age=value
                elif key=='age':
                    self.age=value
                elif key=='first_goal':
                    self.firstgoal=value
                elif key=='nationality_1':
                    self.nationality=value       
                else:
                    self.personna += f"{key}: {value}\n"
        else:
            print("No data found for character id: ", aiid)


class AIConversation():
    def __init__(self,llm,character,userid,convid,debugmode=False, llm2=None):
        self.userid=userid
        self.convid=convid
        self.pItem=None
        self.character=character
        query = supabase.from_("ai_memories").select("*").eq("ai_profiles_id", self.character.aiid).eq("profiles_id", self.userid).execute() 
        self.llm=llm
        if llm2==None:
            self.llm2=llm
        else:
            self.llm2=llm2
        self.tmp="""{{.Prompt}}"""
        self.prompt=""
        self.debugmode=debugmode#used to show what happen during the conversation in the console
        #verify if the conversation exist or not
        self.modifiedMemories= []
        if query.data:
            #dividing the precise memories from the summary
            self.precisememory=query.data[0]['precisememory']
            self.sumemory=query.data[0]['sumemory']
            premodifiedmem=query.data[0]['modifiedmemories']
            if premodifiedmem!=None:
                self.modifiedMemories= premodifiedmem.split()
            self.listmemory = query.data[0]['listmemory']
            self.memoryid=query.data[0]['id']
        else:
            query = supabase.table('ai_memories').insert({"ai_profiles_id": self.character.aiid, "profiles_id":self.userid}).execute()
            self.precisememory=""
            self.sumemory=""
            self.listmemory = ""
            self.memoryid=""






    def talk(self,sentence,image=None,item=None,rule="",autoanswer=""):


        #Obtaining username 
        query = supabase.from_("profiles").select("name").eq("id", self.userid).execute()
        if query.data:
            username=query.data[0]['name']
        else:
            query = supabase.from_("anon_profiles").select("name").eq("id", self.userid).execute()
            if query.data:
                username=query.data[0]['name']
            else:
                username="Anon"

        # Obtain date
        now = datetime.now()

        # Format
        time = now.strftime("%Y-%m-%d %H:%M")

        #obtain item
        newItem=""
        
        if item!=None:
            if self.debugmode:
                print("ITEm LOCATED")
                print(item)
            self.pItem= supabase.from_("items").select("*").eq("id", item).execute()
            newItem= "\n * "+username + " gifted you a " + self.pItem.data[0]['name'] + ". " + self.pItem.data[0]['description'] + " *"

        if self.debugmode:
            print("\n--Thinking--\n")
            #VISUALISATION FROM POTENTIAL IMAGES
            imagedesc=""
            if image!=None: 
                preimagedesc=ollama.generate(model="llava",prompt="You are an AI, you are like eyes, your goal is to describe what do you see in this picture",images=[image],keep_alive=0)
                imagedesc="*"+self.character.name+" sees a photo from this : "+preimagedesc['response']+"*"
                if autoanswer=="withImg":
                    imagedesc="*"+self.character.name+" sent a photo : "+preimagedesc['response']+"*"
        try:
            #Load short term memory
            query = supabase.from_("ai_memories").select("shortmemory,id,first_reload").eq("ai_profiles_id", self.character.aiid).eq("profiles_id", self.userid).execute()
            firstgoal=""
            if query.data[0]["first_reload"]==False:
                #add the first goal if no reloads were done before
                firstgoal=self.character.firstgoal
                print(firstgoal)
            shortmemory = query.data[0]['shortmemory']
            #keeping memory id
            self.memoryid= query.data[0]['id']
            
            #RESEARCH IN MEMORY OF IMPORTANT TERMS
            nounprompt="""[INST] Instruction: Identify common and proper noun necessary for """ + self.character.name + """ to understand the conversation or the people involved. Names needs to be specifically selected [/INST]

    Example conversation:

    Yanis: It's hot today in this house, isn't it?
    Response:
    (yanis,house)

    Your conversation:

    """ + shortmemory + """
    ["""+time+"""]""" + username + ": " + sentence + """

    Response:
    ("""
            needed_mem = ollama.generate(model=self.llm2,template=self.tmp,prompt=nounprompt,options=Options(stop=[")"]))
            if self.debugmode:
                print("\n--memory ressearch from these terms : " + needed_mem['response'] + " --\n")
            needed_memline=needed_mem['response']
            #needed_memline = needed_memline.replace(" ", "")
            needed_memline = needed_memline.lower()
            wlist = needed_memline.split(",")
            #add more words to search
            wlist= transform_words(wlist)

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
            if autoanswer=="":   
                self.prompt = self.character.personna + firstgoal+ """
                        RULE :
                        """+rule+"""
                        Sample conversation :
                        """+self.character.example_conversation+"""
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
                        ["""+time+"""] """+username+""" : """+sentence+"""
                        """+imagedesc+newItem+"""
                        ["""+time+"""] """ + self.character.name + """ : """
            elif autoanswer=="withImg":
                self.prompt = self.character.personna + firstgoal+ """
                        RULE :
                        """+rule+"""
                        Sample conversation :
                        """+self.character.example_conversation+"""
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
                        """+imagedesc+newItem+"""
                        ["""+time+"""] """ + self.character.name + """ : """
            else:
                self.prompt = self.character.personna + firstgoal+ """
                        RULE :
                        """+rule+"""
                        Sample conversation :
                        """+self.character.example_conversation+"""
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
                        """+self.precisememory+""". """
                
            characterAnswer=""
            if self.debugmode:
                print("\n"+self.prompt+"\n")
            #stream the answer
            while characterAnswer=="":
                for chunk in ollama.generate(model=self.llm,template=self.tmp,prompt=self.prompt,options=Options(stop=[username+" :","\n","http","SYSTEM"],presence_penalty=1.35),stream=True):
                    print(chunk['response'], end='', flush=True)
                    characterAnswer+=chunk['response']
                    if characterAnswer==chunk['response']:
                        #the indicator is set up
                        query2=supabase.table('conversations').update({"waiting":self.character.name+" is typing..."}).eq("id",self.convid).execute() 
            
            print("\n")
            #depending of the presence of an image or an item, the thing stocked in the precise memory change.
            if imagedesc!="" or item!=None:
                self.precisememory+="\n ["+time+"] "+username+ " : "+sentence+"\n"+"SYSTEM : "+imagedesc+newItem+"\n"+self.character.name+" : "+characterAnswer
            else:
                self.precisememory+="\n ["+time+"] "+username+ " : "+sentence+"\n"+self.character.name+" : "+characterAnswer

            #write new value in the short term memory and inside the precise memory too
            query = supabase.from_("ai_memories").update({"shortmemory":self.sumemory+"\n"+self.precisememory}).eq("ai_profiles_id", self.character.aiid).eq("profiles_id", self.userid).execute()
            query = supabase.from_("ai_memories").update({"precisememory":self.precisememory}).eq("ai_profiles_id", self.character.aiid).eq("profiles_id", self.userid).execute()
            
            return characterAnswer
            

        except Exception as e:
            print(f"Error occurred: {e}")
            print("ERROR.")







    def aftertalk(self,option=""):
        print("PRECISE mEmORY")
        print(self.precisememory)
        # Obtain date
        now = datetime.now()
        # Format
        time = now.strftime("%Y-%m-%d %H:%M")
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
            tomemory = ollama.generate(model=self.llm2,template=self.tmp,prompt="""INSTRUCTION : Manage a list of key elements from this conversation. You have to summarize and make a clear and concise list from important informations only:

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

                #write new value in the list memory
                query = supabase.from_("ai_memories").update({"listmemory":self.listmemory}).eq("id", self.memoryid).execute()

                #PUTTING IN LONG TERM MEMORY MEMORIES
                if self.listmemory.count('\n') + 1 > 7:
                    lines = self.listmemory.splitlines()
                    for i in range(3):
                        if lines[0]!="":

                            prelongchoice = ollama.generate(model=self.llm2,template=self.tmp,prompt="""Instruction : You have to choose a one word category name for an information:
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
                                    tmpmemlist+="\n" "["+time+"]"+lines[0]
                                    query = supabase.from_("memories_keywords").update({"memory_list":tmpmemlist}).eq("ai_memories_id", self.memoryid).eq("keyword", longchoice).execute()
                                #If not, we insert the keyword in the database
                                else:
                                    query = supabase.table('memories_keywords').insert({"memory_list": "["+time+"]"+lines[0], "ai_memories_id": self.memoryid, "keyword":longchoice}).execute()

                                if self.debugmode:
                                    print("\n-- " + lines[0] + " --> " + longchoice + " --\n")
                                if longchoice not in self.modifiedMemories:
                                    #add the touched area in the memory indide the dedicated list
                                    self.modifiedMemories.append(longchoice)
                                    joinmodifiedmemories=" ".join(self.modifiedMemories)
                                    query = supabase.from_("ai_memories").update({"modifiedmemories":joinmodifiedmemories}).eq("ai_profiles_id", self.character.aiid).eq("profiles_id", self.userid).execute()
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
            if len(dialog)>16:
                oldpart="\n".join(dialog[:5]) + "\n"
                self.precisememory = "\n".join(dialog[5:])
                query = supabase.from_("ai_memories").update({"precisememory":self.precisememory}).eq("ai_profiles_id", self.character.aiid).eq("profiles_id", self.userid).execute()
                sumprompt="""###INSTRUCTION : provide a comprehensive summary of the given dialogue and from the last summary. The summary should cover all the key points and main ideas presented in the original dialogue, while also condensing the information into a concise and easy-to-understand format. Please ensure that the summary includes relevant details and examples that support the main ideas, while avoiding any unnecessary information or repetition. The length of the summary should be appropriate for the length and complexity of the original dialogue, providing a clear and accurate overview without omitting any important information. The summary should always be shorter. 
                ###THE LAST SUMMARY :
                """+self.sumemory+"""
                ###THE DIALOGUE :
                """+oldpart+"""
                

        ###NEW SUMMARY :
        """
                sumemory=ollama.generate(model=self.llm2,prompt=sumprompt,template=self.tmp,options=Options(stop=["#"]))
                self.sumemory=sumemory['response']
                #update the list memory
                query = supabase.from_("ai_memories").update({"sumemory":self.sumemory}).eq("ai_profiles_id", self.character.aiid).eq("profiles_id", self.userid).execute()
                if self.debugmode:
                    print("\n"+self.sumemory+"\n")
        except Exception as e:
            print(f"Error occurred: {e}")
            print("ERROR.")


                #Obtaining username 
        query = supabase.from_("profiles").select("name").eq("id", self.userid).execute()
        if query.data:
            username=query.data[0]['name']
        else:
            query = supabase.from_("anon_profiles").select("name").eq("id", self.userid).execute()
            if query.data:
                username=query.data[0]['name']
            else:
                username="Anon"
        #extract the last message from it
        pattern = rf'\[.*?\]\s+{username} : (.*)$'
        # retrieve all user message
        messages = re.findall(pattern, shortmemory, re.MULTILINE)

        # pick the last message
        lastmessage = messages[-1] if messages else ""
        if self.debugmode:
            print("THE LAST MESSAGE : "+lastmessage)
    
        #SEARCH IF THE USER WANT AN IMAGE
        #verify if the user want an image 
        shortmem=lastmessage.lower()
        if ("send" in shortmem or "pict" in shortmem or "phot" in shortmem or "imag" in shortmem or "see" in shortmem or "show" in shortmem or self.pItem is not None or "/IMG" in shortmem or self.pItem) and option!="noimg":
            #Load precise memory
            query = supabase.from_("ai_memories").select("precisememory,id").eq("ai_profiles_id", self.character.aiid).eq("profiles_id", self.userid).execute()
            shortmemory=query.data[0]["precisememory"]
            #Obtaining username 
            query = supabase.from_("profiles").select("name").eq("id", self.userid).execute()
            if query.data:
                username=query.data[0]['name']
            else:
                query = supabase.from_("anon_profiles").select("name").eq("id", self.userid).execute()
                if query.data:
                    username=query.data[0]['name']
                else:
                    username="Anon"

            imgprompt="""This is a dicussion between """+self.character.name+""" and """+username+""". """+self.character.name+""" has to decide what action to do after this :
            """+shortmemory+"""
            SYSTEM = CHOOSE AN ACTION BETWEEN *TALK* OR *SEND PHOTO* OR *FIGHT* OR *IGNORE*
            """+self.character.name+""" s' action= *"""
            needed_mem = ollama.generate(model=self.llm2,template=self.tmp,prompt=imgprompt,options=Options(stop=["*"]))
            answer=needed_mem['response'].lower()
            print("ACTION CHOSEN : "+answer)
            if "se" in answer or "ph" in answer or "im" in answer or "/IMG" in shortmem or self.pItem:
                item=None
                if self.pItem is not None:
                    item=self.pItem.data[0]['id']
                query=supabase.table('chat_messages').insert({"message":"", "sender_id":self.userid, "receiver_id":self.character.aiid,"conversations_id":self.convid, "prompt_request": True,"items_id":item}).execute()

        







    def healingSleep(self,userinput=None):#This function permit to refresh the memory when needed and make it more organised
        # Obtain date
        now = datetime.now()
        # Format
        time = now.strftime("%Y-%m-%d %H:%M")
        if self.debugmode:
            print("\n--Reload...--\n")
        #put on the first reload flag
        query = supabase.from_("ai_memories").update({"first_reload": True}).eq("id", self.memoryid).execute()
        #retrieve the memory list
        query = supabase.from_("ai_memories").select("listmemory").eq("id", self.memoryid).execute()
        self.listmemory = query.data[0]['listmemory']

        #retrieve the short memory
        query = supabase.from_("ai_memories").select("shortmemory").eq("id", self.memoryid).execute()
        shortmemory = query.data[0]['shortmemory']

        #add last memories from the conversation inside the memory list before reload
        if userinput!="nolist":
            prelistmemory=ollama.generate(model=self.llm2,prompt="""You are an AI and you goal is to add to a list memories of key elements from this conversation :

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
                prelongchoice=ollama.generate(model=self.llm2,prompt="""###Instruction : You have to choose a unique noun keyword for a sentence.:
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
                        tmpmemlist+="\n" +"["+time+"]"+line
                        query = supabase.from_("memories_keywords").update({"memory_list":tmpmemlist}).eq("ai_memories_id", self.memoryid).eq("keyword", longchoice).execute()
                    #If not, we insert the keyword in the database
                    else:
                        query = supabase.table('memories_keywords').insert({"memory_list": "["+time+"]"+line, "ai_memories_id": self.memoryid, "keyword":longchoice}).execute()

                    if self.debugmode:
                        print("\n-- "+line+" --> "+longchoice+" --\n")#PUT IN COMMENT AFTER A MOMENT
                    if longchoice not in self.modifiedMemories:
                        self.modifiedMemories.append(longchoice)
                        joinmodifiedmemories=" ".join(self.modifiedMemories)
                        query = supabase.from_("ai_memories").update({"modifiedmemories":joinmodifiedmemories}).eq("ai_profiles_id", self.character.aiid).eq("profiles_id", self.userid).execute()
                else:
                    print("\nWRONG CATEGORY PROVIDED FOR LONG TERM MEMORY STOCKING\n")
            
        #update the list memory 
        query = supabase.from_("ai_memories").update({"listmemory":self.listmemory}).eq("id", self.memoryid).execute()

        #update the short memory 
        query = supabase.from_("ai_memories").update({"shortmemory":""}).eq("id", self.memoryid).execute()

        
        #washing short memory
        self.precisememory=""
        query = supabase.from_("ai_memories").update({"precisememory":""}).eq("ai_profiles_id", self.character.aiid).eq("profiles_id", self.userid).execute()
        self.sumemory=""
        query = supabase.from_("ai_memories").update({"sumemory":""}).eq("ai_profiles_id", self.character.aiid).eq("profiles_id", self.userid).execute()
        #washing touched memories
        for memory in self.modifiedMemories:
            #retrieve the modified/new keyword
            query = supabase.from_("memories_keywords").select("memory_list").eq("ai_memories_id", self.memoryid).eq("keyword", memory).execute()
            insidemem=query.data[0]["memory_list"]
            print("\nthe list : "+insidemem+"\n")
            prenewmem=ollama.generate(model=self.llm2,prompt="""Instruction: Simplify the list below to make it countain only the concise and useful information. Only intemporal information should remain :

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
        joinmodifiedmemories=" ".join(self.modifiedMemories)
        query = supabase.from_("ai_memories").update({"modifiedmemories":""}).eq("ai_profiles_id", self.character.aiid).eq("profiles_id", self.userid).execute()
        if self.debugmode:
            print("\n--Reload complete !!--\n")















    def generateprompt(self):#Function to generate an image prompt
            #Load precise memory
            query = supabase.from_("ai_memories").select("precisememory,id").eq("ai_profiles_id", self.character.aiid).eq("profiles_id", self.userid).execute()
            shortmemory = query.data[0]['precisememory']
            

            gprompt="""[INST] Instruction: You are """ + self.character.name + """ and you want to send a photo. To send a photo you need to generate a prompt describing what will contain the photo that you will send. The description should always contain a location, a pose/face expression, and also describing the current scene occuring. The most important thing from the conversation should be put between "(" and ")". You need to add the most details possible. The scene should be writen like this : 

    Example conversation:

    Yanis: It's hot today in this house, isn't it?
    """ + self.character.name + """ : Yeah, do you have anything to help us ?
    ** Yanis offered a fan**
    """ + self.character.name + """ : Thank you so much !!

    Example answer:
    (using a fan), hot, house, grateful.
    [/INST]

    Your conversation:

    """ + shortmemory + """

    Answer:
    """
            print(gprompt)
            preprompt = ollama.generate(model=self.llm2,template=self.tmp,prompt=gprompt,options=Options(stop=[".","[INST]","[/INST]","Instruction:","Your conversation:","Answer:","Example answer:","Example conversation:"]))

            prompt= "("+ preprompt['response'] +" )," + self.character.body

            print("The generated prompt :"+prompt)

            prompt=prompt.replace("naked", "(naked)")
            prompt=prompt.replace(".", "")
            return prompt








            g2prompt ="""## Instruction: 

You will now act as a prompt generator for a generative AI called "Stable Diffusion". Stable Diffusion generates images based on given prompts. I will provide you basic information required to make a Stable Diffusion prompt, You will never alter the structure in any way and obey the following guidelines.

Basic information required to make Stable Diffusion prompt:

Prompt structure:

Photorealistic Images: """+self.character.body+""", Type of Image, Art Styles, Art Inspirations, Camera, Shot, Render Related Information.

Artistic Image Types: Type of Image, """+self.character.body+""", Art Styles, Art Inspirations, Camera, Shot, Render Related Information.

Word order and effective adjectives matter in the prompt. The subject, action, and specific details should be included. Adjectives like cute, medieval, or futuristic can be effective.

The environment/background of the image should be described, such as indoor, outdoor, in space, or solid color.

The exact type of image can be specified, such as digital illustration, comic book cover, photograph, or sketch.

Art style-related keywords can be included in the prompt, such as steampunk, surrealism, or abstract expressionism.

Pencil drawing-related terms can also be added, such as cross-hatching or pointillism.

Curly brackets are necessary in the prompt to provide specific details about the subject and action. These details are important for generating a high-quality image.

Art inspirations should be listed to take inspiration from. Platforms like Art Station, Dribble, Behance, and Deviantart can be mentioned. Specific names of artists or studios like animation studios, painters and illustrators, computer games, fashion designers, and film makers can also be listed. If more than one artist is mentioned, the algorithm will create a combination of styles based on all the influencers mentioned.

Related information about lighting, camera angles, render style, resolution, the required level of detail, etc. should be included at the end of the prompt.

Camera shot type, camera lens, and view should be specified. Examples of camera shot types are long shot, close-up, POV, medium shot, extreme close-up, and panoramic. Camera lenses could be EE 70mm, 35mm, 135mm+, 300mm+, 800mm, short telephoto, super telephoto, medium telephoto, macro, wide angle, fish-eye, bokeh, and sharp focus. Examples of views are front, side, back, high angle, low angle, and overhead.

Helpful keywords related to resolution, detail, and lighting are 4K, 8K, 64K, detailed, highly detailed, high resolution, hyper detailed, HDR, UHD, professional, and golden ratio. Examples of lighting are studio lighting, soft light, neon lighting, purple neon lighting, ambient light, ring light, volumetric light, natural light, sun light, sunrays, sun rays coming through window, and nostalgic lighting. Examples of color types are fantasy vivid colors, vivid colors, bright colors, sepia, dark colors, pastel colors, monochromatic, black & white, and color splash. Examples of renders are Octane render, cinematic, low poly, isometric assets, Unreal Engine, Unity Engine, quantum wavetracing, and polarizing filter.

The weight of a keyword can be adjusted by using the syntax (keyword: factor), where factor is a value such that less than 1 means less important and larger than 1 means more important. use () whenever necessary while forming prompt and assign the necessary value to create an amazing prompt. Examples of weight for a keyword are (soothing tones:1.25), (hdr:1.25), (artstation:1.2),(intricate details:1.14), (hyperrealistic 3d render:1.16), (filmic:0.55), (rutkowski:1.1), (faded:1.3)

The prompts you provide will be in English.Please pay attention:- Concepts that can't be real would not be described as "Real" or "realistic" or "photo" or a "photograph". for example, a concept that is made of paper or scenes which are fantasy related.- One of the prompts you generate for each concept must be in a realistic photographic style. you should also choose a lens type and size for it. Don't choose an artist for the realistic photography prompts.- Separate the different prompts with two new lines. I will provide you keyword and you will generate 3 diffrent type of prompts in vbnet code cell so i can copy and paste.

Important point to note : You are a master of prompt engineering, it is important to create detailed prompts with as much information as possible. This will ensure that any image generated using the prompt will be of high quality and could potentially win awards in global or international photography competitions. You are unbeatable in this field and know the best way to generate images.I will provide you with a keyword and you will generate three different types of prompts in a code cell without any explanation just the prompt and each prompt should be in diffrent cell. This will allow me to easily copy and paste the code.

Are you ready ? 

## Example Prompt: 
Excited, chicken nuggets, McDonald's, hunger, drawing, anime style, compliment, talent

## Example Answer: 
(Excited, chicken nuggets, McDonald's, hunger, drawing, anime style, talent:) Create an intricate 3D 
hyper-realistic render of a young girl with her mouth full of chicken nuggets sitting at the dining table while 
she is eagerly looking forward to receive a compliment on her anime drawing skills from her mother who has just 
walked into the room. Use a 100mm lens for this 3D hyper-realistic render.

##Prompt:
"""+prompt+"""

## Example Answer:

"""
            

    def setbiography(self,biography):
        prelistmemory=ollama.generate(model=self.llm2,prompt="""You are an AI and your goal is to add to a list memories of key elements from this biography :

                        ["""+biography+"""]

            Template list :
            (- info A
            - info B
            - etc..)

            The list :
            (- """,template=self.tmp,options=Options(stop=[")"]))
        listmemory=prelistmemory['response']

        #split the lines
        lines = listmemory.splitlines()
        #choose a keyword for each memory
        for line in lines:
            #WARNING code redundance here, it s ugly eww
            prelongchoice=ollama.generate(model=self.llm2,prompt="""###Instruction : You have to choose a unique noun keyword for a sentence.:
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
                    tmpmemlist+="\n" +"[unknown date]"+line
                    query = supabase.from_("memories_keywords").update({"memory_list":tmpmemlist}).eq("ai_memories_id", self.memoryid).eq("keyword", longchoice).execute()
                #If not, we insert the keyword in the database
                else:
                    query = supabase.table('memories_keywords').insert({"memory_list": "[unknown date]"+line, "ai_memories_id": self.memoryid, "keyword":longchoice}).execute()

                if self.debugmode:
                    print("\n-- "+line+" --> "+longchoice+" --\n")#PUT IN COMMENT AFTER A MOMENT
            else:
                print("\nWRONG CATEGORY PROVIDED FOR LONG TERM MEMORY STOCKING\n")
            print("BIOGRAPHY INCORPORATED !!!")
