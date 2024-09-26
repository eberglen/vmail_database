ALTER TABLE roles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow authorized select access"
ON roles;
CREATE POLICY "Allow authorized select access"
ON public.roles
FOR SELECT
USING (
  (SELECT authorize('roles.select.company'))
);