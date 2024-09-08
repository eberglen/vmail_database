-- Grant usage on the schema to the supabase_auth_admin role
GRANT USAGE ON SCHEMA public TO supabase_auth_admin;

-- Grant execute permission on the custom function to the supabase_auth_admin role
GRANT EXECUTE ON FUNCTION public.custom_access_token_hook TO supabase_auth_admin;

-- Grant select permissions on the users table to the supabase_auth_admin role
GRANT SELECT ON public.users TO supabase_auth_admin;

-- Grant select permissions on the roles table to the supabase_auth_admin role
GRANT SELECT ON public.roles TO supabase_auth_admin;

-- Grant select permissions on the companies table to the supabase_auth_admin role
GRANT SELECT ON public.companies TO supabase_auth_admin;

-- Revoke execute permission on the custom function from all roles except supabase_auth_admin
REVOKE EXECUTE ON FUNCTION public.custom_access_token_hook FROM authenticated, anon, public;

-- Revoke all permissions on the users table from all roles except supabase_auth_admin
REVOKE ALL ON public.users FROM authenticated, anon, public;

-- Revoke all permissions on the roles table from all roles except supabase_auth_admin
REVOKE ALL ON public.roles FROM authenticated, anon, public;

-- Revoke all permissions on the companies table from all roles except supabase_auth_admin
REVOKE ALL ON public.companies FROM authenticated, anon, public;

-- Create a policy to allow supabase_auth_admin to read from the users table
CREATE POLICY "Allow auth admin to read users" ON public.users
AS PERMISSIVE FOR SELECT
TO supabase_auth_admin
USING (true);

-- Create a policy to allow supabase_auth_admin to read from the roles table
CREATE POLICY "Allow auth admin to read roles" ON public.roles
AS PERMISSIVE FOR SELECT
TO supabase_auth_admin
USING (true);

-- Create a policy to allow supabase_auth_admin to read from the companies table
CREATE POLICY "Allow auth admin to read companies" ON public.companies
AS PERMISSIVE FOR SELECT
TO supabase_auth_admin
USING (true);

