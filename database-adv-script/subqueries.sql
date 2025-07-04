--- Properties with Average Rating > 4.0

SELECT
  p.id           AS property_id,
  p.title,
  p.location
FROM
  Properties AS p
WHERE
  (
    SELECT
      AVG(r.rating)
    FROM
      Reviews AS r
    WHERE
      r.property_id = p.id
  ) > 4.0;

--- Users with More Than 3 Bookings (Correlated Subquery)

SELECT
  u.id          AS user_id,
  u.name,
  u.email
FROM
  Users AS u
WHERE
  (
    SELECT
      COUNT(*)
    FROM
      Bookings AS b
    WHERE
      b.user_id = u.id
  ) > 3;
