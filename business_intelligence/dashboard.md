# Dashboard Mockups

## 1. Executive Summary Dashboard
┌─────────────────────────────────────────────────────────┐
│ EXECUTIVE SUMMARY - Expired Goods System                │
├─────────────────────────────────────────────────────────┤
│ KPI CARDS:                                              │
│ ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐                    │
│ │PROD │   │ALRT │   │EXP. │   │DISC │                    │
│ │100  │   │8*   │   │0    │   │$1,245│                   │
│ │Items│   │Next │   │Today│   │Value │                   │
│ └─────┘   └─────┘   └─────┘   └─────┘                    │
│ *From test phase6.md: 8 products expiring in 7 days      │
├─────────────────────────────────────────────────────────┤
│ TREND CHARTS:                                            │
│ 1. Expiry Risk by Category (from windows phase6.md)      │
│    Produce (13%) | Meat (12%) | Bakery (12%) | Dairy (12%)│
│    Snacks (12%) | Canned (12%) | Frozen (11%) | Bev (13%) │
│                                                         │
│ 2. Daily Alert Trends (from validation phase5.md)        │
│    Dec 1-4: 5 alerts on Product 85                       │
│    3 PENDING, 1 ASSIGNED, 1 RESOLVED                     │
├─────────────────────────────────────────────────────────┤
│ IMMEDIATE ACTIONS:                                       │
│ ⚠ Product 82 (Meat) - Expires TODAY - 0.95 days left*    │
│ ⚠ Product 86 (Frozen) - Expires TODAY - 0.95 days left*  │
│ ⚠ Product 95 (Canned) - Expires TODAY - 0.95 days left*  │
│ *From windows phase6.md lines 1-10                       │
└─────────────────────────────────────────────────────────┘

text


## 2. Audit Dashboard
┌─────────────────────────────────────────────────────────┐
│ AUDIT DASHBOARD - Security & Compliance                 │
├─────────────────────────────────────────────────────────┤
│ TRIGGER STATUS (from audit result.md):                  │
│ ┌──────────────────────┬──────────────┬───────────────┐ │
│ │ Trigger              │ Status       │ Enabled       │ │
│ ├──────────────────────┼──────────────┼───────────────┤ │
│ │ Products Insert      │ ALLOWED ✓    │ ✓             │ │
│ │ Alerts Insert        │ FK Error*    │ ✓             │ │
│ │ Sales Insert         │ FK Error*    │ ✓             │ │
│ │ Action Log           │ FK Error*    │ ✓             │ │
│ │ Staff Compound       │ ALLOWED ✓    │ ✓             │ │
│ └──────────────────────┴──────────────┴───────────────┘ │
│ *Referential integrity issue, not trigger blockage       │
├─────────────────────────────────────────────────────────┤
│ AUDIT LOG SUMMARY (from audit result.md):               │
│ Total Audit Entries: 6                                  │
│ Denied Operations: 0                                    │
│ Successful Operations: 0                                │
│ Current Date: Saturday, Dec 6, 2025                     │
│ Operation Restricted: NO                                │
├─────────────────────────────────────────────────────────┤
│ HOLIDAY SCHEDULE (from triggers.sql):                   │
│ 1. Christmas Day - Dec 25, 2025 - ACTIVE                │
│ 2. New Years Day - Jan 1, 2026 - ACTIVE                 │
│ 3. Independence Day - Jan 4, 2026 - ACTIVE              │
└─────────────────────────────────────────────────────────┘

text


## 3. Performance Dashboard
┌─────────────────────────────────────────────────────────┐
│ PERFORMANCE DASHBOARD - System & Staff                  │
├─────────────────────────────────────────────────────────┤
│ SYSTEM PERFORMANCE (from test phase6.md):               │
│ ✅ BASIC FUNCTIONS - Working (3 products tested)         │
│ ✅ PACKAGE FUNCTIONS - Working (8 expiring count)        │
│ ✅ PACKAGE PROCEDURES - Updated 7 products               │
│ ✅ REF CURSOR - Retrieved 8 expiring products            │
│ ✅ STAFF VALIDATION - Staff 101 validated                │
├─────────────────────────────────────────────────────────┤
│ STAFF PERFORMANCE (from windows phase6.md lines 101+):  │
│ TOP 3 STAFF BY ALERTS RESOLVED:                         │
│ 1. Employee 8   - 31 alerts - 15.5% resolution rate      │
│ 2. Employee 79  - 0 alerts - Requires training           │
│ 3. Employee 111 - 0 alerts - Requires training           │
│                                                         │
│ DEPARTMENT PERFORMANCE:                                 │
│ Management: 31 alerts resolved                           │
│ Customer Service: 0 alerts resolved                      │
│ Inventory: 0 alerts resolved                             │
│ Sales: 0 alerts resolved                                 │
├─────────────────────────────────────────────────────────┤
│ RESOURCE USAGE (from validation phase5.md):             │
│ Database Objects: 5 tables, 6 indexes, 5 triggers        │
│ Data Volume: 100 products, 150 staff, 200 alerts         │
│ PL/SQL Components: 5 procedures, 5 functions, 1 package  │
│ Test Coverage: All phases validated                      │
└─────────────────────────────────────────────────────────┘

text


## Data Source References

| Dashboard Section           | Source File           | Line/Content Reference                           |
|-----------------------------|------------------------|--------------------------------------------------|
| Expiring Products Count     | test phase6.md         | "Total expiring products (7 days): 8"            |
| Category Distribution       | windows phase6.md      | Lines 1-100: Product ranking by category         |
| Alert Status               | validation phase5.md   | Alerts section: 5 alerts shown                   |
| Trigger Status             | audit result.md        | "Trigger functionality test" section             |
| Staff Performance          | windows phase6.md      | Lines 101-240: Staff analysis query              |
| System Validation          | test phase6.md         | Entire validation results                         |
| Holiday Data               | triggers.sql           | Holiday table inserts                            |
| Database Stats             | validation phase5.md   | Table counts and sample data                     |
