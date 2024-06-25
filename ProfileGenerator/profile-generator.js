const { createClient } = require('@supabase/supabase-js');
const OpenAI = require('openai');
const dotenv = require('dotenv');

dotenv.config();

const openai = new OpenAI({
  apiKey: process.env['OPENAI_API_KEY'], // This is the default and can be omitted
});

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_KEY;
const client = createClient(supabaseUrl, supabaseKey);

const schema = require('fs').readFileSync('./profile-schema.json', 'utf8');

(async () => {
  console.log('🟠 Generating profiles');
  const chatCompletion = await openai.chat.completions.create({
    messages: [
      {
        role: 'user',
        content: `
        Please generate me a list of profiles for an AI relationship app in JSON.
        The profiles should mimic the profile of a real person.
        Use the following schema:

        ${schema}`,
      },
    ],
    model: 'gpt-3.5-turbo',
  });

  const { profiles } = JSON.parse(chatCompletion.choices[0].message.content);

  console.log(`🟢 Inserting ${profiles.length} profiles`);
  for (let idx = 0; idx < profiles.length; idx++) {
    process.stdout.write(`\r ${idx + 1} / ${profiles.length}`);
    const profile = profiles[idx];
    const { error } = await client.from('ai_profiles').insert({
      age: profile.age,
      gender: profile.gender || '',
      location: profile.location || '',
      name: profile.name || '',
      nationality_1: profile.nationality_1 || '',
      nationality_2: profile.nationality_2 || null,
      ambitions: profile.persona?.ambitions || '',
      personal_traits:
        profile.persona?.behavior_traits?.personality_traits || [],
      work_ethic: profile.persona?.behavior_traits?.work_ethic || [],
      interpersonal_skills:
        profile.persona?.behavior_traits?.interpersonal_skills || [],
      communication_style:
        profile.persona?.behavior_traits?.communication_style || [],
      problem_solving_approach:
        profile.persona?.behavior_traits?.problem_solving_approach || [],
      leadership_style:
        profile.persona?.behavior_traits?.leadership_style || [],
      adaptability: profile.persona?.behavior_traits?.adaptability || [],
      stress_management:
        profile.persona?.behavior_traits?.stress_management || [],
      decision_making_style:
        profile.persona?.behavior_traits?.decision_making_style || [],
      motivation: profile.persona?.behavior_traits?.motivation || [],
      emotional_intelligence:
        profile.persona?.behavior_traits?.emotional_intelligence || [],
      networking_relationship_building:
        profile.persona?.behavior_traits?.networking_relationship_building ||
        [],
      cultural_competence_diversity_awareness:
        profile.persona?.behavior_traits
          ?.cultural_competence_diversity_awareness || [],
      risk_management_decision_making:
        profile.persona?.behavior_traits?.risk_management_decision_making || [],
      assertiveness_conflict_resolution:
        profile.persona?.behavior_traits?.assertiveness_conflict_resolution ||
        [],
      hobbies: profile.persona?.hobbies || [],
      friends: (profile.friends || []).map((friend) => ({
        name: friend.name || '',
        age: friend.age || null,
        gender: friend.gender || '',
        relationship: friend.relationship || '',
      })),
      family: (profile.family || []).map((family) => ({
        name: family.name || '',
        age: family.age || null,
        gender: family.gender || '',
        relationship: family.relationship || '',
      })),
      pets: (profile.pets || []).map((pet) => ({
        name: pet.name || '',
        species: pet.species || '',
        breed: pet.breed || '',
        age: pet.age || null,
      })),
      hair_color: profile.physical_traits.hair_color || '',
      eyes_color: profile.physical_traits.eyes_color || '',
      eyes_shape: profile.physical_traits.eyes_shape || '',
      build: profile.physical_traits.build || '',
      smile: profile.physical_traits.smile || '',
      body_art: profile.physical_traits.body_art || null,
      body_peculiarities: profile.physical_traits.body_peculiarities || null,
      physical_description: profile.physical_description || '',
      behavioral_description: profile.behavioral_description || '',
      dress_style: profile.dress_style || '',
      race: profile.race || '',
    });

    if (error) {
      console.error(`Error inserting profile ${idx + 1}`, error);
    }
  }

  console.log('\n🚀 Finished inserting profiles');
})();
