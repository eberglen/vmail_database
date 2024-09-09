-- Drop existing tables if needed
DROP TABLE IF EXISTS user_tokens CASCADE;
DROP TABLE IF EXISTS tokens CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS companies CASCADE;
DROP TABLE IF EXISTS roles CASCADE;

-- Table for companies
CREATE TABLE companies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL
);

-- Table for roles
CREATE TABLE roles (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE -- Roles should have unique names
);

-- Table for users
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  user_id uuid references auth.users on delete cascade not null,  -- Supabase Auth User ID as the primary key
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE, -- Link to company, deleted when company is deleted
  role_id INTEGER REFERENCES roles(id), -- Reference to roles
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  unique (user_id)
);

-- Table for tokens
DROP TABLE IF EXISTS tokens CASCADE;

CREATE TABLE tokens (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE, -- Reference to companies instead of users
  access_token TEXT NOT NULL,
  refresh_token TEXT NOT NULL,
  expires_in INTEGER NOT NULL,
  token_type TEXT NOT NULL,
  name TEXT, -- Optional column for the user's name
  email TEXT, -- Optional column for the user's email
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

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
CREATE INDEX idx_users_role_id ON users(role_id);
