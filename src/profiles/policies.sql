ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow authorized select access with company id" ON public.profiles;
CREATE POLICY "Allow authorized select access with company id"
ON public.profiles
FOR SELECT
USING (
  -- Check if the user is authorized for 'profiles.select'
  (SELECT authorize('profiles.select.company') AND  (auth.jwt() ->> 'company_id')::UUID = company_id)
);

DROP POLICY IF EXISTS "Allow authorized update access with company id" ON public.profiles;
CREATE POLICY "Allow authorized update access with company id"
ON public.profiles
FOR UPDATE
USING (
  -- Check if the user is authorized for 'profiles.update'
  (SELECT authorize('profiles.update.company') AND (auth.jwt() ->> 'company_id')::UUID = company_id)
);


-- NO need for this for now, since we dont allow insert and delete from any user, insertion and deletion happens on trigger
-- theres no permission as well

-- DROP POLICY IF EXISTS "Allow authorized insert access with company id" ON public.contacts;
-- CREATE POLICY "Allow authorized insert access with company id"
-- ON public.contacts
-- FOR INSERT
-- USING (
--   -- Check if the user is authorized for 'contacts.insert'
--   (SELECT authorize('contacts.insert.company') AND (auth.jwt() ->> 'company_id')::UUID = company_id)
-- );
--
-- DROP POLICY IF EXISTS "Allow authorized delete access with company id" ON public.contacts;
-- CREATE POLICY "Allow authorized delete access with company id"
-- ON public.contacts
-- FOR DELETE
-- USING (
--   -- Check if the user is authorized for 'contacts.delete'
--   (SELECT authorize('contacts.delete.company') AND (auth.jwt() ->> 'company_id')::UUID = company_id)
-- );
