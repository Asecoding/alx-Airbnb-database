# Monitor and Refine Database Performance

## Step 1: Monitor Query Performance

### For PostgreSQL or SQL Server

Use EXPLAIN ANALYZE:

EXPLAIN ANALYZE

`SELECT *`

`FROM Booking`

`JOIN Property ON Booking.property_id = Property.property_id`

`WHERE Booking.status = 'confirmed'`

`ORDER BY Booking.booking_date DESC;`

Look for:

`Seq Scan` → full table scan (slow)

`Nested Loop` → costly if joining large tables

`Rows Removed by Filter` → high count = inefficient filtering

`Execution Time` → key metric for comparison

## Step 2: Identify Bottlenecks

Common issues:

- No indexes on `JOIN` or `WHERE` columns

- Full table scans (Seq Scan)

- Sorting without indexes (ORDER BY)

- Filtering large datasets before narrowing scope

## Step 3: Suggest & Implement Changes

✅ Add Indexes

`CREATE INDEX idx_booking_status ON Booking(status);`

`CREATE INDEX idx_booking_date ON Booking(booking_date);`

`CREATE INDEX idx_booking_property ON Booking(property_id);`

`CREATE INDEX idx_property_location ON Property(location);`

### Schema Adjustments

Normalize redundant columns

Add composite indexes for frequent multi-column filters:

`CREATE INDEX idx_booking_status_date ON Booking(status, booking_date);`

### Partition large tables by date if performance remains slow:

`CREATE TABLE Booking_2025 PARTITION OF Booking`

`FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');`

## Step 4: Report Improvements

Here’s a sample performance comparison table:


| Metric    |	Before Optimization|After Optimization|
|---------- |--------------------|------------------|
| Execution Time|	1200 ms	|280 ms|
| Rows Scanned	| 100,000	| 8,000|
| Index Usage   |	❌	---|✅|
| Query Plan	| Seq Scan |	Index Scan|
