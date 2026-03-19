-- Yemen Mandi - Scalable Database Schema (PostgreSQL)
-- Focus: integrity, localization support, and fast operational queries.

BEGIN;

CREATE EXTENSION IF NOT EXISTS citext;

-- =========================
-- Domain types (safer than free-text statuses)
-- =========================
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'order_status') THEN
    CREATE TYPE order_status AS ENUM (
      'pending', 'confirmed', 'preparing', 'out_for_delivery', 'delivered', 'cancelled'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'payment_method_type') THEN
    CREATE TYPE payment_method_type AS ENUM (
      'cash', 'card', 'wallet', 'apple_pay', 'google_pay'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'payment_status') THEN
    CREATE TYPE payment_status AS ENUM (
      'pending', 'authorized', 'paid', 'failed', 'refunded'
    );
  END IF;
END
$$;

-- =========================
-- Generic trigger for updated_at
-- =========================
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =========================
-- Users
-- =========================
CREATE TABLE IF NOT EXISTS users (
  id              BIGSERIAL PRIMARY KEY,
  name            VARCHAR(120) NOT NULL,
  phone           VARCHAR(20) NOT NULL UNIQUE,
  email           CITEXT NOT NULL UNIQUE,
  password_hash   TEXT NOT NULL,
  language        VARCHAR(8) NOT NULL DEFAULT 'en',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT users_language_chk CHECK (language IN ('en', 'ar'))
);

CREATE INDEX IF NOT EXISTS idx_users_created_at ON users (created_at DESC);

-- =========================
-- Addresses
-- =========================
CREATE TABLE IF NOT EXISTS addresses (
  id              BIGSERIAL PRIMARY KEY,
  user_id         BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  lat             NUMERIC(9, 6) NOT NULL,
  lng             NUMERIC(9, 6) NOT NULL,
  description     VARCHAR(255) NOT NULL,
  is_default      BOOLEAN NOT NULL DEFAULT FALSE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT addresses_lat_chk CHECK (lat BETWEEN -90 AND 90),
  CONSTRAINT addresses_lng_chk CHECK (lng BETWEEN -180 AND 180),
  CONSTRAINT addresses_user_id_id_uk UNIQUE (user_id, id)
);

CREATE INDEX IF NOT EXISTS idx_addresses_user_id ON addresses (user_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_addresses_one_default_per_user
  ON addresses (user_id)
  WHERE is_default;

-- =========================
-- Categories
-- =========================
CREATE TABLE IF NOT EXISTS categories (
  id              BIGSERIAL PRIMARY KEY,
  name_ar         VARCHAR(120) NOT NULL,
  name_en         VARCHAR(120) NOT NULL,
  image           TEXT,
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  sort_order      INTEGER NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT categories_name_ar_uk UNIQUE (name_ar),
  CONSTRAINT categories_name_en_uk UNIQUE (name_en)
);

CREATE INDEX IF NOT EXISTS idx_categories_active_sort ON categories (is_active, sort_order, id);

-- =========================
-- Products
-- =========================
CREATE TABLE IF NOT EXISTS products (
  id              BIGSERIAL PRIMARY KEY,
  name_ar         VARCHAR(160) NOT NULL,
  name_en         VARCHAR(160) NOT NULL,
  description     TEXT,
  price           NUMERIC(10, 2) NOT NULL,
  image           TEXT,
  category_id     BIGINT NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
  is_available    BOOLEAN NOT NULL DEFAULT TRUE,
  stock           INTEGER NOT NULL DEFAULT 0,
  reserved_stock  INTEGER NOT NULL DEFAULT 0,
  stock_version   BIGINT NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT products_price_chk CHECK (price >= 0),
  CONSTRAINT products_stock_chk CHECK (stock >= 0),
  CONSTRAINT products_reserved_stock_chk CHECK (reserved_stock >= 0),
  CONSTRAINT products_stock_allocation_chk CHECK (reserved_stock <= stock)
);

CREATE INDEX IF NOT EXISTS idx_products_category ON products (category_id);
CREATE INDEX IF NOT EXISTS idx_products_available_category ON products (is_available, category_id, id);
CREATE INDEX IF NOT EXISTS idx_products_created_at ON products (created_at DESC);

-- =========================
-- Product Options
-- =========================
CREATE TABLE IF NOT EXISTS product_options (
  id              BIGSERIAL PRIMARY KEY,
  product_id      BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  name            VARCHAR(120) NOT NULL,
  price           NUMERIC(10, 2) NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT product_options_price_chk CHECK (price >= 0),
  CONSTRAINT product_options_name_per_product_uk UNIQUE (product_id, name)
);

CREATE INDEX IF NOT EXISTS idx_product_options_product ON product_options (product_id);

-- =========================
-- Inventory Locks (optional cart reservation)
-- =========================
CREATE TABLE IF NOT EXISTS inventory_locks (
  id              BIGSERIAL PRIMARY KEY,
  product_id      BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  user_id         BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  quantity        INTEGER NOT NULL,
  expires_at      TIMESTAMPTZ NOT NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT inventory_locks_quantity_chk CHECK (quantity > 0)
);

CREATE INDEX IF NOT EXISTS idx_inventory_locks_product_expires ON inventory_locks (product_id, expires_at);
CREATE INDEX IF NOT EXISTS idx_inventory_locks_user_expires ON inventory_locks (user_id, expires_at);

-- =========================
-- Orders
-- =========================
CREATE TABLE IF NOT EXISTS orders (
  id              BIGSERIAL PRIMARY KEY,
  user_id         BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  total_price     NUMERIC(12, 2) NOT NULL,
  status          order_status NOT NULL DEFAULT 'pending',
  address_id      BIGINT NOT NULL,
  payment_method  payment_method_type NOT NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT orders_total_price_chk CHECK (total_price >= 0),
  CONSTRAINT orders_user_address_fk FOREIGN KEY (user_id, address_id)
    REFERENCES addresses(user_id, id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_orders_user_created ON orders (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_status_created ON orders (status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_address_id ON orders (address_id);

-- =========================
-- Order Items
-- =========================
CREATE TABLE IF NOT EXISTS order_items (
  id              BIGSERIAL PRIMARY KEY,
  order_id        BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id      BIGINT NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
  quantity        INTEGER NOT NULL,
  price           NUMERIC(10, 2) NOT NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT order_items_quantity_chk CHECK (quantity > 0),
  CONSTRAINT order_items_price_chk CHECK (price >= 0)
);

CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items (order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product ON order_items (product_id);

-- =========================
-- Payments
-- =========================
CREATE TABLE IF NOT EXISTS payments (
  id              BIGSERIAL PRIMARY KEY,
  order_id        BIGINT NOT NULL UNIQUE REFERENCES orders(id) ON DELETE CASCADE,
  method          payment_method_type NOT NULL,
  status          payment_status NOT NULL DEFAULT 'pending',
  amount          NUMERIC(12, 2) NOT NULL,
  transaction_ref VARCHAR(128),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT payments_amount_chk CHECK (amount >= 0)
);

CREATE INDEX IF NOT EXISTS idx_payments_status_created ON payments (status, created_at DESC);
CREATE UNIQUE INDEX IF NOT EXISTS idx_payments_transaction_ref
  ON payments (transaction_ref)
  WHERE transaction_ref IS NOT NULL;

-- =========================
-- Admins
-- =========================
CREATE TABLE IF NOT EXISTS admins (
  id              BIGSERIAL PRIMARY KEY,
  email           CITEXT NOT NULL UNIQUE,
  password        TEXT NOT NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =========================
-- Settings (singleton row)
-- =========================
CREATE TABLE IF NOT EXISTS settings (
  id              SMALLINT PRIMARY KEY DEFAULT 1,
  delivery_fee    NUMERIC(10, 2) NOT NULL DEFAULT 0,
  tax             NUMERIC(5, 2) NOT NULL DEFAULT 0,
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT settings_singleton_chk CHECK (id = 1),
  CONSTRAINT settings_delivery_fee_chk CHECK (delivery_fee >= 0),
  CONSTRAINT settings_tax_chk CHECK (tax >= 0 AND tax <= 100)
);

INSERT INTO settings (id, delivery_fee, tax)
VALUES (1, 0, 0)
ON CONFLICT (id) DO NOTHING;

-- =========================
-- updated_at triggers
-- =========================
DROP TRIGGER IF EXISTS trg_users_set_updated_at ON users;
CREATE TRIGGER trg_users_set_updated_at
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_addresses_set_updated_at ON addresses;
CREATE TRIGGER trg_addresses_set_updated_at
BEFORE UPDATE ON addresses
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_categories_set_updated_at ON categories;
CREATE TRIGGER trg_categories_set_updated_at
BEFORE UPDATE ON categories
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_products_set_updated_at ON products;
CREATE TRIGGER trg_products_set_updated_at
BEFORE UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_product_options_set_updated_at ON product_options;
CREATE TRIGGER trg_product_options_set_updated_at
BEFORE UPDATE ON product_options
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_orders_set_updated_at ON orders;
CREATE TRIGGER trg_orders_set_updated_at
BEFORE UPDATE ON orders
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_payments_set_updated_at ON payments;
CREATE TRIGGER trg_payments_set_updated_at
BEFORE UPDATE ON payments
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_admins_set_updated_at ON admins;
CREATE TRIGGER trg_admins_set_updated_at
BEFORE UPDATE ON admins
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_settings_set_updated_at ON settings;
CREATE TRIGGER trg_settings_set_updated_at
BEFORE UPDATE ON settings
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

COMMIT;
