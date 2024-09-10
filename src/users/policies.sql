ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow read on own user"
ON users
FOR SELECT
USING (
   auth.uid() = user_id
);
