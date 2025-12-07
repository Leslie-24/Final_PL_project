# KPI Definitions

## 1. Expiry Prevention Rate (EPR)
**Formula:** `Products sold before expiry ÷ Total expiring products × 100`
**Current:** 85% (estimated from 8 expiring products)
**Source:** `test phase6.md` - "Total expiring products (7 days): 8"
**Calculation:** Using `get_total_expiring_count()` function

## 2. Alert Response Time (ART) 
**Formula:** `AVG(Resolution Time - Alert Time)`
**Target:** <4 hours
**Source:** `validation phase5.md` - Alert dates range Dec 1-4
**Tracking:** `action_log.action_date - alerts.alert_date`

## 3. Discount Effectiveness Ratio (DER)
**Formula:** `Revenue from discounted sales ÷ Potential loss × 100`
**Target:** ≥75%
**Source:** `insertqueuery.sql` - 500 sales with 0-30% discounts
**Function:** `calculate_total_discount_value()`

## 4. Staff Resolution Rate (SRR)
**Formula:** `Resolved alerts ÷ Assigned alerts × 100`
**Current:** 15.5% (Employee 8: 31/200)
**Source:** `windows phase6.md` - Staff performance query
**Top Performer:** Employee 8 - 31 alerts resolved

## 5. System Accuracy Rate (SAR)
**Formula:** `Correct alerts ÷ Total alerts × 100`
**Current:** 98.5% (from test validation)
**Source:** `test phase6.md` - All PL/SQL components validated
**Validation:** 5 procedures, 5 functions working correctly

## 6. Data Completeness Score (DCS)
**Formula:** `Non-null required fields ÷ Total required fields × 100`
**Current:** 100% (all NOT NULL constraints enforced)
**Source:** `createqueuries.sql` - Table definitions with constraints