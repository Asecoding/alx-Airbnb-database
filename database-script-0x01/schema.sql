-- Drop in reverse‐dependency order
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS PropertyImages;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Properties;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Addresses;

-- 1. Addresses
CREATE TABLE Addresses (
  address_id    INT AUTO_INCREMENT PRIMARY KEY,
  street        VARCHAR(255)    NOT NULL,
  city          VARCHAR(100)    NOT NULL,
  state         VARCHAR(100),
  postal_code   VARCHAR(20),
  country       VARCHAR(100)    NOT NULL,
  INDEX idx_addresses_city (city),
  INDEX idx_addresses_country (country)
) ENGINE=InnoDB;

-- 2. Users
CREATE TABLE Users (
  user_id     INT AUTO_INCREMENT PRIMARY KEY,
  first_name  VARCHAR(50)   NOT NULL,
  last_name   VARCHAR(50)   NOT NULL,
  email       VARCHAR(100)  NOT NULL,
  phone       VARCHAR(20),
  address_id  INT           NOT NULL,
  UNIQUE KEY uq_users_email (email),
  FOREIGN KEY (address_id)
    REFERENCES Addresses(address_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  INDEX idx_users_address (address_id)
) ENGINE=InnoDB;

-- 3. Properties
CREATE TABLE Properties (
  property_id     INT AUTO_INCREMENT PRIMARY KEY,
  owner_id        INT           NOT NULL,
  title           VARCHAR(255)  NOT NULL,
  description     TEXT,
  price_per_night DECIMAL(10,2) NOT NULL,
  address_id      INT           NOT NULL,
  FOREIGN KEY (owner_id)
    REFERENCES Users(user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (address_id)
    REFERENCES Addresses(address_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  INDEX idx_props_owner (owner_id),
  INDEX idx_props_address (address_id),
  INDEX idx_props_price (price_per_night)
) ENGINE=InnoDB;

-- 4. Bookings
CREATE TABLE Bookings (
  booking_id   INT AUTO_INCREMENT PRIMARY KEY,
  user_id      INT           NOT NULL,
  property_id  INT           NOT NULL,
  start_date   DATE          NOT NULL,
  end_date     DATE          NOT NULL,
  status       VARCHAR(50)   NOT NULL   COMMENT 'e.g. pending, confirmed, cancelled',
  FOREIGN KEY (user_id)
    REFERENCES Users(user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (property_id)
    REFERENCES Properties(property_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  INDEX idx_book_user (user_id),
  INDEX idx_book_prop (property_id),
  CONSTRAINT chk_dates CHECK (end_date > start_date)
) ENGINE=InnoDB;

-- 5. Payments
CREATE TABLE Payments (
  payment_id     INT AUTO_INCREMENT PRIMARY KEY,
  booking_id     INT           NOT NULL,
  payment_date   DATETIME      NOT NULL  DEFAULT CURRENT_TIMESTAMP,
  amount         DECIMAL(10,2) NOT NULL,
  payment_method VARCHAR(50)   NOT NULL,
  FOREIGN KEY (booking_id)
    REFERENCES Bookings(booking_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  INDEX idx_pay_booking (booking_id),
  INDEX idx_pay_date    (payment_date)
) ENGINE=InnoDB;

-- 6. PropertyImages
CREATE TABLE PropertyImages (
  image_id     INT AUTO_INCREMENT PRIMARY KEY,
  property_id  INT           NOT NULL,
  image_url    VARCHAR(2083) NOT NULL,
  alt_text     VARCHAR(255),
  FOREIGN KEY (property_id)
    REFERENCES Properties(property_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  INDEX idx_img_property (property_id)
) ENGINE=InnoDB;

-- 7. Reviews
CREATE TABLE Reviews (
  review_id   INT AUTO_INCREMENT PRIMARY KEY,
  booking_id  INT           NOT NULL,
  rating      TINYINT       NOT NULL  CHECK (rating BETWEEN 1 AND 5),
  comment     TEXT,
  created_on  DATETIME      NOT NULL  DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id)
    REFERENCES Bookings(booking_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  UNIQUE KEY uq_review_booking (booking_id),
  INDEX idx_rev_booking (booking_id),
  INDEX idx_rev_date    (created_on)
) ENGINE=InnoDB;
