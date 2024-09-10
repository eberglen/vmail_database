-- Drop existing tables if needed
DROP TABLE IF EXISTS user_tokens CASCADE;
DROP TABLE IF EXISTS tokens CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS companies CASCADE;
DROP TABLE IF EXISTS role_permissions CASCADE;

-- Custom types
create type public.app_permission as enum (
'tokens.insert',
'tokens.select',
'tokens.update'
);

create type public.app_role as enum ('admin', 'moderator');

-- Table for companies
CREATE TABLE companies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL
);

-- Table for users
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,  -- Supabase Auth User ID
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE, -- Link to company
  role app_role NOT NULL, -- Use the app_role enum directly instead of role_id
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (user_id)
);

-- Table for tokens
DROP TABLE IF EXISTS tokens CASCADE;

CREATE TABLE tokens (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE, -- Reference to companies
  access_token TEXT NOT NULL,
  refresh_token TEXT NOT NULL,
  expires_in INTEGER NOT NULL,
  token_type TEXT NOT NULL,
  name TEXT CHECK (char_length(name) <= 36), -- Optional column for the user's name with a max length of 36 characters
  email TEXT, -- Optional column for the user's email
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  -- Ensure that the combination of email and company_id is unique
  CONSTRAINT unique_email_company UNIQUE (email, company_id)
);



-- ROLE PERMISSIONS
create table role_permissions (
  id           bigint generated by default as identity primary key,
  role         app_role not null,
  permission   app_permission not null,
  unique (role, permission)
);
comment on table public.role_permissions is 'Application permissions for each role.';

-- Index to improve performance on foreign key lookups for tokens
CREATE INDEX idx_tokens_company_id ON tokens(company_id);

-- Table for user_tokens
DROP TABLE IF EXISTS user_tokens CASCADE;

CREATE TABLE user_tokens (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(user_id) ON DELETE CASCADE, -- Reference to the users table
  token_id UUID REFERENCES tokens(id) ON DELETE CASCADE, -- Reference to the tokens table
  assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp when the token was assigned
);

-- Indexes to improve performance on foreign key lookups for user_tokens
CREATE INDEX idx_user_tokens_user_id ON user_tokens(user_id);
CREATE INDEX idx_user_tokens_token_id ON user_tokens(token_id);

-- Indexes for the users table
CREATE INDEX idx_users_company_id ON users(company_id);
