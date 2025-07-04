# Normalization to Third Normal Form (3NF)
Below is a step-by-step walkthrough of how the property-booking database was taken from its initial design through 1NF, 2NF and finally into 3NF. Each stage identifies anomalies, shows how they were resolved, and presents the revised schema.

# Original Schema and Anomalies
## Users

user_id (PK), name, email, phone, street, city, state, postal_code, country

## Properties

property_id (PK), owner_name, owner_email, title, description, price_per_night, street, city, state, postal_code, country

## Bookings

booking_id (PK), user_id (FK), property_id (FK), start_date, end_date, total_price, payment_method

## Payments

payment_id (PK), booking_id (FK), payment_date, amount, method

## Identified anomalies:

- user contact and address fields repeat per booking or property

- owner name/email stored in Properties duplicates Users

- total_price in Bookings is a derived value (price_per_night × nights)

- street/city/state etc. repeated across Users and Properties

- payment_method exists in both Bookings and Payments

## Step 1: First Normal Form (1NF)
Requirements:

- All columns hold atomic (indivisible) values

- No repeating groups or arrays

Actions taken:

- Confirmed that each column holds a single value (no multi-valued fields)

- Introduced Addresses table to remove repeating street/city/state/postal_code/country

## Step 2: Second Normal Form (2NF)
Requirements:

- Table must be in 1NF

- No partial dependencies: all non-key attributes fully depend on the entire primary key

- Since we use surrogate keys (single-column PKs), partial dependencies on composite keys do not occur. However, we still identified:

owner_name and owner_email in Properties depend on Users, not on property_id

payment_method in Bookings depends on Payment, not on Booking

Actions taken:

- Removed owner fields from Properties and pointed owner_id → Users

- Removed payment_method from Bookings; retained it only in Payments

## Step 3: Third Normal Form (3NF)
Requirements:

- Must be in 2NF

- No transitive dependencies: non-key attributes must not depend on other non-key attributes

Transitive dependencies identified:

- total_price depends on start_date, end_date and price_per_night (in Properties)

- Users.address details depend on address_id, not on Users table

Actions taken:

- Dropped total_price from Bookings (compute on demand)

- Ensured Users.address_id → Addresses, and Properties.address_id → Addresses

# Key points:

- Each non-key attribute fully depends on its table’s PK

- No derived or redundant data stored

- Address details centralized in one table

- Owner information reuses Users

- Payments table holds payment-specific fields
