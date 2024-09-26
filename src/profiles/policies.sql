ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow authorized select access with company id" ON public.profiles;
CREATE POLICY "Allow authorized select access with company id"
ON public.profiles
FOR SELECT
USING (
  -- Check if the user is authorized for 'profiles.select'
  (SELECT authorize('profiles.select.company') AND  (auth.jwt() ->> 'company_id')::UUID = company_id)
);