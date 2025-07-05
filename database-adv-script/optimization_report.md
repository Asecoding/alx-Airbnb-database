# Performance Analysis with EXPLAIN
`EXPLAIN ANALYZE`

`SELECT ...`

Look out for these clues in the output:

- Sequential Scans (Seq Scan): Slower than index scans.

- Nested Loop Joins: Can be slow if joining large tables without indexes.

- High Row Estimates: Indicates inefficient filtering or missing conditions.

- No Index Usage: Means your DB is scanning entire tables.

# Refactor Suggestions
1. Ensure Indexes on Key Columns
Use this if not done already:

`CREATE INDEX idx_booking_user ON Booking(user_id);`

`CREATE INDEX idx_booking_property ON Booking(property_id);`

`CREATE INDEX idx_payment_booking ON Payment(booking_id);`

`CREATE INDEX idx_booking_date ON Booking(booking_date);`

## 2. Trim Unneeded Columns
Select only what’s necessary. You might not need all user or property details every time.

3. Filter Early (If Applicable)
If you usually only want confirmed or recent bookings:

`WHERE b.status = 'confirmed' AND b.booking_date >= CURRENT_DATE - INTERVAL '30 days'`

That narrows result sets early.
