ALTER TYPE public.app_permission ADD VALUE 'users.select.company';
ALTER TYPE public.app_permission ADD VALUE 'users.update.company';

insert into public.role_permissions (role_id, permission)
values
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'users.select.company'),
   ((SELECT id FROM roles WHERE role_name = 'admin'), 'users.update.company');


-- insert and delete is handled by edge function