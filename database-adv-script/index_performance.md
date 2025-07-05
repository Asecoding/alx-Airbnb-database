# Implement Indexes for Optimization
## Identify High-Usage Columns
These columns are frequently referenced in WHERE, JOIN, and ORDER BY clauses. Common candidates:

| Table    | Columns Used Frequently                            | Reason                    |
| -------- | -------------------------------------------------- | ------------------------- |
|  `User`   | `user_id`, `email`                               | `JOINs, searches`         |
| Booking  | `user_id`, `property_id`, `status`, `booking_date` | JOINs, filters, date sort |
| `Property`| `roperty_id`, `location`, `price`                 | `JOINs, search filters`   |


## Compare EXPLAIN ANALYZE results:

- Look for changes in execution time.

- Note whether Index Scan or Bitmap Index Scan replaces Seq Scan.

- Lower cost estimates and faster total time = success.

