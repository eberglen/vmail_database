ALTER TABLE user_tokens ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow authorized select access with company id" ON public.user_tokens;

CREATE POLICY "Allow authorized select access with company id"
ON public.user_tokens
FOR SELECT
USING (
  -- Check if the user is authorized for 'users.select'
  (SELECT authorize('profiles.select')) AND
  (
    -- Admin access: check if user is an admin and the token's associated company_id matches
    (auth.jwt() ->> 'user_role')::public.app_role = 'admin' AND
    (auth.jwt() ->> 'company_id')::UUID = (
      SELECT company_id FROM tokens WHERE tokens.id = token_id
    )
    OR
    -- If not admin, check if the user is selecting their own row
    (auth.jwt() ->> 'profile_id')::INTEGER = profile_id  -- Check if the row belongs to the authenticated user
  )
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
