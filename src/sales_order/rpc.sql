CREATE OR REPLACE FUNCTION insert_sales_order_and_threads(
    p_name TEXT,
    p_order_number TEXT,
    p_status TEXT,
    p_total_amount DECIMAL,
    p_order_date TIMESTAMP WITH TIME ZONE,
    p_notes TEXT,
    p_sales_threads JSONB, -- JSON array containing thread information
    p_assigned_to INTEGER -- Added assigned_to as an integer
)
RETURNS INTEGER AS $$
DECLARE
    v_sales_order_id INTEGER; -- Variable to store the newly inserted sales_order ID
    v_thread JSONB; -- Change to JSONB for direct handling
BEGIN
    -- Authorization check
    IF NOT authorize('sales_orders.insert.company') THEN
        RAISE EXCEPTION 'Unauthorized access';
    END IF;

    -- Insert into sales_orders table
    INSERT INTO sales_orders (company_id, name, order_number, status, total_amount, order_date, notes, assigned_to) -- Added assigned_to
    VALUES (
        (auth.jwt() ->> 'company_id')::UUID, -- Source company_id from JWT token
        p_name,
        p_order_number,
        p_status,
        p_total_amount,
        p_order_date,
        p_notes,
        p_assigned_to -- Include assigned_to in the insert
    )
    RETURNING id INTO v_sales_order_id;

    -- Loop through each thread in the JSONB array and insert into sales_threads table
    FOR v_thread IN SELECT * FROM jsonb_array_elements(p_sales_threads) LOOP
        INSERT INTO sales_threads (
            sales_order_id,
            thread_id,
            token_id,
            type,
            subject
        )
        VALUES (
            v_sales_order_id,
            (v_thread->>'thread_id')::TEXT,
            (v_thread->>'token_id')::UUID,    -- Cast to UUID
            (v_thread->>'type')::sales_thread_type, -- Ensure this matches the enum type
            v_thread->>'subject'::TEXT         -- Cast to TEXT
        );
    END LOOP;

    -- Return the sales_order_id
    RETURN v_sales_order_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;



CREATE OR REPLACE FUNCTION get_sales_orders(p_last_id INTEGER DEFAULT NULL)
RETURNS TABLE (
    id INTEGER,
    order_number TEXT,
    name TEXT,
    status TEXT,
    total_amount DECIMAL,
    order_date TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    assigned_to INTEGER -- Added assigned_to field
)
LANGUAGE sql
SECURITY DEFINER
AS $$

    SELECT
        so.id,
        so.order_number,
        so.name,
        so.status,
        so.total_amount,
        so.order_date,
        so.notes,
        so.assigned_to -- Include assigned_to in the SELECT statement
    FROM
        sales_orders so
    WHERE
        -- Check if the user has permission to view sales orders
        (SELECT authorize('sales_orders.select.company'))
        AND (auth.jwt() ->> 'company_id')::UUID = so.company_id
        -- Add condition to fetch records greater than the last fetched id for pagination
        AND (p_last_id IS NULL OR so.id < p_last_id)
    ORDER BY so.id DESC -- Fetch newer records based on serial id
    LIMIT 10; -- Fixed limit of 10 records

$$;

CREATE OR REPLACE FUNCTION update_sales_order(
    order_id INTEGER,
    updated_fields JSONB
) RETURNS VOID AS $$
DECLARE
    field_name TEXT;
    field_value TEXT;
    allowed_fields TEXT[] := ARRAY['name', 'order_number', 'status', 'total_amount', 'notes', 'assigned_to']; -- replace with actual field names
BEGIN
    -- Iterate over each key-value pair in the JSONB object
    FOR field_name, field_value IN SELECT * FROM jsonb_each_text(updated_fields) LOOP
        -- Check if the field is in the allowed fields list
        IF field_name = ANY(allowed_fields) THEN
            EXECUTE format('
                UPDATE sales_orders AS so
                SET %I = $1
                WHERE id = $2
                  AND (SELECT authorize(''sales_orders.update.company''))
                  AND (auth.jwt() ->> ''company_id'')::UUID = so.company_id', field_name)
            USING field_value, order_id;
        ELSE
            RAISE EXCEPTION 'Field % is not allowed for update', field_name;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
