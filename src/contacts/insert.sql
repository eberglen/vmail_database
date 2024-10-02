ALTER TYPE public.app_permission ADD VALUE 'contacts.select.company';
ALTER TYPE public.app_permission ADD VALUE 'contacts.column.email';

INSERT INTO public.role_permissions (role_id, permission)
VALUES
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'contacts.select.company'),
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'contacts.column.email'),
   ((SELECT id FROM roles WHERE role_name = 'moderator'), 'contacts.select.company');

