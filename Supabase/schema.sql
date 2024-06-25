
CREATE OR REPLACE FUNCTION execute_schema_tables(_schema text, _query text)
RETURNS text AS
$$
DECLARE
row record;
BEGIN
FOR row IN SELECT tablename FROM pg_tables AS t
WHERE t.schemaname = _schema
LOOP
-- run query
EXECUTE format(_query, row.tablename);
END LOOP;
RETURN 'success';
END;
$$ LANGUAGE 'plpgsql';


drop table if exists public.profiles;

create table public.profiles (
    id uuid primary key default uuid_generate_v4 (),
    created_at timestamp with time zone default current_timestamp,
    updated_at timestamp with time zone default current_timestamp,

    name varchar(255) default null,
    birth_date date default null,
    email varchar(255) default null,
    show varchar(100) default null,
    profile_url text default null,
    imgs json default '[]'::json,
    push_token varchar(255) default null,
    profile_setup bool default false not null
  );


SELECT execute_schema_tables('public', 'ALTER PUBLICATION supabase_realtime ADD TABLE profiles;');

alter table public.profiles enable row level security;

create policy "update my profile" on public.profiles
for update
to authenticated
using (auth.uid() = id);

create policy "read profiles" on public.profiles
for select
to authenticated
using(true);

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id)
  values (new.id);
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

drop policy if exists "upload my own profile image" on storage.objects;
create policy "upload my own profile image"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'profiles' and
  (storage.foldername(name))[1] = auth.uid()::text
);

drop policy if exists "profile images accessible if auth" on storage.objects;
create policy "profile images accessible if auth" on storage.objects
  for select to authenticated using (bucket_id = 'profiles');


drop policy if exists "upload my own media image" on storage.objects;
create policy "upload my own media image"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'medias' and
  (storage.foldername(name))[1] = auth.uid()::text
);

drop policy if exists "media images accessible if auth" on storage.objects;
create policy "media images accessible if auth" on storage.objects
  for select to authenticated using (bucket_id = 'medias');

drop table if exists profile_visits;
create table profile_visits (
    id uuid primary key default uuid_generate_v4 (),
    created_at timestamp with time zone default current_timestamp,
    updated_at timestamp with time zone default current_timestamp,

    profile_id uuid references profiles(id) on delete cascade not null,
    user_id uuid references profiles(id) on delete cascade not null,
    is_liked boolean not null
);

alter table profile_visits add constraint unique_profile_user unique(profile_id,user_id);

alter table profile_visits enable row level security;

create policy "create my visit" on public.profile_visits
for insert
with check(auth.uid() = profile_id);

create policy "update my visit" on public.profile_visits
for update
using(auth.uid() = profile_id);

create policy "read my visit or my likes" on public.profile_visits
for select
using(auth.uid() = profile_id or auth.uid() = user_id);

drop table if exists public.chat_messages;
drop table if exists public.conversations;
drop type if exists conversation_type;
drop table if exists anon_profiles;
drop table if exists public.ai_profile_images;
drop table if exists public.ai_profiles;

create table public.ai_profiles (
    id uuid primary key default uuid_generate_v4 (),
    created_at timestamp with time zone default current_timestamp,
    updated_at timestamp with time zone default current_timestamp,

    age int not null,
    gender varchar(255) not null,
    location varchar(255) not null,
    name varchar(255) not null,
    nationality_1 varchar(255) not null,
    nationality_2 varchar(255) default null,

    -- persona
    ambitions text not null,
    personal_traits json not null,
    work_ethic json not null,
    interpersonal_skills json not null,
    communication_style json not null,
    problem_solving_approach json not null,
    leadership_style json not null,
    adaptability json not null,
    stress_management json not null,
    decision_making_style json not null,
    motivation json not null,
    emotional_intelligence json not null,
    networking_relationship_building json not null,
    cultural_competence_diversity_awareness json not null,
    risk_management_decision_making json not null,
    assertiveness_conflict_resolution json not null,
    hobbies json not null,
    
    friends json not null,
    family json not null,
    pets json not null,

    -- physical traits
    hair_color varchar(255) not null,
    eyes_color varchar(255) not null,
    eyes_shape varchar(255) not null,
    build varchar(255) not null,
    smile varchar(255) not null,
    body_art varchar(255) default null,
    body_peculiarities json default null,

    physical_description text not null,
    behavioral_description text not null,
    dress_style varchar(255) not null,
    race varchar(255) not null,

    body_type varchar(255) default null,
    body_type_weight float default null,
    lips_color varchar(255) default null,
    lips_shape varchar(255) default null,
    face_shape varchar(255) default null,
    face_shape_weight float default null,
    facial_asymmetry float default null,
    hairs_style varchar(255) default null,
    hairs_length varchar(255) default null,
    disheveled float default null,
    natural_skin float default null,
    bare_face float default null,
    washed_face float default null,
    dried_face float default null,
    skin_details float default null,
    skin_pores float default null,
    dimples float default null,
    freckles float default null,
    moles float default null,
    skin_imperfections float default null,
    eyes_details float default null,
    iris_details float default null,
    circular_iris float default null,
    circular_pupil float default null
  );

create table ai_profile_images(

    id uuid primary key default uuid_generate_v4 (),
    created_at timestamp with time zone default current_timestamp,
    updated_at timestamp with time zone default current_timestamp,

    ai_profiles_id uuid not null references  ai_profiles(id) on delete cascade,
    img text not null,
    is_default boolean default false not null
);


create table anon_profiles (
  id uuid primary key default uuid_generate_v4 (),
  created_at timestamp with time zone default current_timestamp
);

create type conversation_type as enum('anon', 'user');

create table public.conversations (
  id uuid primary key default uuid_generate_v4 (),
  created_at timestamp with time zone default current_timestamp,
  updated_at timestamp with time zone default current_timestamp,
  
  ai_profiles_id uuid not null references ai_profiles(id) on delete cascade,
  profiles_id uuid default null references profiles(id) on delete cascade,
  anon_profiles_id uuid default null references anon_profiles(id) on delete cascade,
  type conversation_type default 'user'
);

alter table public.conversations add constraint unique_anon_convo unique(anon_profiles_id,ai_profiles_id); 

create table public.chat_messages (
  id uuid primary key default uuid_generate_v4 (),
  created_at timestamp with time zone default current_timestamp,
  updated_at timestamp with time zone default current_timestamp,

  conversations_id uuid not null references conversations(id) on delete cascade,
  message text not null,
  sender_id uuid not null,
  receiver_id uuid not null,
  image text null,
  item text null,
  sleep_order boolean default false not null,
  rules text default '' not null,
  prompt_request boolean default false not null,
  received boolean default false not null,
  ai_generated boolean default false not null
);

