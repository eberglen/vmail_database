ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;

-- Deny direct SELECT access
CREATE POLICY "Deny all direct SELECT access"
ON contacts
FOR SELECT
USING (false);

-- Deny direct INSERT access
CREATE POLICY "Deny all direct INSERT access"
ON contacts
FOR INSERT
WITH CHECK (false);  -- Must use WITH CHECK for INSERT

-- Deny direct UPDATE access
CREATE POLICY "Deny all direct UPDATE access"
ON contacts
FOR UPDATE
USING (false);

-- Deny direct DELETE access
CREATE POLICY "Deny all direct DELETE access"
ON contacts
FOR DELETE
USING (false);
