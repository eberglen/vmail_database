-- 1. Update insert.sql of the table
-- 2. Update tables.sql public.app_permission
-- 3. Update policies.sql of the table

-- ADD ENUM
ALTER TYPE public.app_permission ADD VALUE 'profiles.update.company';

-- ADD ROLE - PERMISSION
INSERT INTO public.role_permissions (role_id, permission)
VALUES
  ((SELECT id FROM roles WHERE role_name = 'moderator'), 'user_tokens.select.own');

-- CREATE POLICY
DROP POLICY IF EXISTS "Allow authorized delete access with company id"
ON tokens;
CREATE POLICY "Allow authorized delete access with company id"
ON public.tokens
FOR SELECT
USING (
  -- Check authorization
  (SELECT authorize('tokens.delete'))
  AND
  -- Check company_id
  (auth.jwt() ->> 'company_id')::UUID = company_id
);
