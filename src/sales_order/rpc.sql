CREATE OR REPLACE FUNCTION insert_sales_order_and_threads(
    p_name TEXT,
    p_order_number TEXT,
    p_status TEXT,
    p_total_amount DECIMAL,
    p_order_date TIMESTAMP WITH TIME ZONE,
    p_notes TEXT,
    p_sales_threads JSONB -- JSON array containing thread information
)
RETURNS UUID AS $$
DECLARE
    v_sales_order_id UUID; -- Variable to store the newly inserted sales_order ID
    v_thread JSONB; -- Change to JSONB for direct handling
BEGIN
    -- Authorization check
    IF NOT authorize('sales_orders.insert.company') THEN
        RAISE EXCEPTION 'Unauthorized access';
    END IF;

    -- Insert into sales_orders table
    INSERT INTO sales_orders (company_id, name, order_number, status, total_amount, order_date, notes)
    VALUES (
        (auth.jwt() ->> 'company_id')::UUID, -- Source company_id from JWT token
        p_name,
        p_order_number,
        p_status,
        p_total_amount,
        p_order_date,
        p_notes
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
