ALTER TABLE user_tokens ENABLE ROW LEVEL SECURITY;

-- Deny direct SELECT access
CREATE POLICY "Deny all direct SELECT access"
ON user_tokens
FOR SELECT
USING (false);

-- Deny direct INSERT access
CREATE POLICY "Deny all direct INSERT access"
ON user_tokens
FOR INSERT
WITH CHECK (false);  -- Must use WITH CHECK for INSERT

-- Deny direct UPDATE access
CREATE POLICY "Deny all direct UPDATE access"
ON user_tokens
FOR UPDATE
USING (false);

-- Deny direct DELETE access
CREATE POLICY "Deny all direct DELETE access"
ON user_tokens
FOR DELETE
USING (false);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Deny direct SELECT access
CREATE POLICY "Deny all direct SELECT access"
ON profiles
FOR SELECT
USING (false);

-- Deny direct INSERT access
CREATE POLICY "Deny all direct INSERT access"
ON profiles
FOR INSERT
WITH CHECK (false);  -- Must use WITH CHECK for INSERT

-- Deny direct UPDATE access
CREATE POLICY "Deny all direct UPDATE access"
ON profiles
FOR UPDATE
USING (false);

-- Deny direct DELETE access
CREATE POLICY "Deny all direct DELETE access"
ON profiles
FOR DELETE
USING (false);

ALTER TABLE roles ENABLE ROW LEVEL SECURITY;

-- Deny direct SELECT access
CREATE POLICY "Deny all direct SELECT access"
ON roles
FOR SELECT
USING (false);

-- Deny direct INSERT access
CREATE POLICY "Deny all direct INSERT access"
ON roles
FOR INSERT
WITH CHECK (false);  -- Must use WITH CHECK for INSERT

-- Deny direct UPDATE access
CREATE POLICY "Deny all direct UPDATE access"
ON roles
FOR UPDATE
USING (false);

-- Deny direct DELETE access
CREATE POLICY "Deny all direct DELETE access"
ON roles
FOR DELETE
USING (false);