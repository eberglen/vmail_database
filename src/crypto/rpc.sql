CREATE OR REPLACE FUNCTION encrypt_message(
    input_text TEXT,
    key TEXT
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    encrypted_text TEXT := '';
    i INT;
    key_len INT := length(key);
BEGIN
    FOR i IN 1..length(input_text) LOOP
        -- Shift each character by the corresponding character in the key
        encrypted_text := encrypted_text || 
            chr((ascii(substr(input_text, i, 1)) + ascii(substr(key, ((i - 1) % key_len) + 1, 1))) % 256);
    END LOOP;
    
    RETURN encrypted_text;
END;
$$;
