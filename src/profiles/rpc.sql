CREATE OR REPLACE FUNCTION get_user_info()
RETURNS TABLE (
    id INTEGER,
    auth_id UUID,
    display_name TEXT,
    token_name TEXT,
    token_email TEXT,
    token_id UUID,
    auth_email TEXT,
    company_id UUID
)
LANGUAGE sql
AS $$
    SELECT
        p.id AS id,
        p.user_id AS auth_id,
        p.display_name,
        t.name AS token_name,
        t.email AS token_email,
        t.id AS token_id,
        p.email AS auth_email,
        p.company_id
    FROM
        profiles p
    LEFT JOIN
        user_tokens ut ON p.id = ut.user_id
    LEFT JOIN
        tokens t ON ut.token_id = t.id
    WHERE
        -- If the user is an admin, show all users in the same company
        (
            (auth.jwt() ->> 'user_role')::TEXT = 'admin'
            AND p.company_id = (auth.jwt() ->> 'company_id')::UUID
        )
        OR
        -- If the user is not an admin, show only their own user data
        (
            (auth.jwt() ->> 'user_role')::TEXT != 'admin'
            AND p.user_id = auth.uid()
        )
    ORDER BY
        p.display_name DESC;
$$;
