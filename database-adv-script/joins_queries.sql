--- INNER JOIN: Bookings with Their Users


SELECT
  b.id            AS booking_id,
  b.property_id,
  b.start_date,
  b.end_date,
  u.id            AS user_id,
  u.name,
  u.email
FROM
  Bookings AS b
INNER JOIN
  Users AS u
    ON b.user_id = u.id;

--- LEFT JOIN: All Properties and Their Reviews

SELECT
  p.id            AS property_id,
  p.title,
  p.location,
  r.id            AS review_id,
  r.rating,
  r.comment
FROM
  Properties AS p
LEFT JOIN
  Reviews AS r
    ON p.id = r.property_id;

--- FULL OUTER JOIN: All Users and All Bookings

SELECT
  u.id            AS user_id,
  u.name,
  u.email,
  b.id            AS booking_id,
  b.property_id,
  b.start_date,
  b.end_date
FROM
  Users AS u
FULL OUTER JOIN
  Bookings AS b
    ON u.id = b.user_id;


