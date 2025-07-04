--- Total Bookings per User

SELECT
  u.id           AS user_id,
  u.name,
  u.email,
  COUNT(b.id)    AS total_bookings
FROM
  Users AS u
LEFT JOIN
  Bookings AS b
    ON u.id = b.user_id
GROUP BY
  u.id,
  u.name,
  u.email
ORDER BY
  total_bookings DESC;

--- Ranking Properties by Booking Volume

WITH booking_counts AS (
  SELECT
    p.id              AS property_id,
    p.title,
    COUNT(b.id)       AS bookings_count
  FROM
    Properties AS p
  LEFT JOIN
    Bookings AS b
      ON p.id = b.property_id
  GROUP BY
    p.id,
    p.title
)
SELECT
  property_id,
  title,
  bookings_count,
  ROW_NUMBER() OVER (
  PARTITION BY p.location
  ORDER BY bookings_count DESC
  )                AS rank_by_bookings
FROM
  booking_counts;
