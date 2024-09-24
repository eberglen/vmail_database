ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow authorized select access with company id" ON public.profiles;
CREATE POLICY "Allow authorized select access with company id"
ON public.profiles
FOR SELECT
USING (
  -- Check if the user is authorized for 'profiles.select'
  (SELECT authorize('profiles.select')) AND
  (
    -- Admin access: check if user is an admin and company_id matches
    (auth.jwt() ->> 'user_role')::public.app_role = 'admin' AND
    (auth.jwt() ->> 'company_id')::UUID = company_id
    OR
    -- If not admin, check if the user is selecting their own row
    profiles.user_id = auth.uid()
  )
);