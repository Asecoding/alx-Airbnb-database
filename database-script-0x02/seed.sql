-- ================================================
-- SQL Script: Property Booking System Schema
-- Description: Creates tables, constraints, and indexes
-- ================================================

-- Drop tables in reverse dependency order to avoid FK conflicts
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS PropertyImages;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Properties;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Addresses;

-- ================================================
-- 1. Addresses: centralize all address fields
-- ================================================
CREATE TABLE Addresses (
  address_id    INT AUTO_INCREMENT PRIMARY KEY,   -- surrogate key
  street        VARCHAR(255)    NOT NULL,         -- street address
  city          VARCHAR(100)    NOT NULL,         -- city name
  state         VARCHAR(100),                     -- state or province
  postal_code   VARCHAR(20),                      -- ZIP or postal code
  country       VARCHAR(100)    NOT NULL,         -- country name

  -- indexes to speed up lookups by city and country
  INDEX idx_addresses_city    (city),
  INDEX idx_addresses_country (country)
) ENGINE=InnoDB;


-- ================================================
-- 2. Users: tenants and property owners
-- ================================================
CREATE TABLE Users (
  user_id     INT AUTO_INCREMENT PRIMARY KEY,     -- surrogate user key
  first_name  VARCHAR(50)   NOT NULL,             -- user’s first name
  last_name   VARCHAR(50)   NOT NULL,             -- user’s last name
  email       VARCHAR(100)  NOT NULL,             -- user’s email (unique)
  phone       VARCHAR(20),                        -- user’s phone number
  address_id  INT           NOT NULL,             -- FK to Addresses

  UNIQUE KEY uq_users_email (email),               -- enforce unique email
  FOREIGN KEY (address_id)
    REFERENCES Addresses(address_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,                           -- prevent deleting used addresses

  INDEX idx_users_address (address_id)             -- speed up address joins
) ENGINE=InnoDB;


-- ================================================
-- 3. Properties: listings posted by owners
-- ================================================
CREATE TABLE Properties (
  property_id     INT AUTO_INCREMENT PRIMARY KEY, -- surrogate property key
  owner_id        INT           NOT NULL,         -- FK to Users
  title           VARCHAR(255)  NOT NULL,         -- short listing title
  description     TEXT,                           -- detailed description
  price_per_night DECIMAL(10,2) NOT NULL,         -- nightly rate
  address_id      INT           NOT NULL,         -- FK to Addresses

  FOREIGN KEY (owner_id)
    REFERENCES Users(user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,                           -- remove properties if owner deleted

  FOREIGN KEY (address_id)
    REFERENCES Addresses(address_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,                          -- keep properties if address removed

  INDEX idx_props_owner   (owner_id),             -- speed up owner lookups
  INDEX idx_props_address (address_id),           -- speed up address joins
  INDEX idx_props_price   (price_per_night)       -- speed up price filtering
) ENGINE=InnoDB;


-- ================================================
-- 4. Bookings: reservations made by users
-- ================================================
CREATE TABLE Bookings (
  booking_id   INT AUTO_INCREMENT PRIMARY KEY,   -- surrogate booking key
  user_id      INT           NOT NULL,           -- FK to Users
  property_id  INT           NOT NULL,           -- FK to Properties
  start_date   DATE          NOT NULL,           -- check-in date
  end_date     DATE          NOT NULL,           -- check-out date
  status       VARCHAR(50)   NOT NULL,           -- e.g. pending, confirmed

  FOREIGN KEY (user_id)
    REFERENCES Users(user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,                          -- remove bookings if user deleted

  FOREIGN KEY (property_id)
    REFERENCES Properties(property_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,                          -- remove bookings if property deleted

  -- ensure end_date is after start_date
  CONSTRAINT chk_dates CHECK (end_date > start_date),

  INDEX idx_book_user  (user_id),                -- speed up user booking queries
  INDEX idx_book_prop  (property_id)             -- speed up property booking queries
) ENGINE=InnoDB;


-- ================================================
-- 5. Payments: transaction records for bookings
-- ================================================
CREATE TABLE Payments (
  payment_id     INT AUTO_INCREMENT PRIMARY KEY,  -- surrogate payment key
  booking_id     INT           NOT NULL,          -- FK to Bookings
  payment_date   DATETIME      NOT NULL
                  DEFAULT CURRENT_TIMESTAMP,      -- timestamp of payment
  amount         DECIMAL(10,2) NOT NULL,          -- amount paid
  payment_method VARCHAR(50)   NOT NULL,          -- e.g. credit_card, paypal

  FOREIGN KEY (booking_id)
    REFERENCES Bookings(booking_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,                           -- remove payments if booking deleted

  INDEX idx_pay_booking (booking_id),             -- speed up lookup by booking
  INDEX idx_pay_date    (payment_date)            -- speed up date‐range queries
) ENGINE=InnoDB;


-- ================================================
-- 6. PropertyImages: images for each property
-- ================================================
CREATE TABLE PropertyImages (
  image_id     INT AUTO_INCREMENT PRIMARY KEY,   -- surrogate image key
  property_id  INT           NOT NULL,           -- FK to Properties
  image_url    VARCHAR(2083) NOT NULL,           -- image link (max URL length)
  alt_text     VARCHAR(255),                     -- accessible description

  FOREIGN KEY (property_id)
    REFERENCES Properties(property_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,                          -- remove images if property deleted

  INDEX idx_img_property (property_id)            -- speed up image‐by‐property queries
) ENGINE=InnoDB;


-- ================================================
-- 7. Reviews: one review per booking
-- ================================================
CREATE TABLE Reviews (
  review_id   INT AUTO_INCREMENT PRIMARY KEY,    -- surrogate review key
  booking_id  INT           NOT NULL,            -- FK to Bookings
  rating      TINYINT       NOT NULL             -- rating 1 to 5
                CHECK (rating BETWEEN 1 AND 5),
  comment     TEXT,                              -- review text
  created_on  DATETIME      NOT NULL
                DEFAULT CURRENT_TIMESTAMP,       -- when review was left

  FOREIGN KEY (booking_id)
    REFERENCES Bookings(booking_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,                           -- remove reviews if booking deleted

  UNIQUE KEY uq_review_booking (booking_id),      -- one review per booking
  INDEX idx_rev_booking (booking_id),             -- speed up lookup by booking
  INDEX idx_rev_date    (created_on)              -- speed up date‐range queries
) ENGINE=InnoDB;
