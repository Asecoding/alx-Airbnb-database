
-- Step 1: Create the parent table
CREATE TABLE Booking (
    booking_id SERIAL PRIMARY KEY,
    user_id INT,
    property_id INT,
    status VARCHAR(20),
    start_date DATE,
    end_date DATE,
    amount DECIMAL(10,2)
) PARTITION BY RANGE (start_date);

-- Step 2: Create child partitions (e.g., yearly)
CREATE TABLE Booking_2023 PARTITION OF Booking
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE Booking_2024 PARTITION OF Booking
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE Booking_2025 PARTITION OF Booking
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

EXPLAIN ANALYZE
SELECT *
FROM Booking
WHERE start_date BETWEEN '2024-06-01' AND '2024-06-30';
