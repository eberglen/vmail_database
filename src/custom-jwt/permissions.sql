-- Grant usage on the schema to the supabase_auth_admin role
GRANT USAGE ON SCHEMA public TO supabase_auth_admin;

-- Grant execute permission on the custom function to the supabase_auth_admin role
GRANT EXECUTE ON FUNCTION public.custom_access_token_hook TO supabase_auth_admin;

-- Grant select permissions on the profiles table to the supabase_auth_admin role
GRANT SELECT ON public.profiles TO supabase_auth_admin;

-- Grant select permissions on the companies table to the supabase_auth_admin role
GRANT SELECT ON public.companies TO supabase_auth_admin;

-- Revoke execute permission on the custom function from all roles except supabase_auth_admin
REVOKE EXECUTE ON FUNCTION public.custom_access_token_hook FROM authenticated, anon, public;

-- Revoke all permissions on the profiles table from all roles except supabase_auth_admin
REVOKE ALL ON public.profiles FROM authenticated, anon, public;

-- Revoke all permissions on the companies table from all roles except supabase_auth_admin
REVOKE ALL ON public.companies FROM authenticated, anon, public;

REVOKE ALL ON public.roles FROM authenticated, anon, public;

GRANT SELECT ON public.roles TO supabase_auth_admin;

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
-- Create a policy to allow supabase_auth_admin to read from the profiles table
CREATE POLICY "Allow auth admin to read profiles" ON public.profiles
AS PERMISSIVE FOR SELECT
TO supabase_auth_admin
USING (true);

ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
-- Create a policy to allow supabase_auth_admin to read from the companies table
CREATE POLICY "Allow auth admin to read companies" ON public.companies
AS PERMISSIVE FOR SELECT
TO supabase_auth_admin
USING (true);

ALTER TABLE roles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow auth admin to read roles" ON public.roles
AS PERMISSIVE FOR SELECT
TO supabase_auth_admin
USING (true);




