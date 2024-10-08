ALTER TABLE sales_orders ENABLE ROW LEVEL SECURITY;

-- Deny direct SELECT access
CREATE POLICY "Deny all direct SELECT access"
ON sales_orders
FOR SELECT
USING (false);

-- Deny direct INSERT access
CREATE POLICY "Deny all direct INSERT access"
ON sales_orders
FOR INSERT
WITH CHECK (false);  -- Must use WITH CHECK for INSERT

-- Deny direct UPDATE access
CREATE POLICY "Deny all direct UPDATE access"
ON sales_orders
FOR UPDATE
USING (false);

-- Deny direct DELETE access
CREATE POLICY "Deny all direct DELETE access"
ON sales_orders
FOR DELETE
USING (false);



ALTER TABLE sales_threads ENABLE ROW LEVEL SECURITY;

-- Deny direct SELECT access
CREATE POLICY "Deny all direct SELECT access"
ON sales_threads
FOR SELECT
USING (false);

-- Deny direct INSERT access
CREATE POLICY "Deny all direct INSERT access"
ON sales_threads
FOR INSERT
WITH CHECK (false);  -- Must use WITH CHECK for INSERT

-- Deny direct UPDATE access
CREATE POLICY "Deny all direct UPDATE access"
ON sales_threads
FOR UPDATE
USING (false);

-- Deny direct DELETE access
CREATE POLICY "Deny all direct DELETE access"
ON sales_threads
FOR DELETE
USING (false);
