-- Insert sample data into the companies table
INSERT INTO public.companies (name) VALUES
('Acme Corp'),
('Beta Ltd');

-- Insert sample data into the users table using the app_role enum
INSERT INTO public.users (user_id, company_id, role, created_at) VALUES
('3786f66a-ff57-4de4-b838-1613c5dfae5c',  -- Example UUID for auth_id
 (SELECT id FROM public.companies WHERE name = 'Acme Corp'), -- company_id
 'admin',                                                   -- app_role enum value
 CURRENT_TIMESTAMP),                                        -- created_at

('fa362ef0-2c16-48e5-9ba0-68f88962f085',  -- Example UUID for auth_id
 (SELECT id FROM public.companies WHERE name = 'Beta Ltd'),  -- company_id
 'moderator',                                               -- app_role enum value
 CURRENT_TIMESTAMP);                                        -- created_at


INSERT INTO tokens (
  company_id,
  access_token,
  refresh_token,
  expires_in,
  token_type,
  name,
  email
) VALUES
  ((SELECT id FROM public.companies WHERE name = 'Acme Corp'), 'access_token_001', 'refresh_token_001', 3600, 'Bearer', 'Alice Johnson', 'alice.johnson@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Acme Corp'), 'access_token_002', 'refresh_token_002', 3600, 'Bearer', 'Bob Smith', 'bob.smith@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Acme Corp'), 'access_token_003', 'refresh_token_003', 3600, 'Bearer', 'Charlie Brown', 'charlie.brown@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Acme Corp'), 'access_token_004', 'refresh_token_004', 3600, 'Bearer', 'David Wilson', 'david.wilson@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Acme Corp'), 'access_token_005', 'refresh_token_005', 3600, 'Bearer', 'Eva Davis', 'eva.davis@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Acme Corp'), 'access_token_006', 'refresh_token_006', 3600, 'Bearer', 'Frank Miller', 'frank.miller@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Acme Corp'), 'access_token_007', 'refresh_token_007', 3600, 'Bearer', 'Grace Lee', 'grace.lee@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Acme Corp'), 'access_token_008', 'refresh_token_008', 3600, 'Bearer', 'Hannah White', 'hannah.white@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Acme Corp'), 'access_token_009', 'refresh_token_009', 3600, 'Bearer', 'Ian Harris', 'ian.harris@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Beta Ltd'), 'access_token_010', 'refresh_token_010', 3600, 'Bearer', 'Jane Clark', 'jane.clark@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Beta Ltd'), 'access_token_011', 'refresh_token_011', 3600, 'Bearer', 'Kevin Lewis', 'kevin.lewis@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Beta Ltd'), 'access_token_012', 'refresh_token_012', 3600, 'Bearer', 'Laura Walker', 'laura.walker@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Beta Ltd'), 'access_token_013', 'refresh_token_013', 3600, 'Bearer', 'Mike Young', 'mike.young@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Beta Ltd'), 'access_token_014', 'refresh_token_014', 3600, 'Bearer', 'Nina King', 'nina.king@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Beta Ltd'), 'access_token_015', 'refresh_token_015', 3600, 'Bearer', 'Oliver Scott', 'oliver.scott@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Beta Ltd'), 'access_token_016', 'refresh_token_016', 3600, 'Bearer', 'Pamela Adams', 'pamela.adams@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Beta Ltd'), 'access_token_017', 'refresh_token_017', 3600, 'Bearer', 'Quincy Allen', 'quincy.allen@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Beta Ltd'), 'access_token_018', 'refresh_token_018', 3600, 'Bearer', 'Rachel Baker', 'rachel.baker@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Beta Ltd'), 'access_token_019', 'refresh_token_019', 3600, 'Bearer', 'Sam Carter', 'sam.carter@example.com'),
  ((SELECT id FROM public.companies WHERE name = 'Beta Ltd'), 'access_token_020', 'refresh_token_020', 3600, 'Bearer', 'Tina Evans', 'tina.evans@example.com');

INSERT INTO contacts (display_name, email, company_id) VALUES
('Alice Johnson', 'alice.johnson@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Bob Smith', 'bob.smith@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Charlie Brown', 'charlie.brown@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Diana Prince', 'diana.prince@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Ethan Hunt', 'ethan.hunt@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Fiona Gallagher', 'fiona.gallagher@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('George Washington', 'george.washington@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Hannah Montana', 'hannah.montana@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Iris West', 'iris.west@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Jack Daniels', 'jack.daniels@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Kelly Clarkson', 'kelly.clarkson@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Leo Messi', 'leo.messi@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Maya Angelou', 'maya.angelou@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Nina Simone', 'nina.simone@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Oliver Twist', 'oliver.twist@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Penny Lane', 'penny.lane@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Quincy Adams', 'quincy.adams@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Rachel Green', 'rachel.green@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Sam Winchester', 'sam.winchester@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Tina Fey', 'tina.fey@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Uma Thurman', 'uma.thurman@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Victor Hugo', 'victor.hugo@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Will Smith', 'will.smith@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Xena Warrior', 'xena.warrior@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Yoda Jedi', 'yoda.jedi@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722'),
('Zelda Fitzgerald', 'zelda.fitzgerald@example.com', '58f6f636-3273-4383-b63d-2ce46cab3722');


INSERT INTO sales_orders (name, order_number, status, total_amount, company_id, order_date, notes, created_at, updated_at) VALUES
('John Doe', 'ORD001', 'Pending', 150.00, '442aeb7d-5580-4b19-87bf-d470c9921cdd', '2024-09-01 10:30:00+00', 'Initial order placed by John.', NOW(), NOW()),
('Jane Smith', 'ORD002', 'Completed', 250.00, '442aeb7d-5580-4b19-87bf-d470c9921cdd', '2024-09-02 11:00:00+00', 'Order completed successfully.', NOW(), NOW()),
('Acme Corp', 'ORD003', 'Cancelled', 300.00, '442aeb7d-5580-4b19-87bf-d470c9921cdd', '2024-09-03 12:45:00+00', 'Order cancelled by the client.', NOW(), NOW()),
('Global Industries', 'ORD004', 'Pending', 120.50, '58f6f636-3273-4383-b63d-2ce46cab3722', '2024-09-04 13:20:00+00', 'Waiting for confirmation.', NOW(), NOW()),
('Tech Solutions', 'ORD005', 'Shipped', 175.75, '58f6f636-3273-4383-b63d-2ce46cab3722', '2024-09-05 14:15:00+00', 'Order has been shipped.', NOW(), NOW()),
('Widgets Inc', 'ORD006', 'In Progress', 450.00, '442aeb7d-5580-4b19-87bf-d470c9921cdd', '2024-09-06 15:30:00+00', 'Order is being processed.', NOW(), NOW()),
('XYZ Corp', 'ORD007', 'Completed', 600.25, '58f6f636-3273-4383-b63d-2ce46cab3722', '2024-09-07 09:00:00+00', 'Finalized and completed.', NOW(), NOW()),
('Alpha Tech', 'ORD008', 'Pending', 99.99, '442aeb7d-5580-4b19-87bf-d470c9921cdd', '2024-09-08 10:00:00+00', 'Pending approval.', NOW(), NOW()),
('Beta Corp', 'ORD009', 'Cancelled', 80.50, '58f6f636-3273-4383-b63d-2ce46cab3722', '2024-09-09 10:30:00+00', 'Client requested cancellation.', NOW(), NOW()),
('Gamma Solutions', 'ORD010', 'Shipped', 225.00, '442aeb7d-5580-4b19-87bf-d470c9921cdd', '2024-09-10 11:00:00+00', 'Order shipped on schedule.', NOW(), NOW()),
('Delta Widgets', 'ORD011', 'In Progress', 310.00, '58f6f636-3273-4383-b63d-2ce46cab3722', '2024-09-11 12:00:00+00', 'Currently in processing stage.', NOW(), NOW()),
('Epsilon Tech', 'ORD012', 'Completed', 470.75, '442aeb7d-5580-4b19-87bf-d470c9921cdd', '2024-09-12 13:30:00+00', 'Successfully completed.', NOW(), NOW()),
('Zeta Corp', 'ORD013', 'Pending', 320.50, '58f6f636-3273-4383-b63d-2ce46cab3722', '2024-09-13 14:45:00+00', 'Waiting for payment confirmation.', NOW(), NOW()),
('Eta Solutions', 'ORD014', 'Shipped', 199.99, '442aeb7d-5580-4b19-87bf-d470c9921cdd', '2024-09-14 09:30:00+00', 'Order has been shipped.', NOW(), NOW()),
('Theta Widgets', 'ORD015', 'In Progress', 135.00, '58f6f636-3273-4383-b63d-2ce46cab3722', '2024-09-15 11:15:00+00', 'Processing order.', NOW(), NOW()),
('Iota Tech', 'ORD016', 'Completed', 800.00, '442aeb7d-5580-4b19-87bf-d470c9921cdd', '2024-09-16 10:00:00+00', 'Completed with excellent feedback.', NOW(), NOW()),
('Kappa Corp', 'ORD017', 'Pending', 215.50, '58f6f636-3273-4383-b63d-2ce46cab3722', '2024-09-17 10:45:00+00', 'Pending client confirmation.', NOW(), NOW()),
('Lambda Solutions', 'ORD018', 'Cancelled', 150.25, '442aeb7d-5580-4b19-87bf-d470c9921cdd', '2024-09-18 12:00:00+00', 'Order cancelled by the client.', NOW(), NOW()),
('Mu Widgets', 'ORD019', 'Completed', 500.00, '58f6f636-3273-4383-b63d-2ce46cab3722', '2024-09-19 13:15:00+00', 'Successfully completed the order.', NOW(), NOW()),
('Nu Tech', 'ORD020', 'In Progress', 360.75, '442aeb7d-5580-4b19-87bf-d470c9921cdd', '2024-09-20 14:30:00+00', 'Order is currently in progress.', NOW(), NOW());
