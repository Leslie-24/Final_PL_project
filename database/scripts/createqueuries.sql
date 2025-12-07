CREATE PLUGGABLE DATABASE THUR_27413_Leslie_ExpiredGoodsDB
ADMIN USER admin IDENTIFIED BY password
FILE_NAME_CONVERT = ('/opt/oracle/oradata/XE/pdbseed/', 
                     '/opt/oracle/oradata/XE/THUR_27413_LESLIE_EXPIREDGOODSDB/');



-- Switch to PDB
ALTER SESSION SET CONTAINER = THUR_27413_Leslie_ExpiredGoodsDB;

-- Create user
CREATE USER expiry_admin IDENTIFIED BY Leslie;

-- Grant privileges
GRANT CREATE SESSION TO expiry_admin;
GRANT CREATE TABLE TO expiry_admin;
GRANT CREATE VIEW TO expiry_admin;
GRANT CREATE PROCEDURE TO expiry_admin;
GRANT CREATE TRIGGER TO expiry_admin;
GRANT CREATE SEQUENCE TO expiry_admin;
GRANT CREATE SYNONYM TO expiry_admin;
GRANT CREATE TYPE TO expiry_admin;
GRANT CREATE MATERIALIZED VIEW TO expiry_admin;

-- Additional privileges
GRANT INSERT ANY TABLE, UPDATE ANY TABLE, DELETE ANY TABLE, SELECT ANY TABLE TO expiry_admin;
GRANT ALTER ANY TABLE, DROP ANY TABLE, CREATE ANY TABLE TO expiry_admin;
GRANT CREATE USER, DROP USER, ALTER USER TO expiry_admin;
GRANT UNLIMITED TABLESPACE TO expiry_admin;



ALTER SESSION SET CONTAINER = THUR_27413_Leslie_ExpiredGoodsDB;


CREATE TABLESPACE expiry_data
DATAFILE 'expiry_data01.dbf'
SIZE 100M AUTOEXTEND ON NEXT 50M MAXSIZE 2G;

CREATE TABLESPACE expiry_idx
DATAFILE 'expiry_idx01.dbf'
SIZE 50M AUTOEXTEND ON NEXT 25M MAXSIZE 1G;

CREATE TEMPORARY TABLESPACE expiry_temp
TEMPFILE 'expiry_temp01.dbf'
SIZE 100M AUTOEXTEND ON NEXT 50M MAXSIZE 500M;

-- Update user with tablespaces
ALTER USER expiry_admin
DEFAULT TABLESPACE expiry_data
TEMPORARY TABLESPACE expiry_temp
QUOTA UNLIMITED ON expiry_data
QUOTA UNLIMITED ON expiry_idx;



-- Sequences
CREATE SEQUENCE seq_product_id START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE seq_staff_id START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE seq_alert_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_log_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_sale_id START WITH 1000 INCREMENT BY 1;

-- Tables
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
    last_alert_date DATE,
    created_date TIMESTAMP
);

CREATE TABLE staff (
    staff_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    role VARCHAR2(50) NOT NULL,
    department VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    is_active CHAR(1)
);

CREATE TABLE alerts (
    alert_id NUMBER PRIMARY KEY,
    product_id NUMBER,
    alert_type VARCHAR2(20) NOT NULL,
    alert_date TIMESTAMP,
    status VARCHAR2(28),
    assigned_to NUMBER
);

CREATE TABLE action_log (
    log_id NUMBER PRIMARY KEY,
    product_id NUMBER NOT NULL,
    staff_id NUMBER NOT NULL,
    action_taken VARCHAR2(50) NOT NULL,
    action_date TIMESTAMP,
    notes VARCHAR2(500)
);

CREATE TABLE sales (
    sale_id NUMBER PRIMARY KEY,
    product_id NUMBER NOT NULL,
    quantity NUMBER(6) NOT NULL,
    sale_date TIMESTAMP,
    discount_applied NUMBER(3),
    unit_price NUMBER(10,2) NOT NULL,
    final_price NUMBER(10,2) NOT NULL
);