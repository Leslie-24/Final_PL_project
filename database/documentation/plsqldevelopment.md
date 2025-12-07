# Phase VI: PL/SQL Development
## Expired Goods Auto-Detection System

### Student Information
- **Name:** Akariza Gasana Leslie
- **Student ID:** 27413
- **Group:** Thursday
- **Course:** Database Development with PL/SQL (INSY 8311)
- **Institution:** Adventist University of Central Africa (AUCA)
- **Lecturer:** Eric Maniraguha
- **Completion Date:** December 2025

### Project Overview
Phase VI implements comprehensive PL/SQL components for the Expired Goods Auto-Detection System, providing automated business logic, data processing, and analytical capabilities.

### Files Included
1. **phase6_plsql.sql** - Main PL/SQL script with all components
2. **phase6_test.sql** - Testing script to validate all components
3. **phase6_validation.sql** - Validation report script
4. **README_Phase6.md** - This documentation file

### PL/SQL Components Implemented

#### 1. Procedures (5 Total)
- `generate_expiry_alerts` - Automated alert generation based on expiry dates
- `assign_alert_to_staff` - Staff assignment to alerts with validation
- `process_product_sale` - Complete sales processing with discount application
- `update_product_status_batch` - Batch update of product expiry statuses
- `resolve_alert` - Alert resolution with audit logging

#### 2. Functions (5 Total)
- `calculate_days_until_expiry` - Calculates days remaining until product expiry
- `get_recommended_discount` - Determines discount rate based on expiry proximity
- `check_product_alert_status` - Returns alert status for a product
- `calculate_total_discount_value` - Calculates total discount value for reporting
- `validate_staff_for_action` - Validates staff permissions for specific actions

#### 3. Package
- `expiry_management_pkg` - Comprehensive package containing:
  - 5 procedures for daily operations
  - 5 functions for calculations and validations
  - REF CURSOR for expiring products retrieval
  - Custom exceptions for error handling

#### 4. Cursors
- Explicit cursor example for batch processing expiring products
- REF CURSOR implementation within the package for flexible data retrieval

#### 5. Window Functions
- Product expiry ranking with ROW_NUMBER(), RANK(), DENSE_RANK()
- Staff performance analysis with LAG() and LEAD() functions
- Sales trend analysis with moving averages and cumulative sums

### Business Rules Implemented
1. **Tiered Alert System:**
   - CRITICAL alerts for products expiring in 1-2 days
   - MODERATE alerts for products expiring in 3-7 days

2. **Progressive Discounting:**
   - 50% discount for 1-day expiry
   - 40% discount for 2-day expiry
   - 30% discount for 3-day expiry
   - 20% discount for 4-7 day expiry
   - 10% discount for 8-14 day expiry

3. **Stock Management:**
   - Automatic stock updates on sales
   - Alert resolution when stock reaches zero
   - Validation of stock availability before sales

4. **Staff Management:**
   - Role-based action validation
   - Performance tracking
   - Assignment validation

### Testing Methodology
All components have been tested with:
1. **Unit Testing:** Individual procedure/function validation
2. **Integration Testing:** Cross-component interaction
3. **Data Validation:** Business rule compliance
4. **Exception Testing:** Error handling scenarios

### Requirements Compliance
- ✅ 5 Procedures (minimum 3-5 required)
- ✅ 5 Functions (minimum 3-5 required)
- ✅ 1 Complete Package (specification + body)
- ✅ Cursor implementations (explicit + REF CURSOR)
- ✅ Window function queries (3 examples)
- ✅ Comprehensive exception handling
- ✅ Testing and validation scripts
- ✅ Integration with existing Phase V database

### How to Run
1. Execute `phase6_plsql.sql` to create all PL/SQL components
2. Run `phase6_test.sql` to validate all components
3. Execute `phase6_validation.sql` for comprehensive report

### Next Steps (Phase VII)
This implementation provides a solid foundation for Phase VII, which will focus on:
1. Triggers for automated business rules
2. Comprehensive auditing system
3. Security enhancements
4. Advanced error handling

### Notes
- All code includes proper exception handling
- Sequences are created for automatic ID generation
- Fallback mechanisms are implemented for sequence errors
- Code follows Oracle PL/SQL best practices
- All components are production-ready