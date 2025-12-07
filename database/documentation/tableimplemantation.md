Phase V: Table Implementation & Data Insertion
Student: Akariza Gasana Leslie (27413)
Group: Thursday
Course: Database Development with PL/SQL (INSY 8311)
Institution: Adventist University of Central Africa (AUCA)
Lecturer: Eric Maniraguha
Completion Date: December 5, 2025

Project Overview
Phase V completes the physical database implementation for the Expired Goods Auto-Detection System with comprehensive table structures, constraints, indexes, and realistic test data.

Database Schema Implementation
Tables Created (5 Core Tables + 2 Phase VII Tables)
1. PRODUCTS - Core inventory table with expiry tracking
Columns: product_id, product_name, category, purchase_date, expiry_date, stock_qty, discount_rate, unit_price, status, created_date

Automatic Status Updates: ACTIVE, NEAR_EXPIRY, CRITICAL, EXPIRED via update_product_status_batch()

Tiered Discount System: 50% (1 day), 40% (2 days), 30% (3 days), 20% (4-7 days), 10% (8-14 days)

Actual Data: 100 products across 8 categories (Bakery, Meat, Produce, Beverages, Snacks, Frozen, Canned, Dairy)

2. STAFF - System users and store employees
Columns: staff_id, name, role, department, email, is_active

Actual Data: 150 employee records with realistic roles and departments

Role-based Access Control: Manager, Supervisor, Clerk, Admin, Assistant

Departments: Management, Inventory, Sales, Customer Service

3. ALERTS - Automated expiration alerts
Columns: alert_id, product_id, alert_type, alert_date, status, assigned_to

Tiered Alert System: CRITICAL (≤2 days), MODERATE (3-7 days)

Status Workflow: PENDING → ASSIGNED → RESOLVED

Actual Data: 200 alerts generated with real tracking

4. ACTION_LOG - Comprehensive audit trail
Columns: log_id, product_id, staff_id, action_taken, action_date, notes

Action Types: DISCOUNT_APPLIED, ALERT_GENERATED, ALERT_RESOLVED, STOCK_UPDATED, SALE_PROCESSED

Actual Data: 300 action log entries with full timestamp tracking

5. SALES - Transaction processing
Columns: sale_id, product_id, quantity, sale_date, discount_applied, unit_price, final_price, staff_id, payment_method

Automatic Discount Application: Via process_product_sale() procedure

Payment Methods: CASH, CARD, MOBILE

Actual Data: 500 sales transactions with discount tracking

6. HOLIDAYS - Holiday management for trigger restrictions (Phase VII)
Columns: holiday_id, holiday_name, holiday_date, holiday_type, is_active, created_date

Purpose: Used by triggers to block DML operations on holidays

Actual Data: 3 holidays configured (Christmas Day, New Years Day, Independence Day)

7. SECURITY_AUDIT_LOG - Security audit tracking (Phase VII)
Columns: audit_id, table_name, operation_type, operation_date, user_name, status

Purpose: Captures all DML attempts blocked by triggers

Actual Data: 6 audit entries captured during testing

Database Summary
Total Tables: 7 tables implemented

Total Records: 1,250+ realistic test records

Total Columns: 49 columns across all tables

Foreign Key Relationships: 5 relationships established

Data Validation: All business rules enforced

Technical Implementation
Constraints Applied
Primary Keys: All 7 tables have unique identifiers with sequences

Foreign Keys: 5 relationships (alerts→products, alerts→staff, sales→products, sales→staff, action_log→products, action_log→staff)

Check Constraints:

Discount rates: 0-100%

Stock quantities: Non-negative

Status values: Valid enum values enforced

Email format: Basic validation

NOT NULL: 28 mandatory business fields

DEFAULT VALUES: Created_date (SYSTIMESTAMP), is_active ('Y'), payment_method ('CASH')

Indexes Created (6 Performance Indexes)
idx_products_expiry - Optimizes expiry date queries

idx_products_category - Category-based filtering

idx_staff_dept - Department-level reporting

idx_alerts_status - Alert status monitoring

idx_sales_date - Sales trend analysis

idx_log_date - Audit trail time-based queries

Data Volume Achieved
Products: 100 rows with diverse expiry scenarios

Staff: 150 employees across 4 departments

Alerts: 200 automated alerts generated

Action Log: 300 entries tracking all system actions

Sales: 500 transactions with discount tracking

Holidays: 3 configured holidays

Security Audit: 6 test entries captured

Business Intelligence Capabilities
Analytical Queries Implemented
Expiry Risk Analysis: Products categorized by days remaining using window functions

Alert Effectiveness: Response rates by alert type and staff performance

Discount Impact: Revenue recovery analysis from near-expiry products

Category Performance: Turnover rates by product category

Staff Productivity: Actions taken vs. alerts resolved metrics

Data Validation Results
✅ All 7 tables created successfully

✅ 6 performance indexes operational

✅ All constraints validated and enforced

✅ 1,250+ realistic test records inserted

✅ Foreign key relationships maintained

✅ Business rule compliance verified

Testing & Verification
Test Scenarios Covered
Positive Testing: Valid data insertion and retrieval for all tables

Negative Testing: Constraint violation prevention (discount > 100%, negative stock)

Edge Cases: Zero quantities, maximum discounts, date boundary validation

Integration Testing: Cross-table relationship validation (alerts↔products, sales↔staff)

Performance Testing: Query execution with and without indexes

Validation Results
✅ All CREATE scripts executed successfully

✅ All INSERT scripts populated with realistic data

✅ SELECT queries returning accurate results

✅ JOIN operations working correctly

✅ Aggregation queries providing business insights

✅ Ready for PL/SQL development in Phase VI

Database Connection & Configuration
PDB Information
PDB Name: THUR_27413_Leslie_ExpiredGoodsDB

Admin User: expiry_admin

Password: Leslie

Host: localhost

Port: 1521

Tablespaces Created
EXPIRY_DATA (100MB) - User data storage

EXPIRY_IDX (50MB) - Index storage

EXPIRY_TEMP (100MB) - Temporary operations

Sequences Created (7 Sequences)
alerts_seq - Alert ID generation

action_log_seq - Log ID generation

sales_seq - Sale ID generation

seq_product_id - Product ID generation

seq_staff_id - Staff ID generation

holiday_seq - Holiday ID generation

security_audit_seq - Audit ID generation

Business Impact
Waste Reduction: Automated detection prevents product expiration

Revenue Recovery: Tiered discounts maximize near-expiry sales

Operational Efficiency: Automated alerts reduce manual checking

Compliance: Comprehensive audit trail for regulatory requirements

Decision Support: Business intelligence for data-driven decisions