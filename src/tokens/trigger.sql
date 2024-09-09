DROP TRIGGER IF EXISTS before_insert_tokens ON tokens;

CREATE OR REPLACE FUNCTION set_company_id_from_user()
RETURNS TRIGGER AS $$
BEGIN
  -- Fetch the company_id from the users table based on the current authenticated user's ID (using auth.uid())
  SELECT company_id INTO NEW.company_id
  FROM users
  WHERE user_id = auth.uid();

  -- Return the modified NEW row to be inserted
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER before_insert_tokens
BEFORE INSERT ON tokens
FOR EACH ROW
EXECUTE FUNCTION set_company_id_from_user();

