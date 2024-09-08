-- Enable Row-Level Security
ALTER TABLE tokens ENABLE ROW LEVEL SECURITY;

-- Create Policy for Select Operations
CREATE POLICY read_tokens_policy
ON tokens
FOR SELECT
USING (
    EXISTS (
        SELECT 1
        FROM users
        WHERE users.user_id = tokens.user_id
          AND users.company_id = current_setting('jwt.claims.company_id')::uuid
          AND (
              SELECT name
              FROM roles
              WHERE id = users.role_id
          ) = 'admin'
    )
);
