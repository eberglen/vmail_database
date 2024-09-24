CREATE OR REPLACE FUNCTION sync_user_email()
RETURNS TRIGGER AS $$
BEGIN
  -- Update the email in public.users when auth.users email is updated
  UPDATE public.users
  SET email = NEW.email
  WHERE user_id = NEW.id;  -- Match by user_id (UUID)

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER update_user_email
AFTER UPDATE OF email ON auth.users
FOR EACH ROW
WHEN (OLD.email IS DISTINCT FROM NEW.email)  -- Only trigger if the email changes
EXECUTE FUNCTION sync_user_email();
