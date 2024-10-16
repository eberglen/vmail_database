-- Function to synchronize user email from auth.users to public.profiles
CREATE OR REPLACE FUNCTION public.sync_user_email()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public -- Set the search path if needed
AS $$
BEGIN
  -- Update the email in public.profiles when auth.users email is updated
  UPDATE public.profiles
  SET email = NEW.email
  WHERE user_id = NEW.id;  -- Match by user_id (UUID)

  RETURN NEW;
END;
$$;

-- Trigger to call the function after updating an email in auth.users
CREATE TRIGGER update_user_email
AFTER UPDATE OF email ON auth.users
FOR EACH ROW
WHEN (OLD.email IS DISTINCT FROM NEW.email)  -- Only trigger if the email changes
EXECUTE PROCEDURE public.sync_user_email();



CREATE OR REPLACE FUNCTION public.sync_user_display_name()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF (OLD.raw_user_meta_data::jsonb ->> 'display_name') IS DISTINCT FROM (NEW.raw_user_meta_data::jsonb ->> 'display_name') THEN
    UPDATE public.profiles
    SET display_name = NEW.raw_user_meta_data::jsonb ->> 'display_name'
    WHERE user_id = NEW.id;  -- Match by user_id (UUID)
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER update_user_display_name
AFTER UPDATE OF raw_user_meta_data ON auth.users
FOR EACH ROW
EXECUTE PROCEDURE public.sync_user_display_name();


CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  -- Insert a new profile in the profiles table
  INSERT INTO public.profiles (user_id, company_id, email, display_name)
  VALUES (
    NEW.id::UUID,  -- User ID from auth.users
    (NEW.raw_user_meta_data ->> 'company_id')::UUID,  -- Get company_id from user metadata
    NEW.email,  -- Directly use the email from auth.users
    NEW.raw_user_meta_data ->> 'display_name'  -- Get display_name from user metadata
  );

  RETURN NEW;
END;
$$;

DROP TRIGGER on_auth_user_created on auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE PROCEDURE public.handle_new_user();

