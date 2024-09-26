ALTER TABLE user_tokens ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow authorized select access with company id" ON public.user_tokens;
CREATE POLICY "Allow authorized select access with company id"
ON public.user_tokens
FOR SELECT
USING (
  -- Check if the user is authorized for 'users.select'
  (SELECT authorize('user_tokens.select.company') AND
  (auth.jwt() ->> 'company_id')::UUID = (SELECT company_id FROM tokens WHERE tokens.id = token_id))
);

DROP POLICY IF EXISTS "Allow authorized update access with company id" ON public.user_tokens;
CREATE POLICY "Allow authorized update access with company id"
ON public.user_tokens
FOR UPDATE
USING (
  -- Check if the user is authorized for 'user_tokens.update'
  (SELECT authorize('user_tokens.update.company') AND
  (auth.jwt() ->> 'company_id')::UUID = (SELECT company_id FROM tokens WHERE tokens.id = token_id))
);

DROP POLICY IF EXISTS "Allow authorized delete access with company id" ON public.user_tokens;
CREATE POLICY "Allow authorized delete access with company id"
ON public.user_tokens
FOR DELETE
USING (
  -- Check if the user is authorized for 'user_tokens.delete'
  (SELECT authorize('user_tokens.delete.company') AND
  (auth.jwt() ->> 'company_id')::UUID = (SELECT company_id FROM tokens WHERE tokens.id = token_id))
);

DROP POLICY IF EXISTS "Allow authorized insert access with company id" ON public.user_tokens;
CREATE POLICY "Allow authorized insert access with company id"
ON public.user_tokens
FOR INSERT
WITH CHECK (
  -- Check if the user is authorized for 'user_tokens.insert'
  (SELECT authorize('user_tokens.insert.company') AND
  (auth.jwt() ->> 'company_id')::UUID = (SELECT company_id FROM tokens WHERE tokens.id = user_tokens.token_id))
);

-- DROP POLICY IF EXISTS "Allow authorized select access with company id" ON public.user_tokens;
--
-- CREATE POLICY "Allow authorized select access with company id"
-- ON public.user_tokens
-- FOR SELECT
-- USING (
--   -- Check if the user is authorized for 'users.select'
--   (SELECT authorize('users.select')) AND
--   (
--     -- Admin access: check if user is an admin and the token's associated company_id matches
--     (auth.jwt() ->> 'user_role')::public.app_role = 'admin' AND
--     (auth.jwt() ->> 'company_id')::UUID = (
--       SELECT company_id FROM tokens WHERE id = user_tokens.token_id
--     )
--     OR
--     -- If not admin, check if the user is selecting their own row
--     user_id = auth.uid()
--   )
-- );
