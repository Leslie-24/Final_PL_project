# Design Decisions

## 1. Database Design Decisions
**Decision:** Use pluggable database (PDB) instead of standalone
**Reason:** Better resource isolation, easier management
**Implementation:** `THUR_27413_Leslie_ExpiredGoodsDB`

**Decision:** Separate tablespaces for data and indexes
**Reason:** Performance optimization, manageability
**Implementation:** expiry_data (100MB), expiry_idx (50MB), expiry_temp (100MB)

**Decision:** Use TIMESTAMP for audit trails instead of DATE
**Reason:** Need millisecond precision for action tracking
**Implementation:** `action_log.action_date`, `alerts.alert_date`

## 2. Table Design Decisions
**Decision:** Store discount_rate in products table
**Reason:** Dynamic discount calculation based on expiry proximity
**Implementation:** Updated by `update_product_status_batch()`

**Decision:** Separate alerts and action_log tables
**Reason:** Alerts for current status, action_log for historical audit
**Implementation:** alerts (current), action_log (historical)

**Decision:** Include staff_id in sales table
**Reason:** Track which staff processed each sale for accountability
**Implementation:** Foreign key to staff table

## 3. PL/SQL Design Decisions
**Decision:** Create package instead of standalone procedures
**Reason:** Better organization, encapsulation, performance
**Implementation:** `expiry_management_pkg` with 5 procedures, 5 functions

**Decision:** Use explicit sequence fallback mechanism
**Reason:** Handle sequence errors gracefully
**Implementation:** `SELECT NVL(MAX(alert_id), 0) + 1` fallback

**Decision:** Implement REF CURSOR for expiring products
**Reason:** Flexible result set handling for different front-ends
**Implementation:** `expiring_products_refcur` in package

## 4. Business Rule Decisions
**Decision:** Tiered discount system (10-50%)
**Reason:** Progressive incentive based on urgency
**Implementation:** 
- 50%: 1 day remaining
- 40%: 2 days remaining  
- 30%: 3 days remaining
- 20%: 4-7 days remaining
- 10%: 8-14 days remaining

**Decision:** Two-tier alert system (CRITICAL/MODERATE)
**Reason:** Different urgency levels require different responses
**Implementation:** 
- CRITICAL: ≤2 days remaining
- MODERATE: 3-7 days remaining

**Decision:** Automatic status updates
**Reason:** Ensure real-time accuracy without manual intervention
**Implementation:** `update_product_status_batch()` procedure

## 5. Security Design Decisions
**Decision:** Block DML on weekdays/holidays
**Reason:** Prevent unauthorized changes during peak times
**Implementation:** 5 triggers with restriction functions

**Decision:** Create separate audit log table
**Reason:** Comprehensive security tracking separate from business logs
**Implementation:** `security_audit_log` table

**Decision:** Holiday management system
**Reason:** Dynamic restriction based on calendar
**Implementation:** `holidays` table with active/inactive control

## 6. Testing Design Decisions
**Decision:** Generate realistic test data
**Reason:** Simulate real-world scenarios for validation
**Implementation:** 100 products with varied expiry dates

**Decision:** Comprehensive validation at each phase
**Reason:** Ensure system integrity before moving to next phase
**Implementation:** Phase V-VII validation documented

**Decision:** Use window functions for analytics
**Reason:** Advanced reporting capabilities built into database
**Implementation:** Product ranking, staff performance queries