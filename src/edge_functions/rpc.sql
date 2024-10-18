CREATE OR REPLACE FUNCTION get_token(p_token_id uuid, p_company_id uuid, p_profile_id integer, p_role TEXT)
RETURNS TABLE (
    access_token TEXT,
    refresh_token TEXT,
    email TEXT
)
LANGUAGE sql
AS $$
    SELECT t.access_token, t.refresh_token, t.email
    FROM tokens t
    LEFT JOIN user_tokens ut
    ON t.id = ut.token_id
    WHERE t.id = p_token_id
    AND t.company_id = p_company_id
    AND
       (
           p_role = 'admin' OR
           ut.profile_id = p_profile_id
       )

    GROUP BY t.id
    LIMIT 1
$$;
