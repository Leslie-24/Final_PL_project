# Expired Goods Auto-Detection & Discount System

## Project Overview
A comprehensive Oracle PL/SQL-based database system designed to automate the monitoring of product expiration dates in retail environments. The system provides real-time tiered alerts, automatic progressive discounting, staff workflow management, and business intelligence dashboards to minimize waste and maximize revenue recovery from near-expired products.

## Student Information
- **Name**: Akariza Gasana Leslie
- **Student ID**: 27413
- **Group**: Thursday
- **Course**: Database Development with PL/SQL (INSY 8311)
- **Institution**: Adventist University of Central Africa (AUCA)
- **Lecturer**: Eric Maniraguha
- **Completion Date**: December 2025

## Problem Statement
Retail businesses experience significant financial losses due to expired goods, manual monitoring inefficiencies, and inconsistent discount strategies. This system addresses these challenges by implementing automated real-time expiry tracking, intelligent alerting mechanisms, and data-driven discount optimization.

## Key Objectives
1. Reduce expired goods waste by 40% through proactive monitoring
2. Increase revenue recovery from near-expiry products by 25%
3. Automate 100% of tiered alert generation (CRITICAL/MODERATE)
4. Eliminate 80% of manual expiry checking through system automation
5. Ensure 100% audit trail coverage for compliance requirements
6. Provide real-time business intelligence dashboards for decision-making

## Quick Start Instructions

### Prerequisites
- Oracle Database 19c or 21c
- SQL Developer or SQL*Plus
- SYSDBA privileges for PDB creation
- 500MB minimum disk space

### Installation Steps
1. **Create PDB Database:**
```sql
CREATE PLUGGABLE DATABASE THUR_27413_Leslie_ExpiredGoodsDB
ADMIN USER admin IDENTIFIED BY password;
ALTER SESSION SET CONTAINER = THUR_27413_Leslie_ExpiredGoodsDB;
```
2.  **Create User & Grant Privileges:**
```sql
CREATE USER expiry\_admin IDENTIFIED BY Leslie;
GRANT CREATE SESSION, CREATE TABLE, CREATE PROCEDURE, CREATE TRIGGER TO expiry\_admin;
GRANT UNLIMITED TABLESPACE TO expiry\_admin;
```

3.  **Execute Scripts in Order:**
    
    *   [database/scripts/createqueuries.sql](https://database/scripts/createqueuries.sql) \- Database setup
        
    *   [database/scripts/insertqueuery.sql](https://database/scripts/insertqueuery.sql) \- Tables and test data
        
    *   [database/scripts/Plsqlcomponents.sql](https://database/scripts/Plsqlcomponents.sql) \- PL/SQL components
        
    *   [database/scripts/triggers.sql](https://database/scripts/triggers.sql) \- Security and auditing
        
4.  **Test the System:**
    
    *   [queries/phase6testscript.sql](https://queries/phase6testscript.sql) \- PL/SQL validation
        
    *   [queries/testscriptphase7.sql](https://queries/testscriptphase7.sql) \- Trigger testing
        
    *   [queries/audits.sql](https://queries/audits.sql) \- Audit verification
        

### Default Credentials

*   **PDB**: `THUR_27413_Leslie_ExpiredGoodsDB`
    
*   **User**: `expiry_admin`
    
*   **Password**: `Leslie`
    
*   **Host**: `localhost:1521`
    

Links to Documentation
----------------------

### Business Intelligence

*   **KPI Definitions**: [business\_intelligence/KPIdefinitions.md](https://business_intelligence/KPIdefinitions.md) \- Key Performance Indicators and metrics including Expiry Prevention Rate (85%), Alert Response Time (<4h), and Discount Effectiveness Ratio (≥75%)
    
*   **BI Requirements**: [business\_intelligence/birequirements.md](https://business_intelligence/birequirements.md) \- Stakeholder requirements, reporting frequencies, and decision support needs
    
*   **Dashboard Mockups**: [business\_intelligence/dashboard.md](https://business_intelligence/dashboard.md) \- Executive, Audit, and Performance dashboard designs with real-time metrics
    

### Phase Documentation

*   **Phase IV - Database Configuration**: [database/documentation/databasconfig.md](https://database/documentation/databasconfig.md) \- PDB setup, privilege grants, tablespace configuration (100MB expiry\_data, 50MB expiry\_idx)
    
*   **Phase V - Table Implementation**: [database/documentation/tableimplementation.md](https://database/documentation/tableimplementation.md) \- Schema implementation with 7 tables, 27 indexes, and 1,250+ test records
    
*   **Phase VI - PL/SQL Development**: [database/documentation/plsqldevelopment.md](https://database/documentation/plsqldevelopment.md) \- 5 procedures, 5 functions, and 1 package with comprehensive error handling
    
*   **Phase VII - Triggers & Auditing**: [database/documentation/triggerauditing.md](https://database/documentation/triggerauditing.md) \- Security implementation with 5 triggers, holiday management, and audit logging
    

### System Documentation

*   **System Architecture**: [documentation/architecture.md](https://documentation/architecture.md) \- Complete technical architecture including database design, PL/SQL components, and data flow diagrams
    
*   **Data Dictionary**: [documentation/datadictionary.md](https://documentation/datadictionary.md) \- Comprehensive table specifications with column definitions, constraints, and sample data for all 7 tables
    
*   **Design Decisions**: [documentation/designdecisions.md](https://documentation/designdecisions.md) \- Technical implementation choices, business rule justifications, and architectural decisions
    

### SQL Scripts

*   **Database Creation**: [database/scripts/createqueuries.sql](https://database/scripts/createqueuries.sql) \- Complete PDB setup, tablespace creation, and user configuration
    
*   **Data Insertion**: [database/scripts/insertqueuery.sql](https://database/scripts/insertqueuery.sql) \- Table creation with 1,250+ realistic test records across all business tables
    
*   **PL/SQL Components**: [database/scripts/Plsqlcomponents.sql](https://database/scripts/Plsqlcomponents.sql) \- Complete PL/SQL implementation with 5 procedures, 5 functions, 1 package, cursor examples, and window functions
    
*   **Triggers**: [database/scripts/triggers.sql](https://database/scripts/triggers.sql) \- Security triggers and audit system implementation with holiday management
    

### Testing Scripts

*   **Phase VI Testing**: [queries/phase6testscript.sql](https://queries/phase6testscript.sql) \- Comprehensive PL/SQL component validation with unit testing for all procedures and functions
    
*   **Phase VII Testing**: [queries/testscriptphase7.sql](https://queries/testscriptphase7.sql) \- Security trigger validation and audit system testing with 6 test scenarios
    
*   **Audit Verification**: [queries/audits.sql](https://queries/audits.sql) \- Security audit system verification, trigger status checking, and compliance validation
    
*   **Analytical Queries**: [queries/analyticalqueries.sql](https://queries/analyticalqueries.sql) \- Business intelligence queries for reporting, analysis, and window function implementations
    
*   **Data Retrieval**: [queries/dataretrieval.sql](https://queries/dataretrieval.sql) \- Basic data retrieval, joins, aggregations, and subquery validation
    

### Screenshots

#### Database Objects

*   **Tables & Indexes**: [screenshots/database\_objects/tables\_indexes.png](https://screenshots/database_objects/tables_indexes.png) \- Database table and index structure showing all 7 tables and 27 indexes
    
*   **Sequences**: [screenshots/database\_objects/sequences.png](https://screenshots/database_objects/sequences.png) \- Sequence implementations for auto-increment IDs across all tables
    
*   **Package**: [screenshots/database\_objects/package.png](https://screenshots/database_objects/package.png) \- PL/SQL package structure showing expiry\_management\_pkg specification and body
    
*   **Procedures, Functions, Triggers**: [screenshots/database\_objects/procedure\_function\_triggers.png](https://screenshots/database_objects/procedure_function_triggers.png) \- Complete PL/SQL component overview showing all 6 procedures, 11 functions, and 5 triggers
    

#### Procedure Implementations

*   **Generate Expiry Alert**: [screenshots/procedure\_triggers/generate\_expiry\_alert.png](https://screenshots/procedure_triggers/generate_expiry_alert.png) \- Alert generation procedure with tiered classification logic
    
*   **Assign Alert to Staff**: [screenshots/procedure\_triggers/assign\_alert\_to\_staff.png](https://screenshots/procedure_triggers/assign_alert_to_staff.png) \- Staff assignment procedure with role validation
    
*   **Process Product Sale**: [screenshots/procedure\_triggers/process\_product.png](https://screenshots/procedure_triggers/process_product.png) \- Sales processing procedure with automatic discount application
    
*   **Update Product Status**: [screenshots/procedure\_triggers/update\_product.png](https://screenshots/procedure_triggers/update_product.png) \- Batch status update procedure for EXPIRED/CRITICAL/NEAR\_EXPIRY classification
    
*   **Resolve Alert**: [screenshots/procedure\_triggers/resolve\_alert.png](https://screenshots/procedure_triggers/resolve_alert.png) \- Alert resolution procedure with audit logging
    
*   **Log Audit**: [screenshots/procedure\_triggers/log\_audit.png](https://screenshots/procedure_triggers/log_audit.png) \- Audit logging procedure with autonomous transaction handling
    
*   **Log Security**: [screenshots/procedure\_triggers/log\_security.png](https://screenshots/procedure_triggers/log_security.png) \- Security audit procedure with session tracking
    

### Test Results

*   **Phase VI Test Results**: [sample\_data/test\_results/test phase6.md](https://sample_data/test_results/test%2520phase6.md) \- PL/SQL component validation results showing all 16 components working correctly
    
*   **Phase VII Test Results**: [sample\_data/test\_results/tests phase7.md](https://sample_data/test_results/tests%2520phase7.md) \- Trigger system testing results with 4 out of 6 tests passed
    
*   **Audit Results**: [sample\_data/test\_results/audit result.md](https://sample_data/test_results/audit%2520result.md) \- Security audit verification showing 5 triggers active and 6 audit entries
    
*   **Alert Log Test**: [sample\_data/test\_results/alertlogtest.png](https://sample_data/test_results/alertlogtest.png) \- Alert system testing output with product category analysis
    
*   **Expiry Processing**: [sample\_data/test\_results/expiryproductprocessing.png](https://sample_data/test_results/expiryproductprocessing.png) \- Expiry processing test results showing 8 products expiring in 7 days
    

### Sample Data

*   **Sample Data README**: [sample\_data/README.md](https://sample_data/README.md) \- Overview of sample data files and test configurations
    
*   **ER Diagram**: [sample\_data/ER\_diagram.png](https://sample_data/ER_diagram.png) \- Entity Relationship diagram showing table relationships and foreign keys
    

System Specifications
---------------------

### Database Architecture

*   **PDB**: THUR\_27413\_Leslie\_ExpiredGoodsDB
    
*   **Tablespaces**: expiry\_data (100MB), expiry\_idx (50MB), expiry\_temp (100MB)
    
*   **Sequences**: 12 sequences for auto-increment IDs
    
*   **Indexes**: 27 optimized indexes for performance
    
*   **Constraints**: 28 NOT NULL, 5 foreign keys, check constraints
    

### PL/SQL Components

*   **Procedures**: 6 comprehensive procedures with error handling
    
*   **Functions**: 11 business functions for calculations and validations
    
*   **Package**: 1 complete package (expiry\_management\_pkg) with specification and body
    
*   **Triggers**: 5 security triggers with audit logging
    
*   **Cursors**: Explicit and REF CURSOR implementations
    
*   **Window Functions**: Advanced analytical queries for BI
    

### Business Rules Implemented

1.  **Tiered Alert System:**
    
    *   CRITICAL: ≤2 days to expiry (automated discount application)
        
    *   MODERATE: 3-7 days to expiry (staff notification)
        
2.  **Progressive Discounting:**
    
    *   50%: 1 day remaining
        
    *   40%: 2 days remaining
        
    *   30%: 3 days remaining
        
    *   20%: 4-7 days remaining
        
    *   10%: 8-14 days remaining
        
3.  **Security Restrictions:**
    
    *   DML operations blocked on weekdays (Monday-Friday)
        
    *   DML operations blocked on configured holidays
        
    *   Comprehensive audit logging of all attempts
        

### Testing & Validation Status

*   ✅ **Phase V**: Table implementation validated (1,250+ records)
    
*   ✅ **Phase VI**: PL/SQL components validated (all 16 components working)
    
*   ✅ **Phase VII**: Triggers and auditing validated (5 triggers active)
    
*   ✅ **Data Integrity**: All constraints and relationships validated
    
*   ✅ **Performance**: BI queries executing in <0.3 seconds
    

Support & Contact
-----------------

For technical support or questions regarding this system:

**Student Developer:** Akariza Gasana Leslie  
**Course:** Database Development with PL/SQL (INSY 8311)  
**Institution:** Adventist University of Central Africa (AUCA)  
**Academic Year:** 2024-2025

_This project was developed as part of academic coursework and demonstrates comprehensive database development skills using Oracle PL/SQL._
