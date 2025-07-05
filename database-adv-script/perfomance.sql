-- performance.sql

SELECT 
    b.booking_id,
    b.booking_date,
    b.status,
    u.user_id,
    u.name AS user_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    p.location,
    py.payment_id,
    py.amount,
    py.payment_date
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
JOIN Payment py ON b.booking_id = py.booking_id
ORDER BY b.booking_date DESC;
