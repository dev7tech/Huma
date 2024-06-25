from aicharacter import *
import base64

#ENTER A USER ID AND A AI CHARACTER ID FOR TESTING
userid="0199d10d-19e0-4831-ba93-3e4b25b2843d"
aiprofileid="8545efd6-c0e3-4510-aca8-83c0beee8133"

#THE RULES :

rule="This is a conversation via text message."

#USE CASE EXAMPLE :

#Creating the character by giving the ai profile id
character = Character(aiprofileid)
#Creating the conversation
conversation = AIConversation("mlewd",character,debugmode=True)
usermsg=""

print("Basic chat with "+character.name+" launched \n Here are the commands : \n/image \n/sleep")

while usermsg!="/shutdown":
    usermsg=input("\n Your Answer :")
    #to test the image recognition capability
    if usermsg=="/image":
        imagepath=input("\n Send the path to the image :")
        with open(imagepath,"rb") as file:
            imgb64= base64.b64encode(file.read()).decode('utf-8')
        usermsg=input("\n Your Answer :")
        conversation.talk(userid,usermsg,image=imgb64,rule=rule)
    #to test the sleep function.
    elif usermsg=="/sleep":
        conversation.healingSleep()
    #talk to the AI
    else:
        conversation.talk(userid,usermsg,rule=rule)
    #need to be used to manage the thinking proccess occuring after the answer from the AI
    conversation.aftertalk()