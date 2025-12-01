# PHASE II: Business Process Modeling - Documentation

## Project: Expired Goods Auto-Detection & Discount System

### 1. Process Scope & Objectives
**Scope:** Automated monitoring of product expiry dates with tiered alerting system
**MIS Relevance:** Real-time inventory management, automated decision support, financial impact tracking
**Primary Objectives:**
- Reduce expired goods waste by 40%
- Increase revenue recovery from near-expired items by 25%
- Automate discount application for critical items
- Provide actionable BI insights for management

### 2. Key Entities & Roles
- **Automated System:** Daily expiry checks, alert generation, discount application
- **Inventory Staff:** Alert response, product handling, action logging  
- **Management:** Performance monitoring, threshold adjustment, strategic decisions

### 3. Process Flow Description
**Daily Automated Process (6:00 AM):**
1. System checks all product expiry dates
2. Classifies products into three categories:
   - >7 days: No action
   - 4-7 days: Generate MODERATE alert
   - ≤3 days: Generate CRITICAL alert with auto-discount

**Staff Response Workflow:**
- **Moderate Alerts:** Move to promotion area, add signage
- **Critical Alerts:** Verify discount, move to clearance, monitor for 24h
- **Post-Monitoring:** Record sale or remove expired items

**Management Oversight:**
- Weekly review of BI dashboard
- Analysis of KPIs and performance metrics
- Adjustment of alert thresholds as needed

### 4. MIS Functions Explained
- **Decision Support:** Real-time data for inventory decisions
- **Process Automation:** Eliminates manual expiry checking
- **Performance Monitoring:** Tracks staff efficiency
- **Financial Analysis:** Calculates ROI of discount strategies
- **Predictive Analytics:** Forecasts expiry patterns

### 5. Organizational Impact
**Operational Impact:**
- Reduces manual checking by 80%
- Improves accuracy of expiry management
- Standardizes response procedures

**Financial Impact:**
- Recovers 25% of potential waste value
- Optimizes discount strategies
- Reduces compliance risks

**Strategic Impact:**
- Data-driven purchasing decisions
- Improved supplier evaluation
- Enhanced customer safety and trust

### 6. Analytics Opportunities Identified
1. **Expiry Pattern Analysis:** Identify products with frequent expiry issues
2. **Discount Effectiveness:** Measure optimal discount levels by category
3. **Staff Performance:** Track response times and resolution rates
4. **Seasonal Trends:** Identify expiry patterns by season
5. **Supplier Quality:** Correlate expiry rates with suppliers
6. **Financial Impact:** Calculate waste reduction and revenue recovery

### 7. BPMN Elements Used in Diagram
- **Swimlanes:** 3 distinct roles (Automated System, Inventory Staff, Management)
- **Events:** Start/End events, timer events (6:00 AM, weekly)
- **Tasks:** Service tasks, user tasks, send tasks
- **Gateways:** Exclusive decisions with clear branching
- **Flows:** Sequence flows with proper direction
- **Artifacts:** Message flows for notifications

### 8. Key Decision Points
1. **Expiry Check Decision:** Routes to appropriate alert level
2. **Stock Sold Decision:** Determines follow-up action after moderate alert
3. **Action Taken Decision:** Final disposition of critical items
4. **Sold Within 24h Decision:** Staff response evaluation

### 9. Data Flow Highlights
**Input Data:**
- Product master data (expiry dates, categories)
- Current inventory levels
- Staff schedules and assignments

**Processed Data:**
- Days remaining calculations
- Alert level determinations
- Discount percentage calculations

**Output Data:**
- Alert notifications
- Sales records
- Waste logs
- Performance reports
- BI dashboard metrics
