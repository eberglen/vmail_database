-- Insert sample data into the companies table
INSERT INTO public.companies (name) VALUES
('Acme Corp'),
('Beta Ltd');

-- Insert sample data into the roles table
INSERT INTO public.roles (name) VALUES
('admin'),
('mod');

-- Insert sample data into the users table
INSERT INTO public.users (user_id, company_id, role_id, created_at) VALUES
('3786f66a-ff57-4de4-b838-1613c5dfae5c',  -- Example UUID for auth_id
 (SELECT id FROM public.companies WHERE name = 'Acme Corp'), -- company_id
 (SELECT id FROM public.roles WHERE name = 'Admin'),          -- role_id
 CURRENT_TIMESTAMP),                                         -- created_at

('fa362ef0-2c16-48e5-9ba0-68f88962f085',  -- Example UUID for auth_id
 (SELECT id FROM public.companies WHERE name = 'Beta Ltd'),   -- company_id
 (SELECT id FROM public.roles WHERE name = 'User'),           -- role_id
 CURRENT_TIMESTAMP);                                        -- created_at
