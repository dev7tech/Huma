from aicharactermulti import *
import base64
from supabase import create_client

#ENTER A USER ID AND A AI CHARACTER ID FOR TESTING
userid="0199d10d-19e0-4831-ba93-3e4b25b2843d"
aiprofileid="8545efd6-c0e3-4510-aca8-83c0beee8133"
conversation="bb449185-d9cd-4365-a212-133d1908b4f4"

#THE RULES :

rule="This is a conversation via text message."

#USE CASE EXAMPLE :


print("Basic chat with launched \n Here are the commands : \n/image \n/sleep \n/prompt")
usermsg=""
while usermsg!="/shutdown":
    usermsg=input("\n Your Answer :")
    #to test the image recognition capability
    if usermsg=="/image":
        imagepath=input("\n Send the path to the image :")
        with open(imagepath,"rb") as file:
            imgb64= base64.b64encode(file.read()).decode('utf-8')
        usermsg=input("\n Your Answer :")
        #send to the database the request
        query=supabase.table('chat_messages').insert({"message": usermsg, "sender_id":userid , "receiver_id":aiprofileid, "image":imgb64, "conversations_id":conversation}).execute()
    #to test the sleep function.
    elif usermsg=="/sleep":
        #send to the database the sleeping order
        query=supabase.table('chat_messages').insert({"sleep_order": True, "sender_id":userid , "receiver_id":aiprofileid, "conversations_id":conversation}).execute()
    elif usermsg=="/prompt":
        #generate a prompt
        query=supabase.table('chat_messages').insert({"prompt_request": True, "sender_id":userid , "receiver_id":aiprofileid, "conversations_id":conversation}).execute()
    #talk to the AI
    else:
        query=supabase.table('chat_messages').insert({"message": usermsg, "sender_id":userid , "receiver_id":aiprofileid, "conversations_id":conversation}).execute()
