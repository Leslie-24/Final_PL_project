# System Architecture

## Database Architecture
┌─────────────────────────────────────────────────────────┐
│ PLUGGABLE DATABASE: THUR_27413_Leslie_ExpiredGoodsDB     │
├─────────────────────────────────────────────────────────┤
│ TABLESPACES:                                             │
│ • expiry_data (100MB) - User data                        │
│ • expiry_idx (50MB) - Index storage                      │
│ • expiry_temp (100MB) - Temporary operations             │
├─────────────────────────────────────────────────────────┤
│ ADMIN USER: expiry_admin                                 │
│ PRIVILEGES: CREATE SESSION, TABLE, PROCEDURE, etc.       │
└─────────────────────────────────────────────────────────┘

text


## Table Relationships
products ────┬──── alerts
│            │
│            └──── staff
│
sales ───────┘
│
└────── action_log ───── staff

text


## PL/SQL Architecture
SEQUENCES (5):
• alerts_seq, action_log_seq, sales_seq
• holiday_seq, security_audit_seq

PROCEDURES (5):
• generate_expiry_alerts
• assign_alert_to_staff
• process_product_sale
• update_product_status_batch
• resolve_alert

FUNCTIONS (5):
• calculate_days_until_expiry
• get_recommended_discount
• check_product_alert_status
• calculate_total_discount_value
• validate_staff_for_action

PACKAGE (1):
• expiry_management_pkg (specification + body)

TRIGGERS (5):
• restrict_products_insert
• restrict_alerts_insert
• restrict_sales_insert
• restrict_action_log_insert
• restrict_staff_compound (compound trigger)

text


## Data Flow

1. **Daily Batch Process:**  
update_product_status_batch() → generate_expiry_alerts() → alerts table

text

2. **Real-time Operations:**  
process_product_sale() → sales table → update stock → check alerts  
assign_alert_to_staff() → update alert status → log action  
resolve_alert() → update status → log resolution

text

3. **Security Layer:**  
DML Operation → Trigger Check → security_audit_log  
Weekday/Holiday → Block Operation → Log Denial

text


## Index Architecture

PRIMARY INDEXES (5):
• products(product_id)
• staff(staff_id)
• alerts(alert_id)
• action_log(log_id)
• sales(sale_id)

PERFORMANCE INDEXES (6):
• idx_products_expiry (expiry_date)
• idx_products_category (category)
• idx_staff_dept (department)
• idx_alerts_status (status)
• idx_sales_date (sale_date)
• idx_log_date (action_date)

text


## Validation Architecture

PHASE V: Table Implementation ✓  
• 100 products, 150 staff, 200 alerts, 300 logs, 500 sales

PHASE VI: PL/SQL Development ✓  
• All 16 components validated  
• Window functions operational

PHASE VII: Triggers & Auditing ✓  
• 5 triggers active  
• Audit log capturing  
• Holiday system working
