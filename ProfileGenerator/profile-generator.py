#!/usr/bin/env python3

import json
import pathlib
import os
from dotenv import load_dotenv
from openai import OpenAI
from pprint import pprint

load_dotenv()

client = OpenAI(
    api_key=os.environ.get("OPENAI_API_KEY"),
)

schema = pathlib.Path("profile-schema.json").read_text()

chat_completion = client.chat.completions.create(
    messages=[
        {
            "role": "user",
            "content": f"""
            Please generate me a list of profiles for an AI relationship app in JSON. 
            The profiles should mimic the profile of a real person.
            Use the following schema:

            {schema}"""
        }
    ],
    model="gpt-3.5-turbo",
    response_format={ "type": "json_object" }
)

response_json = json.loads(chat_completion.choices[0].message.content)
pprint(response_json)

from supabase import create_client, Client
supabase_url: str = os.environ.get("SUPABASE_URL")
supabase_key: str = os.environ.get("SUPABASE_ANON_KEY")
supabase: Client = create_client(supabase_url, supabase_key)

#data, count = supabase.table('ai_profiles')
#  .insert({"id": 1, "name": "Denmark"})
#  .execute()