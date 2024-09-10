-- ADD ENUM
ALTER TYPE public.app_permission ADD VALUE 'tokens.update';

-- ADD ROLE - PERMISSION
INSERT INTO public.role_permissions (role, permission)
VALUES
  ('admin', 'tokens.update');

-- CREATE POLICY
CREATE POLICY "Allow authorized update access"
  ON public.tokens
  FOR UPDATE
  USING ((SELECT authorize('tokens.update')));
