# Expired Goods Auto-Detection & Discount System

## Project Overview
A comprehensive PL/SQL-based Oracle database solution for automated monitoring of product expiration dates with tiered alerting, automatic discount application, and business intelligence capabilities. This system is designed for retail stores, supermarkets, and warehouses to efficiently manage product shelf life, reduce waste, and optimize revenue recovery from near-expired items.

## Student Information
- **Name:** Akariza Gasana Leslie
- **Student ID:** 27413
- **Group:** Thursday
- **Course:** Database Development with PL/SQL (INSY 8311)
- **Institution:** Adventist University of Central Africa (AUCA)
- **Lecturer:** Eric Maniraguha
- **Project Completion Date:** December 2025

## Problem Statement
Retail businesses face significant financial losses due to expired goods, manual monitoring inefficiencies, and suboptimal discount strategies. Current inventory management systems lack automated real-time expiry tracking, intelligent alerting mechanisms, and data-driven decision support for discount optimization.

This system solves these challenges by providing automated expiry monitoring, tiered alert generation, dynamic discount application, and comprehensive business intelligence for inventory management decision-making.

## Key Objectives
- Reduce expired goods waste by 40% through proactive monitoring
- Increase revenue recovery from near-expired items by 25% via optimized discounts
- Automate tiered alert generation (Moderate/Critical) based on expiry proximity
- Eliminate 80% of manual expiry checking through system automation
- Provide real-time BI insights for inventory optimization and strategic decisions
- Implement comprehensive audit trails for compliance and performance tracking

## Quick Start Instructions

### Prerequisites
- Oracle Database 19c or 21c installed
- SQL Developer or SQL*Plus
- System privileges for PDB creation
- Minimum 500MB disk space

### Installation Steps

#### 1. Database Setup
```sql
-- Create PDB (run as SYS)
CREATE PLUGGABLE DATABASE THUR_27413_Leslie_ExpiredGoodsDB
ADMIN USER admin IDENTIFIED BY password
FILE_NAME_CONVERT = ('/opt/oracle/oradata/XE/pdbseed/', 
                     '/opt/oracle/oradata/XE/THUR_27413_LESLIE_EXPIREDGOODSDB/');

-- Switch to PDB
ALTER SESSION SET CONTAINER = THUR_27413_Leslie_ExpiredGoodsDB;
```

#### 2. User & Tablespace Configuration
```sql
CREATE USER expiry_admin IDENTIFIED BY Leslie;
-- Grant privileges (see creationphase5.sql for complete list)
GRANT CREATE SESSION, CREATE TABLE, CREATE PROCEDURE TO expiry_admin;

-- Create tablespaces
CREATE TABLESPACE expiry_data DATAFILE 'expiry_data01.dbf' SIZE 100M;
CREATE TABLESPACE expiry_idx DATAFILE 'expiry_idx01.dbf' SIZE 50M;
```

#### 3. Schema Implementation

-- Run creationphase5.sql to create tables and insert data

-- Run Plsqlscripts.sql to create PL/SQL components

-- Run phase7triggers.sql to implement triggers and auditing


#### 4. Testing & Validation

-- Run validation script.sql to verify data

-- Run phase6testscript.sql to test PL/SQL components

-- Run testscript phase7.sql to verify triggers and auditing


## Default Credentials
PDB Name: THUR_27413_Leslie_ExpiredGoodsDB

Admin User: expiry_admin

Admin Password: Leslie

Host: localhost

Port: 1521

## Database Schema

### Core Tables (7 Tables)
PRODUCTS - Product inventory with expiry tracking

STAFF - System users and store employees

ALERTS - Tiered expiration alerts

ACTION_LOG - Comprehensive audit trail

SALES - Transaction processing with discounts

HOLIDAYS - Holiday management for trigger restrictions

SECURITY_AUDIT_LOG - Security violation tracking

### Business Rules Implemented
Tiered Alert System: MODERATE (4-7 days), CRITICAL (≤3 days)

Progressive Discounting: 10%-50% based on remaining shelf life

Automated Workflows: Daily expiry checks at 6:00 AM

Security Restrictions: No DML on weekdays/holidays

Audit Trail: Comprehensive action logging

## PL/SQL Components

### Procedures (5 Implemented)
generate_expiry_alerts - Automated alert generation

assign_alert_to_staff - Staff assignment with validation

process_product_sale - Sales processing with discount application

update_product_status_batch - Batch status updates

resolve_alert - Alert resolution with audit logging

### Functions (5 Implemented)
calculate_days_until_expiry - Days remaining calculation

get_recommended_discount - Optimal discount determination

check_product_alert_status - Status classification

calculate_total_discount_value - Financial impact analysis

validate_staff_for_action - Permission validation

### Package
Package: expiry_management_pkg

Components: 5 procedures, 5 functions, REF CURSOR implementation

Features: Exception handling, business logic encapsulation

### Triggers (Phase VII)
4 Simple triggers for DML restriction on weekdays/holidays

1 Compound trigger for staff table operations

Comprehensive audit logging for all restricted attempts

## Business Intelligence Capabilities

### Analytical Queries
Expiry Risk Analysis: Products categorized by expiry status

Alert Effectiveness: Response rates by alert type

Discount Impact Analysis: Revenue recovery from discounts

Staff Performance Metrics: Actions taken and resolution rates

Category Performance: Turnover rates by product category

### Window Functions Implemented
Product expiry ranking with ROW_NUMBER(), RANK(), DENSE_RANK()

Staff performance analysis with LAG() and LEAD()

Sales trend analysis with moving averages

Cumulative revenue calculations


## Testing & Validation
The project includes comprehensive testing scripts:

### Phase V: Data Validation

-- Basic data retrieval, joins, aggregations, subqueries

-- See validation script.sql


### Phase VI: PL/SQL Testing

-- Unit testing for procedures, functions, packages

-- See phase6testscript.sql


### Phase VII: Trigger Testing
`
-- Comprehensive trigger validation with 6 test scenarios

-- See testscript phase7.sql


## Phase Completion Status
✅ Phase I: Problem Identification (Completed)

✅ Phase II: Business Process Modeling (Completed)

✅ Phase III: Logical Database Design (Completed)

✅ Phase IV: Database Creation (Completed - Dec 5, 2025)

✅ Phase V: Table Implementation & Data Insertion (Completed)

✅ Phase VI: PL/SQL Development (Completed)

✅ Phase VII: Advanced Programming & Auditing (Completed)

🔄 Phase VIII: Final Documentation & Presentation (In Progress)

## Key Features
Automated Expiry Monitoring: Daily checks with tiered alerts

Dynamic Discount Engine: Progressive discounts (10%-50%)

Comprehensive Auditing: Security restrictions with audit logging

Business Intelligence: Analytical queries and reporting

Workflow Management: Staff assignment and action tracking

Security Controls: DML restrictions on weekdays/holidays

Performance Optimization: 27 indexes for query optimization

Data Integrity: Full 3NF compliance with constraints

## Documentation Links
Phase Documentation  
Phase IV: Database Configuration  
Phase V: Table Implementation  
Phase VI: PL/SQL Development  
Phase V Technical Report  
Project Technical Overview  

Project Guidelines  
Complete Project Requirements  
Project Description & Schema  

Script Files  
Database Creation Script  
Schema & Data Script  
PL/SQL Components  
Triggers & Auditing  

Testing Scripts  
Data Validation  
PL/SQL Testing  
Trigger Testing  
Audit Verification  

## Usage Examples

### Generating Daily Alerts
```sql
BEGIN
    expiry_management_pkg.generate_daily_alerts;
END;
/
```

### Processing a Sale with Discount
```sql
BEGIN
    process_product_sale(
        p_product_id => 1001,
        p_quantity => 5,
        p_staff_id => 101,
        p_payment_method => 'CARD'
    );
END;
/
```

### Checking Product Status
```sql
SELECT product_name, 
       calculate_days_until_expiry(product_id) as days_remaining,
       get_recommended_discount(product_id) as discount,
       check_product_alert_status(product_id) as alert_status
FROM products WHERE product_id = 1001;
```

## Performance Metrics
Data Volume: 100+ products, 150+ staff, 200+ alerts, 300+ action logs

Query Performance: BI queries execute in < 0.3 seconds

Index Coverage: 27 indexes across 7 tables

Constraint Validation: 100% constraint compliance

## Support & Contact
For technical issues or questions regarding this project:

Student: Akariza Gasana Leslie  
Email: [Your Email Address]  
University: Adventist University of Central Africa (AUCA)  
Course: Database Development with PL/SQL (INSY 8311)  
Lecturer: Eric Maniraguha (eric.maniraguha@auca.ac.tw)

## License & Acknowledgments
This project was developed as part of the Database Development with PL/SQL course at AUCA. All code and documentation are original work created for academic purposes.
