import os
import asyncio
from supabase import create_client
import threading
import time
import base64
from io import BytesIO
from PIL import Image
from dotenv import dotenv_values
from aicharactermulti import *
import random

# Initialise Supabase

env_vars = dotenv_values('.env')
supabase_url =env_vars.get("SUPABASE_URL")
supabase_key = env_vars.get("SUPABASE_KEY")
supabase = create_client(supabase_url, supabase_key)
threads_number=0

def is_url(input_string):#verify if it s an url or not
    #
    base64_pattern = r'^data:image\/[a-zA-Z]+;base64,'
    if re.match(base64_pattern, input_string):
        return False
    

    url_pattern = r'^(http|https|ftp)://'
    if re.match(url_pattern, input_string):
        return True
    
    return False



# Function managing messages
def process_message(message):
    try:
        #the chat message is received by the backend and handled, so the column received=True
        query=supabase.table('chat_messages').update({"received":True}).eq("id",message['id']).execute() 
        #Creating the character by giving the ai profile id
        character = Character(message['receiver_id'])
        #Creating the conversation
        conversation = AIConversation("mattw/hornyechidna-13b-v0.1",character,userid=message['sender_id'],debugmode=True,llm2="dolphin-llama3",convid=message['conversations_id'])
        if message['sleep_order'] :
            #let the AI sleep and manage the memory better
            conversation.healingSleep()

        if '/RELOAD' in message['message']:
            #let the AI sleep and manage the memory better ONLY FOR DEBUG PURPOSE
            conversation.healingSleep()
        elif message['prompt_request'] or '/LORA' in message['message']:#if the AI want to send an image
            query2=supabase.table('conversations').update({"waiting":character.name+" is sending a photo..."}).eq("id",message['conversations_id']).execute() 
            #tell the AI to generate a prompt
            if '/LORA' not in message['message']:
                prompt=conversation.generateprompt()
            else:
                prompt= "1 person standing"
            

            # Define the API endpoint and authentication headers
            api_url = "https://www.comfydeploy.com/api/run"
            api_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidXNlcl8yZlVmRXVaem9SOXRxZnJ0MnVuM012Z0FzTWkiLCJvcmdfaWQiOiJvcmdfMmZVZjIyZ0xxQVhnU3pjTkppTG1DQUQwdldyIiwiaWF0IjoxNzE1NjY5MzIyfQ.2EqMjbRCUdWjTMrvub7gcLAySYXUjHFZWFNv6A-0BfU"
            headers = {
                "Authorization": f"Bearer {api_key}",
                "Content-Type": "application/json"
            }

            width = 800
            height = 600

            # Define the payload
            payload = {
                "deployment_id": "1726a0c8-7190-4252-b949-327b01598d87",
                "inputs": {
                    "prompt": prompt,
                    "width": width,
                    "nationality":character.nationality,
                    "height": height,
                    "image_1": character.face,
                    "image_2": character.face,
                    "image_face": character.face,
                    "is_generated": 0,
                    "gender": character.gender,
                    "hair_length": character.hairslength,
                    "hair_style": character.hairsstyle,
                    "hair_color": character.haircolor,
                    "eye_color": character.eyescolor,
                    "is_ipadapter": 0,
                    "age": character.age,

                }
            }
            #Define the item
            if message['items_id'] or '/LORA' in message['message']:
                if '/LORA' in message['message']:
                    itmid= message['message'].replace("/LORA ","")
                    query=supabase.table('items').select('*').eq('id',message[itmid]).execute()
                else:
                    query=supabase.table('items').select('*').eq('id',message['items_id']).execute()

                #check the item
                if query.data is not None:
                    payload["inputs"]["prompt"]=prompt+", (( "+query.data[0]['trigger']+ " ))"
                    if query.data[0]['lora_link']:
                        payload["inputs"]["lora_1"]=query.data[0]['lora_link']
                        payload["inputs"]["lora_1_weights"] = 1

            # Make the POST request to generate the image
            response = requests.post(api_url, json=payload, headers=headers)
            #Active waiting, ew
            if response.status_code == 200:
                response_data = response.json()
                runid = response_data["run_id"]

                # Define the parameters for the GET request
                params = {
                    "run_id": runid
                }
                MAX_RETRIES = 5
                RETRY_DELAY = 5  

                # Poll the API to check if the image is ready
                while True:
                    response = requests.get(api_url, params=params, headers=headers)
                    if response.status_code == 200:
                        response_data = response.json()
                        print(response_data)
                        if response_data["status"] == "success":
                            # Assuming the output is an image we need
                            for output in response_data["outputs"]:
                                if "images" in output["data"]:
                                    for image in output["data"]["images"]:
                                        if image["type"] == "output":  # Check if the image is the final output
                                            image_url = image["url"]
                                            attempts = 0
                                            while attempts < MAX_RETRIES:
                                                image_response = requests.get(image_url)
                                                if image_response.status_code == 200:
                                                    # Convert image content to base64
                                                    image_base64 = base64.b64encode(image_response.content).decode('utf-8')
                                                    print("Image in base64:", image_base64)
                                                    break
                                                else:
                                                    print(f"Failed to fetch the image from the URL, attempt {attempts + 1}")
                                                    attempts += 1
                                                    time.sleep(RETRY_DELAY)  # wait before retry
                                            else:
                                                print("Max retries reached. Unable to fetch the image.")
                                            break
                            break
                        else:
                            print("Image not ready yet, waiting...")
                            time.sleep(5)  # Wait for 5 seconds before checking again
                    else:
                        print("Failed to check image status")
                        print(response.status_code)
                        print(response.text)
                        break
            else:
                print("Failed to initiate image generation")
                print(response.status_code)
                print(response.text)


            #generate the ai description of the image
            userMessage=conversation.talk("",image=image_base64,item=message['items_id'],rule=message['rules'],autoanswer="withImg")
            #send the image generated by the AI back with the img desc
            query=supabase.table('chat_messages').insert({"message": " "+userMessage, "sender_id":message['receiver_id'], "receiver_id":message['sender_id'],"ai_generated":True,"conversations_id":message['conversations_id'], "image":image_url}).execute()
            #remove the waiting indicator
            query2=supabase.table('conversations').update({"waiting":""}).eq("id",message['conversations_id']).execute() 
            conversation.aftertalk(option="noimg")
        
        elif message['message']!="":
            #let the AI answer to a message, only work if the message isn't empty
            #convert any image link into base64
            image_base64=None
            if message['image']:
                if is_url(message['image']):
                    response = requests.get(message['image'])
                    if response.status_code == 200:
                        # Convert image content to base64
                        image_base64 = base64.b64encode(response.content).decode('utf-8')
                else:
                    image_base64 = message['image']
            #make the AI talk
            userMessage=conversation.talk(message['message'],image=image_base64,item=message['items_id'],rule=message['rules'])
            if userMessage=="":
                userMessage="..."
            if not userMessage:
                raise ValueError("userMessage cannot be null or empty")
            query=supabase.table('chat_messages').insert({"message": userMessage, "sender_id":message['receiver_id'], "receiver_id":message['sender_id'],"ai_generated":True,"conversations_id":message['conversations_id']}).execute()
            #randomly, the AI will send another message right after the first one
            if not ('/IMG' in message['message'] or "end" in message['message'] or "pict" in message['message'] or "phot" in message['message'] or "imag" in message['message'] or "see" in message['message'] or "how" in message['message'] ) and message['items_id']==None:
                while random.randint(1,4)==1:
                    userMessage=conversation.talk("",rule=message['rules'],autoanswer="yes")
                    if userMessage=="":
                        break
                    else:
                        query=supabase.table('chat_messages').insert({"message": userMessage, "sender_id":message['receiver_id'], "receiver_id":message['sender_id'],"ai_generated":True,"conversations_id":message['conversations_id']}).execute()


            #remove the typing indicator
            query2=supabase.table('conversations').update({"waiting":""}).eq("id",message['conversations_id']).execute()
            #use the aftertalk function to make the ai store and manage memories
            if message['image']:
                conversation.aftertalk(option="noimg")
            else:
                conversation.aftertalk()
    except ValueError as e:
        # Handle the exception
        print(f"Exception occurred: {e}")
        # Log the exception or take other appropriate actions
        # Continue with the rest of the program
    global threads_number
    threads_number-=1

# Function listening the messages table
def listen_to_changes(maximum_threads):
    #Active waiting, must be changed
    while True:
        try:
            # listen the messages table
            messages = supabase.from_('chat_messages').select('*').eq("received", False).eq("ai_generated", False).execute()
            supabase.realtime
            # handling each message
            for message in messages.data:
                # Creating a thread for each message simultaneously
                thread = threading.Thread(target=process_message, args=(message,))
                thread.start()
                global threads_number
                threads_number+=1
                while threads_number>=maximum_threads:
                    time.sleep(1)
        except Exception as e:
            print(f"An unexpected error occurred: {e}")

        # Wait..
        time.sleep(1)

if __name__ == "__main__":
    # Launch the listening in a different thread (python threads are lame oh my god..)
    maximum_threads= 1#int(input("Enter the maximum thread number (Recommended for testing : 1) = "))
    listen_thread = threading.Thread(target=listen_to_changes,args=(maximum_threads,))
    listen_thread.start()
    # let the main program execute
    while True:
        time.sleep(10)  # Could be replaced if necessary
