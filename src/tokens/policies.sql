-- Enable Row-Level Security
ALTER TABLE tokens ENABLE ROW LEVEL SECURITY;

-- -- Create Policy for Select Operations
-- DROP POLICY IF EXISTS read_tokens_policy ON tokens;
-- CREATE POLICY read_tokens_policy
-- ON tokens
-- FOR SELECT
-- USING (
--     -- Ensure the company_id in the tokens table matches the company_id in the JWT claims
--     tokens.company_id = current_setting('jwt.claims.company_id')::uuid
--     AND
--     (
--         -- Check if the user has the 'admin' role within the user's company
--         SELECT name
--         FROM roles, users
--         WHERE roles.id = users.role_id
--         AND user_id = auth.uid()
--     ) = 'admin'
-- );

-- Create a policy assuming 'admin' role is correctly identified
DROP POLICY IF EXISTS insert_tokens_policy ON tokens;
CREATE POLICY insert_tokens_policy
ON tokens
FOR INSERT
WITH CHECK (
  -- Substitute this with actual validation logic, e.g., if your system has roles directly available in a table
  EXISTS (
    SELECT 1
    FROM roles, users
    WHERE roles.id = users.role_id
    AND user_id = auth.uid()
    AND roles.name = 'admin'
  )
);
