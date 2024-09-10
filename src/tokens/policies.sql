-- Enable Row-Level Security
ALTER TABLE tokens ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow authorized update access with company id"
ON tokens;
CREATE POLICY "Allow authorized update access with company id"
ON public.tokens
FOR UPDATE
USING (
  (SELECT authorize('tokens.update'))
  AND
  (auth.jwt() ->> 'company_id')::UUID = company_id
);

DROP POLICY IF EXISTS "Allow authorized insert access with company id"
ON tokens;
CREATE POLICY "Allow authorized insert access with company id"
ON public.tokens
FOR INSERT
WITH CHECK (
  (SELECT authorize('tokens.insert'))
  AND
  (auth.jwt() ->> 'company_id')::UUID = company_id
);


DROP POLICY IF EXISTS "Allow authorized select access with company id"
ON tokens;
CREATE POLICY "Allow authorized select access with company id"
ON public.tokens
FOR SELECT
USING (
  -- Check authorization
  (SELECT authorize('tokens.select'))
  AND
  -- Check company_id
  (auth.jwt() ->> 'company_id')::UUID = company_id
);