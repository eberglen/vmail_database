DROP FUNCTION IF EXISTS get_contacts();
CREATE OR REPLACE FUNCTION get_contacts()
RETURNS TABLE (
    id INT,
    label TEXT,
    value TEXT
)
LANGUAGE sql
SECURITY DEFINER
AS $$
    SELECT
        c.id,
        c.display_name as label,
        CASE
            WHEN (SELECT authorize('contacts.column.email')) THEN c.email
            ELSE encrypt_message(c.email, 'your_secret_key')
        END AS value
    FROM
        contacts c
    WHERE
        -- If the user is an admin, show all contacts in the same company
        (
            (SELECT authorize('contacts.select.company'))
            AND (auth.jwt() ->> 'company_id')::UUID = c.company_id
        )
    GROUP BY c.id, c.display_name, c.email; -- Include all selected columns in GROUP BY
$$;
