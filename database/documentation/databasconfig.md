# Phase IV: Database Configuration - Expired Goods Auto-Detection System

**Student:** Akariza Gasana Leslie (27413)  
**Group:** Thursday  
**Course:** Database Development with PL/SQL (INSY 8311)  
**Institution:** Adventist University of Central Africa (AUCA)  
**Lecturer:** Eric Maniraguha

## Project Overview
This phase establishes the Oracle pluggable database configuration for the Expired Goods Auto-Detection & Discount System, implementing automated monitoring of product expiration with tiered alerts and discounts.

## Database Configuration

### PDB Information
- **PDB Name:** THUR_27413_Leslie_ExpiredGoodsDB
- **Admin User:** expiry_admin
- **Admin Password:** Leslie
- **Host:** localhost
- **Port:** 1521

### Tablespaces Created
1. **EXPIRY_DATA** (100MB) - User data storage
2. **EXPIRY_IDX** (50MB) - Index storage  
3. **EXPIRY_TEMP** (100MB) - Temporary operations
4. **USERS** (50MB) - Additional user data

### Admin Privileges Granted
- CREATE SESSION, TABLE, VIEW, PROCEDURE, TRIGGER, SEQUENCE
- DML privileges: INSERT/UPDATE/DELETE/SELECT ANY TABLE
- DDL privileges: ALTER/DROP/CREATE ANY TABLE
- Administrative: CREATE/DROP/ALTER USER, GRANT ANY PRIVILEGE
- Unlimited tablespace access

## Database Schema Implementation

### Tables Created
1. **PRODUCTS** - Product inventory with expiry dates
2. **STAFF** - System users and administrators
3. **ALERTS** - Tiered expiration alerts (Moderate/Critical)
4. **ACTION_LOG** - Audit trail of actions taken
5. **SALES** - Sales transactions with automatic discounts

### Sequences Created
- `seq_product_id` - Product identifiers
- `seq_staff_id` - Staff identifiers  
- `seq_alert_id` - Alert identifiers
- `seq_log_id` - Action log identifiers
- `seq_sale_id` - Sales transaction identifiers

## Test Data
- **50+ realistic rows** across all tables
- **Diverse product categories** (Dairy, Bakery)
- **Various expiry scenarios** (Critical, Moderate, Safe)
- **Sample alerts and actions** representing real workflows
- **Sales transactions** with discount applications

## Business Intelligence Capabilities
The database supports analytical queries for:
- Expiry status analysis by category
- Stock value calculations
- Alert statistics and trends
- Discount impact analysis
- Staff response metrics

## Verification & Testing
All components verified through:
1. User privilege validation
2. Table creation verification
3. Test data insertion and integrity checks
4. Business intelligence query execution
5. Constraint enforcement testing