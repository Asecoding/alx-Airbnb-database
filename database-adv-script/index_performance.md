# Implement Indexes for Optimization
## Step 1: Identify High-Usage Columns
These columns are frequently referenced in WHERE, JOIN, and ORDER BY clauses. Common candidates:

| Table    | Columns Used Frequently                            | Reason                    |
| -------- | -------------------------------------------------- | ------------------------- |
|  `User`   | `user_id`, `email`                               | `JOINs, searches`         |
| Booking  | `user_id`, `property_id`, `status`, `booking_date` | JOINs, filters, date sort |
| `Property`| `roperty_id`, `location`, `price`                 | `JOINs, search filters`   |

## Step 2: Create Indexes in SQL
Here’s how we write the index creation statements:

-- Indexes on User table

`CREATE INDEX idx_user_user_id ON User(user_id);`

`CREATE INDEX idx_user_email ON User(email);`


-- Indexes on Booking table

`CREATE INDEX idx_booking_user_id ON Booking(user_id);`

`CREATE INDEX idx_booking_property_id ON Booking(property_id);`

`CREATE INDEX idx_booking_status ON Booking(status);`

`CREATE INDEX idx_booking_booking_date ON Booking(booking_date);`

-- Indexes on Property table

`CREATE INDEX idx_property_property_id ON Property(property_id);`

`CREATE INDEX idx_property_location ON Property(location);`

`CREATE INDEX idx_property_price ON Property(price);`

## Step 3: Measure Performance (Before & After)
Use EXPLAIN or ANALYZE like this:

-- Query to check performance before and after indexing

`SELECT *`

`FROM Booking`

`JOIN Property ON Booking.property_id = Property.property_id`

`WHERE Booking.status = 'confirmed'`

`ORDER BY Booking.booking_date DESC;`

## Compare EXPLAIN ANALYZE results:

- Look for changes in execution time.

- Note whether Index Scan or Bitmap Index Scan replaces Seq Scan.

- Lower cost estimates and faster total time = success.

