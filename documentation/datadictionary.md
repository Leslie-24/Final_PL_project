# Data Dictionary

## 1. products
| Column | Type | Constraints | Description | Sample Data |
|--------|------|-------------|-------------|-------------|
| product_id | NUMBER | PRIMARY KEY | Unique product identifier | 1001 |
| product_name | VARCHAR2(200) | NOT NULL | Product name | "Product 1" |
| category | VARCHAR2(100) | NOT NULL | Product category | "Bakery" |
| purchase_date | DATE | NOT NULL | Date purchased | 03-DEC-25 |
| expiry_date | DATE | NOT NULL | Expiration date | 08-JAN-26 |
| stock_qty | NUMBER(5) | | Current stock quantity | 208 |
| discount_rate | NUMBER(3) | | Current discount rate | 0 |
| unit_price | NUMBER(10,2) | NOT NULL | Price per unit | 10.02 |
| status | VARCHAR2(20) | | Product status | "CRITICAL" |
| created_date | TIMESTAMP | | Record creation timestamp | 06-DEC-25 12.52.36.396000000 PM |

**Indexes:** idx_products_expiry, idx_products_category
**Total Records:** 100 (from `insertqueuery.sql`)

## 2. staff
| Column | Type | Constraints | Description | Sample Data |
|--------|------|-------------|-------------|-------------|
| staff_id | NUMBER | PRIMARY KEY | Unique staff identifier | 101 |
| name | VARCHAR2(100) | NOT NULL | Staff full name | "Employee 1" |
| role | VARCHAR2(50) | NOT NULL | Job role | "Supervisor" |
| department | VARCHAR2(50) | NOT NULL | Department | "Inventory" |
| email | VARCHAR2(100) | NOT NULL | Email address | "emp1@store.com" |
| is_active | CHAR(1) | DEFAULT 'Y' | Active status | 'Y' |

**Indexes:** idx_staff_dept
**Total Records:** 150 (from `insertqueuery.sql`)

## 3. alerts
| Column | Type | Constraints | Description | Sample Data |
|--------|------|-------------|-------------|-------------|
| alert_id | NUMBER | PRIMARY KEY | Unique alert identifier | 1 |
| product_id | NUMBER | FOREIGN KEY | Reference to products | 1085 |
| alert_type | VARCHAR2(20) | NOT NULL | Alert severity | "CRITICAL" |
| alert_date | TIMESTAMP | DEFAULT SYSTIMESTAMP | Alert creation time | 04-DEC-25 12.52.36.000000000 PM |
| status | VARCHAR2(28) | | Alert status | "PENDING" |
| assigned_to | NUMBER | FOREIGN KEY | Staff assigned | 108 |

**Foreign Keys:** fk_alerts_product, fk_alerts_staff
**Indexes:** idx_alerts_status
**Total Records:** 200 (from `insertqueuery.sql`)

## 4. action_log
| Column | Type | Constraints | Description | Sample Data |
|--------|------|-------------|-------------|-------------|
| log_id | NUMBER | PRIMARY KEY | Unique log identifier | 1 |
| product_id | NUMBER | FOREIGN KEY | Reference to products | 1085 |
| staff_id | NUMBER | FOREIGN KEY | Staff who took action | 108 |
| action_taken | VARCHAR2(50) | NOT NULL | Type of action | "ALERT_GENERATED" |
| action_date | TIMESTAMP | DEFAULT SYSTIMESTAMP | Action timestamp | 06-DEC-25 12.52.36.000000000 PM |
| notes | VARCHAR2(500) | | Additional details | "Action 1 completed" |

**Foreign Keys:** fk_log_product, fk_log_staff
**Indexes:** idx_log_date
**Total Records:** 300 (from `insertqueuery.sql`)

## 5. sales
| Column | Type | Constraints | Description | Sample Data |
|--------|------|-------------|-------------|-------------|
| sale_id | NUMBER | PRIMARY KEY | Unique sale identifier | 1001 |
| product_id | NUMBER | FOREIGN KEY | Product sold | 1001 |
| quantity | NUMBER(6) | NOT NULL | Quantity sold | 4 |
| sale_date | TIMESTAMP | DEFAULT SYSTIMESTAMP | Sale timestamp | 08-SEP-25 |
| discount_applied | NUMBER(3) | | Discount percentage | 0 |
| unit_price | NUMBER(10,2) | NOT NULL | Price at time of sale | 10.02 |
| final_price | NUMBER(10,2) | NOT NULL | Price after discount | 29.66 |
| staff_id | NUMBER | FOREIGN KEY | Processing staff | 101 |
| payment_method | VARCHAR2(20) | DEFAULT 'CASH' | Payment type | "CASH" |

**Foreign Keys:** fk_sales_product, fk_sales_staff
**Indexes:** idx_sales_date
**Total Records:** 500 (from `insertqueuery.sql`)

## 6. holidays (Phase VII)
| Column | Type | Constraints | Description | Sample Data |
|--------|------|-------------|-------------|-------------|
| holiday_id | NUMBER | PRIMARY KEY | Unique holiday identifier | 1 |
| holiday_name | VARCHAR2(100) | NOT NULL | Holiday name | "Christmas Day" |
| holiday_date | DATE | NOT NULL | Holiday date | 25-DEC-2025 |
| holiday_type | VARCHAR2(20) | DEFAULT 'PUBLIC' | Type of holiday | "PUBLIC" |
| is_active | CHAR(1) | DEFAULT 'Y' | Active status | 'Y' |
| created_date | DATE | DEFAULT SYSDATE | Creation date | 06-DEC-2025 |

**Total Records:** 3 (from `triggers.sql`)

## 7. security_audit_log (Phase VII)
| Column | Type | Constraints | Description | Sample Data |
|--------|------|-------------|-------------|-------------|
| audit_id | NUMBER | PRIMARY KEY | Unique audit identifier | 1 |
| table_name | VARCHAR2(50) | NOT NULL | Table name | "PRODUCTS" |
| operation_type | VARCHAR2(10) | NOT NULL | Type of operation | "INSERT" |
| operation_date | DATE | DEFAULT SYSDATE | Operation date | 06-DEC-2025 |
| user_name | VARCHAR2(50) | DEFAULT USER | Username | "EXPIRY_ADMIN" |
| status | VARCHAR2(20) | DEFAULT 'ATTEMPTED' | Operation status | "DENIED" |

**Total Records:** 6 (from `audit result.md`)