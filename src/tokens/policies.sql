-- -- Multiple select policy with the same type causes issues, only one of them gets run
-- -- thus we combine the policy into one
-- -- Enable Row-Level Security
-- ALTER TABLE tokens ENABLE ROW LEVEL SECURITY;
--
-- DROP POLICY IF EXISTS "Allow authorized update access with company id"
-- ON tokens;
-- CREATE POLICY "Allow authorized update access with company id"
-- ON public.tokens
-- FOR UPDATE
-- USING (
--   (SELECT authorize('tokens.update'))
--   AND
--   (auth.jwt() ->> 'company_id')::UUID = company_id
-- );
--
-- DROP POLICY IF EXISTS "Allow authorized insert access with company id"
-- ON tokens;
-- CREATE POLICY "Allow authorized insert access with company id"
-- ON public.tokens
-- FOR INSERT
-- WITH CHECK (
--   (SELECT authorize('tokens.insert'))
--   AND
--   (auth.jwt() ->> 'company_id')::UUID = company_id
-- );
--
--
-- DROP POLICY IF EXISTS "Allow authorized select access with company id"
-- ON tokens;
-- CREATE POLICY "Allow authorized select access with company id"
-- ON public.tokens
-- FOR SELECT
-- USING (
--   -- Check authorization
--   (SELECT authorize('tokens.select'))
--   AND
--   -- Check company_id
--   (auth.jwt() ->> 'company_id')::UUID = company_id
-- );
--
-- DROP POLICY IF EXISTS "Allow authorized delete access with company id"
-- ON tokens;
-- CREATE POLICY "Allow authorized delete access with company id"
-- ON public.tokens
-- FOR DELETE
-- USING (
--   -- Check authorization, ensure this is a boolean function
--   (SELECT authorize('tokens.delete'))
--   AND
--   -- Check if the company_id in JWT matches the row's company_id
--   (auth.jwt() ->> 'company_id')::UUID = company_id
-- );


ALTER TABLE tokens ENABLE ROW LEVEL SECURITY;

-- Deny direct SELECT access
CREATE POLICY "Deny all direct SELECT access"
ON tokens
FOR SELECT
USING (false);

-- Deny direct INSERT access
CREATE POLICY "Deny all direct INSERT access"
ON tokens
FOR INSERT
WITH CHECK (false);  -- Must use WITH CHECK for INSERT

-- Deny direct UPDATE access
CREATE POLICY "Deny all direct UPDATE access"
ON tokens
FOR UPDATE
USING (false);

-- Deny direct DELETE access
CREATE POLICY "Deny all direct DELETE access"
ON tokens
FOR DELETE
USING (false);
