CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(200) NOT NULL,
    category VARCHAR2(100) NOT NULL,
    purchase_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    stock_qty NUMBER(5),
    discount_rate NUMBER(3),
    unit_price NUMBER(10,2) NOT NULL,
    status VARCHAR2(20),
    created_date TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE staff (
    staff_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    role VARCHAR2(50) NOT NULL,
    department VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    is_active CHAR(1) DEFAULT 'Y'
);

CREATE TABLE alerts (
    alert_id NUMBER PRIMARY KEY,
    product_id NUMBER,
    alert_type VARCHAR2(20) NOT NULL,
    alert_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    status VARCHAR2(28),
    assigned_to NUMBER
);

CREATE TABLE action_log (
    log_id NUMBER PRIMARY KEY,
    product_id NUMBER NOT NULL,
    staff_id NUMBER NOT NULL,
    action_taken VARCHAR2(50) NOT NULL,
    action_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    notes VARCHAR2(500)
);

CREATE TABLE sales (
    sale_id NUMBER PRIMARY KEY,
    product_id NUMBER NOT NULL,
    quantity NUMBER(6) NOT NULL,
    sale_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    discount_applied NUMBER(3),
    unit_price NUMBER(10,2) NOT NULL,
    final_price NUMBER(10,2) NOT NULL,
    staff_id NUMBER,
    payment_method VARCHAR2(20) DEFAULT 'CASH'
);

-- Foreign keys added AFTER data insertion (as shown in output)
ALTER TABLE alerts ADD CONSTRAINT fk_alerts_product FOREIGN KEY (product_id) REFERENCES products(product_id);
ALTER TABLE alerts ADD CONSTRAINT fk_alerts_staff FOREIGN KEY (assigned_to) REFERENCES staff(staff_id);
ALTER TABLE action_log ADD CONSTRAINT fk_log_product FOREIGN KEY (product_id) REFERENCES products(product_id);
ALTER TABLE action_log ADD CONSTRAINT fk_log_staff FOREIGN KEY (staff_id) REFERENCES staff(staff_id);
ALTER TABLE sales ADD CONSTRAINT fk_sales_product FOREIGN KEY (product_id) REFERENCES products(product_id);
ALTER TABLE sales ADD CONSTRAINT fk_sales_staff FOREIGN KEY (staff_id) REFERENCES staff(staff_id);

-- Indexes created (as shown in output)
CREATE INDEX idx_products_expiry ON products(expiry_date);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_staff_dept ON staff(department);
CREATE INDEX idx_alerts_status ON alerts(status);
CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_log_date ON action_log(action_date);

-- ACTUAL staff insertion that worked
INSERT INTO staff (staff_id, name, role, department, email, is_active)
SELECT 
    100 + ROWNUM,
    'Employee ' || ROWNUM,
    CASE MOD(ROWNUM, 5)
        WHEN 0 THEN 'Manager'
        WHEN 1 THEN 'Supervisor'
        WHEN 2 THEN 'Clerk'
        WHEN 3 THEN 'Admin'
        ELSE 'Assistant'
    END,
    CASE MOD(ROWNUM, 4)
        WHEN 0 THEN 'Management'
        WHEN 1 THEN 'Inventory'
        WHEN 2 THEN 'Sales'
        ELSE 'Customer Service'
    END,
    'emp' || ROWNUM || '@store.com',
    CASE WHEN MOD(ROWNUM, 15) = 0 THEN 'N' ELSE 'Y' END
FROM dual CONNECT BY LEVEL <= 150;

-- ACTUAL products insertion that worked
INSERT INTO products (product_id, product_name, category, purchase_date, expiry_date, stock_qty, unit_price, status)
SELECT 
    1000 + ROWNUM,
    'Product ' || ROWNUM,
    CASE MOD(ROWNUM, 8)
        WHEN 0 THEN 'Dairy'
        WHEN 1 THEN 'Bakery'
        WHEN 2 THEN 'Meat'
        WHEN 3 THEN 'Produce'
        WHEN 4 THEN 'Beverages'
        WHEN 5 THEN 'Snacks'
        WHEN 6 THEN 'Frozen'
        ELSE 'Canned'
    END,
    SYSDATE - TRUNC(DBMS_RANDOM.VALUE(1, 30)),
    SYSDATE + TRUNC(DBMS_RANDOM.VALUE(1, 60)),
    TRUNC(DBMS_RANDOM.VALUE(10, 500)),
    ROUND(DBMS_RANDOM.VALUE(1, 50), 2),
    CASE 
        WHEN DBMS_RANDOM.VALUE(1, 100) > 95 THEN 'EXPIRED'
        WHEN DBMS_RANDOM.VALUE(1, 100) > 85 THEN 'CRITICAL'
        WHEN DBMS_RANDOM.VALUE(1, 100) > 70 THEN 'NEAR_EXPIRY'
        ELSE 'ACTIVE'
    END
FROM dual CONNECT BY LEVEL <= 100;

-- No discount update shown in output, but we can include it
UPDATE products 
SET discount_rate = CASE 
    WHEN expiry_date - SYSDATE <= 1 THEN 50
    WHEN expiry_date - SYSDATE <= 2 THEN 40
    WHEN expiry_date - SYSDATE <= 3 THEN 30
    WHEN expiry_date - SYSDATE <= 7 THEN 20
    WHEN expiry_date - SYSDATE <= 14 THEN 10
    ELSE 0
END;

-- ACTUAL alerts insertion (fixed version that worked)
INSERT INTO alerts (alert_id, product_id, alert_type, alert_date, status, assigned_to)
SELECT 
    ROWNUM,
    (SELECT product_id FROM (
        SELECT product_id FROM products ORDER BY DBMS_RANDOM.VALUE
    ) WHERE ROWNUM = 1),
    CASE WHEN DBMS_RANDOM.VALUE(1, 100) > 70 THEN 'CRITICAL' ELSE 'MODERATE' END,
    SYSTIMESTAMP - TRUNC(DBMS_RANDOM.VALUE(1, 10)),
    CASE WHEN DBMS_RANDOM.VALUE(1, 100) > 80 THEN 'RESOLVED' ELSE 'PENDING' END,
    (SELECT staff_id FROM (
        SELECT staff_id FROM staff ORDER BY DBMS_RANDOM.VALUE
    ) WHERE ROWNUM = 1)
FROM dual CONNECT BY LEVEL <= 200;

-- ACTUAL action_log insertion
INSERT INTO action_log (log_id, product_id, staff_id, action_taken, action_date, notes)
SELECT 
    ROWNUM,
    (SELECT product_id FROM (
        SELECT product_id FROM products ORDER BY DBMS_RANDOM.VALUE
    ) WHERE ROWNUM = 1),
    (SELECT staff_id FROM (
        SELECT staff_id FROM staff ORDER BY DBMS_RANDOM.VALUE
    ) WHERE ROWNUM = 1),
    CASE MOD(ROWNUM, 4)
        WHEN 0 THEN 'DISCOUNT_APPLIED'
        WHEN 1 THEN 'ALERT_GENERATED'
        WHEN 2 THEN 'ALERT_RESOLVED'
        ELSE 'STOCK_UPDATED'
    END,
    SYSTIMESTAMP - TRUNC(DBMS_RANDOM.VALUE(1, 30)),
    'Action ' || ROWNUM || ' completed'
FROM dual CONNECT BY LEVEL <= 300;

-- ACTUAL sales insertion
INSERT INTO sales (sale_id, product_id, quantity, sale_date, discount_applied, unit_price, final_price, staff_id, payment_method)
SELECT 
    1000 + ROWNUM,
    p.product_id,
    TRUNC(DBMS_RANDOM.VALUE(1, 10)),
    SYSTIMESTAMP - TRUNC(DBMS_RANDOM.VALUE(1, 90)),
    TRUNC(DBMS_RANDOM.VALUE(0, 30)),
    p.unit_price,
    ROUND(TRUNC(DBMS_RANDOM.VALUE(1, 10)) * p.unit_price * (1 - TRUNC(DBMS_RANDOM.VALUE(0, 30))/100), 2),
    (SELECT staff_id FROM (
        SELECT staff_id FROM staff ORDER BY DBMS_RANDOM.VALUE
    ) WHERE ROWNUM = 1),
    CASE TRUNC(DBMS_RANDOM.VALUE(1, 4))
        WHEN 1 THEN 'CASH'
        WHEN 2 THEN 'CARD'
        ELSE 'MOBILE'
    END
FROM products p
CROSS JOIN (SELECT LEVEL FROM dual CONNECT BY LEVEL <= 5)
WHERE ROWNUM <= 500;