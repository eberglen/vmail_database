CREATE OR REPLACE FUNCTION upsert_token(
  p_access_token TEXT,
  p_refresh_token TEXT,
  p_expires_in INTEGER,
  p_token_type TEXT,
  p_email TEXT,
  p_name TEXT,
  p_company_id UUID
)
RETURNS VOID AS $$
DECLARE
  v_truncated_name TEXT;
BEGIN
  -- Extract company_id from the JWT

  -- Truncate name to 36 characters if it's longer
  v_truncated_name := LEFT(p_name, 36);

  -- Insert or update the token data
  INSERT INTO tokens (access_token, refresh_token, expires_in, token_type, email, name, company_id)
  VALUES (p_access_token, p_refresh_token, p_expires_in, p_token_type, p_email, v_truncated_name, p_company_id)
  ON CONFLICT (email, company_id)
  DO UPDATE SET
    access_token = EXCLUDED.access_token,
    refresh_token = EXCLUDED.refresh_token,
    expires_in = EXCLUDED.expires_in,
    token_type = EXCLUDED.token_type,
    -- Only update name if it is currently null
    name = COALESCE(NULLIF(tokens.name, ''), v_truncated_name);
END;
$$ LANGUAGE plpgsql;
