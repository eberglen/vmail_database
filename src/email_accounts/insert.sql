-- INSERT INTO public.role_permissions (role_id, permission)
-- VALUES
--    ((SELECT id FROM roles WHERE role_name = 'admin'), 'tokens.insert'),
--    ((SELECT id FROM roles WHERE role_name = 'admin'), 'tokens.select'),
--    ((SELECT id FROM roles WHERE role_name = 'admin'), 'tokens.update'),
--    ((SELECT id FROM roles WHERE role_name = 'admin'), 'tokens.delete');


ALTER TYPE public.app_permission ADD VALUE 'tokens.select.company';
ALTER TYPE public.app_permission ADD VALUE 'tokens.update.company';
ALTER TYPE public.app_permission ADD VALUE 'tokens.delete.company';
ALTER TYPE public.app_permission ADD VALUE 'tokens.select.own';
ALTER TYPE public.app_permission ADD VALUE 'tokens.column.email';

INSERT INTO public.role_permissions (role_id, permission)
VALUES
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'tokens.select.company'),
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'tokens.update.company'),
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'tokens.delete.company'),
   ((SELECT id FROM roles WHERE role_name = 'moderator'), 'tokens.select.own'),
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'tokens.column.email');