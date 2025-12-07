-- 1. CREATE SEQUENCES (for auto-increment)
CREATE SEQUENCE alerts_seq START WITH 1000 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE action_log_seq START WITH 1000 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE sales_seq START WITH 2000 INCREMENT BY 1 NOCACHE NOCYCLE;

-- 2. PROCEDURES (5 procedures as required)
-- ==========================================

-- PROCEDURE 1: Generate Expiry Alerts
CREATE OR REPLACE PROCEDURE generate_expiry_alerts AS
    v_product_id products.product_id%TYPE;
    v_days_remaining NUMBER;
    v_alert_type alerts.alert_type%TYPE;
    v_alert_status alerts.status%TYPE;
    v_next_alert_id alerts.alert_id%TYPE;
    v_next_log_id action_log.log_id%TYPE;
BEGIN
    FOR prod IN (SELECT product_id, expiry_date FROM products WHERE status IN ('ACTIVE', 'NEAR_EXPIRY')) 
    LOOP
        v_days_remaining := prod.expiry_date - SYSDATE;
        
        -- Determine alert type based on business rules
        IF v_days_remaining <= 2 THEN
            v_alert_type := 'CRITICAL';
            v_alert_status := 'PENDING';
            
            -- Update product status to CRITICAL
            UPDATE products 
            SET status = 'CRITICAL',
                discount_rate = CASE 
                    WHEN v_days_remaining <= 1 THEN 50
                    WHEN v_days_remaining <= 2 THEN 40
                    ELSE discount_rate
                END
            WHERE product_id = prod.product_id;
            
        ELSIF v_days_remaining <= 7 THEN
            v_alert_type := 'MODERATE';
            v_alert_status := 'PENDING';
            
            -- Update product status to NEAR_EXPIRY if not already
            UPDATE products 
            SET status = 'NEAR_EXPIRY',
                discount_rate = CASE 
                    WHEN v_days_remaining <= 3 THEN 30
                    WHEN v_days_remaining <= 7 THEN 20
                    ELSE discount_rate
                END
            WHERE product_id = prod.product_id AND status = 'ACTIVE';
        END IF;
        
        -- Create alert if needed
        IF v_days_remaining <= 7 THEN
            -- Generate next ID (use sequence or manual if sequence fails)
            BEGIN
                SELECT alerts_seq.NEXTVAL INTO v_next_alert_id FROM dual;
            EXCEPTION
                WHEN OTHERS THEN
                    SELECT NVL(MAX(alert_id), 0) + 1 INTO v_next_alert_id FROM alerts;
            END;
            
            INSERT INTO alerts (alert_id, product_id, alert_type, alert_date, status, assigned_to)
            VALUES (v_next_alert_id, prod.product_id, v_alert_type, SYSTIMESTAMP, v_alert_status, NULL);
            
            -- Log the alert generation
            BEGIN
                SELECT action_log_seq.NEXTVAL INTO v_next_log_id FROM dual;
            EXCEPTION
                WHEN OTHERS THEN
                    SELECT NVL(MAX(log_id), 0) + 1 INTO v_next_log_id FROM action_log;
            END;
            
            INSERT INTO action_log (log_id, product_id, staff_id, action_taken, action_date, notes)
            VALUES (v_next_log_id, prod.product_id, NULL, 'ALERT_GENERATED', SYSTIMESTAMP, 
                   'Auto-generated ' || v_alert_type || ' alert for product ' || prod.product_id);
        END IF;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Expiry alerts generated successfully');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error generating alerts: ' || SQLERRM);
END generate_expiry_alerts;
/

-- PROCEDURE 2: Assign Alert to Staff
CREATE OR REPLACE PROCEDURE assign_alert_to_staff(
    p_alert_id IN alerts.alert_id%TYPE,
    p_staff_id IN staff.staff_id%TYPE
) AS
    v_alert_exists NUMBER;
    v_staff_exists NUMBER;
    v_staff_active CHAR(1);
    v_next_log_id action_log.log_id%TYPE;
BEGIN
    -- Check if alert exists
    SELECT COUNT(*) INTO v_alert_exists FROM alerts WHERE alert_id = p_alert_id;
    IF v_alert_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Alert ID ' || p_alert_id || ' does not exist');
    END IF;
    
    -- Check if staff exists and is active
    SELECT COUNT(*), is_active INTO v_staff_exists, v_staff_active 
    FROM staff WHERE staff_id = p_staff_id;
    
    IF v_staff_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Staff ID ' || p_staff_id || ' does not exist');
    END IF;
    
    IF v_staff_active != 'Y' THEN
        RAISE_APPLICATION_ERROR(-20003, 'Staff ID ' || p_staff_id || ' is not active');
    END IF;
    
    -- Assign alert to staff
    UPDATE alerts 
    SET assigned_to = p_staff_id,
        status = 'ASSIGNED'
    WHERE alert_id = p_alert_id;
    
    -- Log the assignment
    BEGIN
        SELECT action_log_seq.NEXTVAL INTO v_next_log_id FROM dual;
    EXCEPTION
        WHEN OTHERS THEN
            SELECT NVL(MAX(log_id), 0) + 1 INTO v_next_log_id FROM action_log;
    END;
    
    INSERT INTO action_log (log_id, product_id, staff_id, action_taken, action_date, notes)
    SELECT v_next_log_id, a.product_id, p_staff_id, 'ALERT_ASSIGNED', SYSTIMESTAMP,
           'Alert ' || p_alert_id || ' assigned to staff ' || p_staff_id
    FROM alerts a WHERE a.alert_id = p_alert_id;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Alert ' || p_alert_id || ' assigned to staff ' || p_staff_id);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error assigning alert: ' || SQLERRM);
END assign_alert_to_staff;
/

-- PROCEDURE 3: Process Product Sale with Discount
CREATE OR REPLACE PROCEDURE process_product_sale(
    p_product_id IN products.product_id%TYPE,
    p_quantity IN sales.quantity%TYPE,
    p_staff_id IN staff.staff_id%TYPE,
    p_payment_method IN sales.payment_method%TYPE DEFAULT 'CASH'
) AS
    v_unit_price products.unit_price%TYPE;
    v_discount_rate products.discount_rate%TYPE;
    v_final_price sales.final_price%TYPE;
    v_stock_qty products.stock_qty%TYPE;
    v_product_status products.status%TYPE;
    v_next_sale_id sales.sale_id%TYPE;
    v_next_log_id action_log.log_id%TYPE;
BEGIN
    -- Get product details
    SELECT unit_price, discount_rate, stock_qty, status 
    INTO v_unit_price, v_discount_rate, v_stock_qty, v_product_status
    FROM products 
    WHERE product_id = p_product_id;
    
    -- Check stock availability
    IF v_stock_qty < p_quantity THEN
        RAISE_APPLICATION_ERROR(-20004, 'Insufficient stock. Available: ' || v_stock_qty || ', Requested: ' || p_quantity);
    END IF;
    
    -- Check if product is expired
    IF v_product_status = 'EXPIRED' THEN
        RAISE_APPLICATION_ERROR(-20005, 'Cannot sell expired product');
    END IF;
    
    -- Calculate final price with discount
    v_final_price := ROUND(p_quantity * v_unit_price * (1 - v_discount_rate/100), 2);
    
    -- Insert sale record
    BEGIN
        SELECT sales_seq.NEXTVAL INTO v_next_sale_id FROM dual;
    EXCEPTION
        WHEN OTHERS THEN
            SELECT NVL(MAX(sale_id), 0) + 1 INTO v_next_sale_id FROM sales;
    END;
    
    INSERT INTO sales (sale_id, product_id, quantity, sale_date, discount_applied, unit_price, final_price, staff_id, payment_method)
    VALUES (v_next_sale_id, p_product_id, p_quantity, SYSTIMESTAMP, v_discount_rate, v_unit_price, v_final_price, p_staff_id, p_payment_method);
    
    -- Update product stock
    UPDATE products 
    SET stock_qty = stock_qty - p_quantity
    WHERE product_id = p_product_id;
    
    -- Log the sale action
    BEGIN
        SELECT action_log_seq.NEXTVAL INTO v_next_log_id FROM dual;
    EXCEPTION
        WHEN OTHERS THEN
            SELECT NVL(MAX(log_id), 0) + 1 INTO v_next_log_id FROM action_log;
    END;
    
    INSERT INTO action_log (log_id, product_id, staff_id, action_taken, action_date, notes)
    VALUES (v_next_log_id, p_product_id, p_staff_id, 'SALE_PROCESSED', SYSTIMESTAMP,
           'Sold ' || p_quantity || ' units with ' || v_discount_rate || '% discount. Total: ' || v_final_price);
    
    -- If stock becomes zero after sale, update any pending alerts
    IF v_stock_qty - p_quantity = 0 THEN
        UPDATE alerts 
        SET status = 'RESOLVED'
        WHERE product_id = p_product_id AND status IN ('PENDING', 'ASSIGNED');
    END IF;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Sale processed successfully. Final price: ' || v_final_price);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20006, 'Product ID ' || p_product_id || ' not found');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error processing sale: ' || SQLERRM);
END process_product_sale;
/

-- PROCEDURE 4: Update Product Status Batch
CREATE OR REPLACE PROCEDURE update_product_status_batch AS
    v_updated_count NUMBER := 0;
    v_expired_count NUMBER := 0;
BEGIN
    -- Update products to EXPIRED status
    UPDATE products 
    SET status = 'EXPIRED',
        discount_rate = 0
    WHERE expiry_date < SYSDATE AND status != 'EXPIRED';
    
    v_expired_count := SQL%ROWCOUNT;
    
    -- Update products to CRITICAL status (1-2 days remaining)
    UPDATE products 
    SET status = 'CRITICAL',
        discount_rate = CASE 
            WHEN expiry_date - SYSDATE <= 1 THEN 50
            WHEN expiry_date - SYSDATE <= 2 THEN 40
            ELSE discount_rate
        END
    WHERE expiry_date BETWEEN SYSDATE AND SYSDATE + 2 
        AND status NOT IN ('CRITICAL', 'EXPIRED');
    
    v_updated_count := v_updated_count + SQL%ROWCOUNT;
    
    -- Update products to NEAR_EXPIRY status (3-7 days remaining)
    UPDATE products 
    SET status = 'NEAR_EXPIRY',
        discount_rate = CASE 
            WHEN expiry_date - SYSDATE <= 3 THEN 30
            WHEN expiry_date - SYSDATE <= 7 THEN 20
            WHEN expiry_date - SYSDATE <= 14 THEN 10
            ELSE discount_rate
        END
    WHERE expiry_date BETWEEN SYSDATE + 3 AND SYSDATE + 7 
        AND status NOT IN ('NEAR_EXPIRY', 'CRITICAL', 'EXPIRED');
    
    v_updated_count := v_updated_count + SQL%ROWCOUNT;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Batch update completed: ' || v_expired_count || ' products marked as EXPIRED, ' || 
                         v_updated_count || ' products status updated');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error in batch update: ' || SQLERRM);
END update_product_status_batch;
/

-- PROCEDURE 5: Resolve Alert and Log Action
CREATE OR REPLACE PROCEDURE resolve_alert(
    p_alert_id IN alerts.alert_id%TYPE,
    p_staff_id IN staff.staff_id%TYPE,
    p_resolution_action IN action_log.action_taken%TYPE,
    p_notes IN action_log.notes%TYPE DEFAULT NULL
) AS
    v_product_id alerts.product_id%TYPE;
    v_current_status alerts.status%TYPE;
    v_next_log_id action_log.log_id%TYPE;
BEGIN
    -- Get alert details
    SELECT product_id, status INTO v_product_id, v_current_status
    FROM alerts WHERE alert_id = p_alert_id;
    
    IF v_current_status = 'RESOLVED' THEN
        DBMS_OUTPUT.PUT_LINE('Alert ' || p_alert_id || ' is already resolved');
        RETURN;
    END IF;
    
    -- Update alert status
    UPDATE alerts 
    SET status = 'RESOLVED'
    WHERE alert_id = p_alert_id;
    
    -- Log the resolution action
    BEGIN
        SELECT action_log_seq.NEXTVAL INTO v_next_log_id FROM dual;
    EXCEPTION
        WHEN OTHERS THEN
            SELECT NVL(MAX(log_id), 0) + 1 INTO v_next_log_id FROM action_log;
    END;
    
    INSERT INTO action_log (log_id, product_id, staff_id, action_taken, action_date, notes)
    VALUES (v_next_log_id, v_product_id, p_staff_id, p_resolution_action, SYSTIMESTAMP,
           COALESCE(p_notes, 'Alert ' || p_alert_id || ' resolved by staff ' || p_staff_id));
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Alert ' || p_alert_id || ' resolved successfully');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20007, 'Alert ID ' || p_alert_id || ' not found');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error resolving alert: ' || SQLERRM);
END resolve_alert;
/

-- 3. FUNCTIONS (5 functions as required)
-- =======================================

-- FUNCTION 1: Calculate Days Until Expiry
CREATE OR REPLACE FUNCTION calculate_days_until_expiry(
    p_product_id IN products.product_id%TYPE
) RETURN NUMBER AS
    v_expiry_date products.expiry_date%TYPE;
    v_days_remaining NUMBER;
BEGIN
    SELECT expiry_date INTO v_expiry_date
    FROM products 
    WHERE product_id = p_product_id;
    
    v_days_remaining := v_expiry_date - SYSDATE;
    
    RETURN v_days_remaining;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN NULL;
END calculate_days_until_expiry;
/

-- FUNCTION 2: Get Recommended Discount Rate
CREATE OR REPLACE FUNCTION get_recommended_discount(
    p_product_id IN products.product_id%TYPE
) RETURN NUMBER AS
    v_days_remaining NUMBER;
    v_recommended_discount NUMBER;
BEGIN
    v_days_remaining := calculate_days_until_expiry(p_product_id);
    
    IF v_days_remaining IS NULL THEN
        RETURN 0;
    END IF;
    
    -- Business rule: Tiered discount based on days remaining
    v_recommended_discount := CASE 
        WHEN v_days_remaining <= 0 THEN 0  -- Expired, no discount
        WHEN v_days_remaining <= 1 THEN 50
        WHEN v_days_remaining <= 2 THEN 40
        WHEN v_days_remaining <= 3 THEN 30
        WHEN v_days_remaining <= 7 THEN 20
        WHEN v_days_remaining <= 14 THEN 10
        ELSE 0
    END;
    
    RETURN v_recommended_discount;
END get_recommended_discount;
/

-- FUNCTION 3: Check Product Alert Status
CREATE OR REPLACE FUNCTION check_product_alert_status(
    p_product_id IN products.product_id%TYPE
) RETURN VARCHAR2 AS
    v_days_remaining NUMBER;
    v_alert_status VARCHAR2(20);
BEGIN
    v_days_remaining := calculate_days_until_expiry(p_product_id);
    
    IF v_days_remaining IS NULL THEN
        RETURN 'PRODUCT_NOT_FOUND';
    END IF;
    
    IF v_days_remaining <= 0 THEN
        v_alert_status := 'EXPIRED';
    ELSIF v_days_remaining <= 2 THEN
        v_alert_status := 'CRITICAL';
    ELSIF v_days_remaining <= 7 THEN
        v_alert_status := 'NEAR_EXPIRY';
    ELSE
        v_alert_status := 'ACTIVE';
    END IF;
    
    RETURN v_alert_status;
END check_product_alert_status;
/

-- FUNCTION 4: Calculate Total Discount Value
CREATE OR REPLACE FUNCTION calculate_total_discount_value(
    p_category IN products.category%TYPE DEFAULT NULL,
    p_start_date IN DATE DEFAULT SYSDATE - 30,
    p_end_date IN DATE DEFAULT SYSDATE
) RETURN NUMBER AS
    v_total_discount NUMBER := 0;
BEGIN
    IF p_category IS NULL THEN
        -- Calculate for all categories
        SELECT SUM((s.unit_price * s.quantity) - s.final_price)
        INTO v_total_discount
        FROM sales s
        JOIN products p ON s.product_id = p.product_id
        WHERE s.sale_date BETWEEN p_start_date AND p_end_date
          AND s.discount_applied > 0;
    ELSE
        -- Calculate for specific category
        SELECT SUM((s.unit_price * s.quantity) - s.final_price)
        INTO v_total_discount
        FROM sales s
        JOIN products p ON s.product_id = p.product_id
        WHERE p.category = p_category
          AND s.sale_date BETWEEN p_start_date AND p_end_date
          AND s.discount_applied > 0;
    END IF;
    
    RETURN NVL(v_total_discount, 0);
END calculate_total_discount_value;
/

-- FUNCTION 5: Validate Staff for Action
CREATE OR REPLACE FUNCTION validate_staff_for_action(
    p_staff_id IN staff.staff_id%TYPE,
    p_required_role IN staff.role%TYPE DEFAULT NULL
) RETURN BOOLEAN AS
    v_is_active staff.is_active%TYPE;
    v_role staff.role%TYPE;
    v_exists NUMBER;
BEGIN
    -- Check if staff exists
    SELECT COUNT(*) INTO v_exists
    FROM staff 
    WHERE staff_id = p_staff_id;
    
    IF v_exists = 0 THEN
        RETURN FALSE;
    END IF;
    
    -- Get staff details
    SELECT is_active, role INTO v_is_active, v_role
    FROM staff 
    WHERE staff_id = p_staff_id;
    
    -- Check if staff is active
    IF v_is_active != 'Y' THEN
        RETURN FALSE;
    END IF;
    
    -- Check role if required
    IF p_required_role IS NOT NULL AND v_role != p_required_role THEN
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END validate_staff_for_action;
/

-- 4. PACKAGE (Complete package)
-- ==============================

-- PACKAGE SPECIFICATION
CREATE OR REPLACE PACKAGE expiry_management_pkg AS
    -- Procedure declarations
    PROCEDURE generate_daily_alerts;
    PROCEDURE assign_staff_to_alert(p_alert_id IN NUMBER, p_staff_id IN NUMBER);
    PROCEDURE process_sale(p_product_id IN NUMBER, p_quantity IN NUMBER, p_staff_id IN NUMBER);
    PROCEDURE update_all_product_statuses;
    PROCEDURE log_action(p_product_id IN NUMBER, p_staff_id IN NUMBER, p_action IN VARCHAR2, p_notes IN VARCHAR2 DEFAULT NULL);
    
    -- Function declarations
    FUNCTION get_product_status(p_product_id IN NUMBER) RETURN VARCHAR2;
    FUNCTION calculate_discount(p_product_id IN NUMBER) RETURN NUMBER;
    FUNCTION get_total_expiring_count(p_days_threshold IN NUMBER DEFAULT 7) RETURN NUMBER;
    FUNCTION get_staff_performance(p_staff_id IN NUMBER, p_days_back IN NUMBER DEFAULT 30) RETURN NUMBER;
    FUNCTION is_product_expired(p_product_id IN NUMBER) RETURN BOOLEAN;
    
    -- Define a REF CURSOR type
    TYPE expiring_products_refcur IS REF CURSOR;
    
    -- Procedure to get expiring products using REF CURSOR
    PROCEDURE get_expiring_products(
        p_days_threshold IN NUMBER DEFAULT 7,
        p_results OUT expiring_products_refcur
    );
    
    -- Exceptions
    product_not_found EXCEPTION;
    insufficient_stock EXCEPTION;
    staff_inactive EXCEPTION;
    PRAGMA EXCEPTION_INIT(product_not_found, -20001);
    PRAGMA EXCEPTION_INIT(insufficient_stock, -20002);
    PRAGMA EXCEPTION_INIT(staff_inactive, -20003);
    
END expiry_management_pkg;
/

-- PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY expiry_management_pkg AS
    
    -- PROCEDURE 1: Generate Daily Alerts
    PROCEDURE generate_daily_alerts IS
        CURSOR expiring_products IS
            SELECT product_id, product_name, category, expiry_date
            FROM products
            WHERE expiry_date BETWEEN SYSDATE AND SYSDATE + 7
              AND status IN ('ACTIVE', 'NEAR_EXPIRY');
        
        v_alert_type alerts.alert_type%TYPE;
        v_existing_alerts NUMBER;
        v_next_alert_id alerts.alert_id%TYPE;
    BEGIN
        FOR prod IN expiring_products LOOP
            -- Check for existing pending alerts
            SELECT COUNT(*) INTO v_existing_alerts
            FROM alerts
            WHERE product_id = prod.product_id 
              AND status IN ('PENDING', 'ASSIGNED')
              AND alert_date >= SYSDATE - 1;
            
            IF v_existing_alerts = 0 THEN
                -- Determine alert type based on days remaining
                IF prod.expiry_date - SYSDATE <= 2 THEN
                    v_alert_type := 'CRITICAL';
                ELSE
                    v_alert_type := 'MODERATE';
                END IF;
                
                -- Get next alert ID
                BEGIN
                    SELECT alerts_seq.NEXTVAL INTO v_next_alert_id FROM dual;
                EXCEPTION
                    WHEN OTHERS THEN
                        SELECT NVL(MAX(alert_id), 0) + 1 INTO v_next_alert_id FROM alerts;
                END;
                
                -- Create alert
                INSERT INTO alerts (alert_id, product_id, alert_type, alert_date, status, assigned_to)
                VALUES (v_next_alert_id, prod.product_id, v_alert_type, SYSTIMESTAMP, 'PENDING', NULL);
                
                -- Update product discount if critical
                IF v_alert_type = 'CRITICAL' THEN
                    UPDATE products 
                    SET discount_rate = get_recommended_discount(prod.product_id)
                    WHERE product_id = prod.product_id;
                END IF;
                
                -- Log the action
                log_action(prod.product_id, NULL, 'ALERT_GENERATED', 
                          'Auto-generated ' || v_alert_type || ' alert for ' || prod.product_name);
            END IF;
        END LOOP;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Daily alerts generation completed');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error generating daily alerts: ' || SQLERRM);
    END generate_daily_alerts;
    
    -- PROCEDURE 2: Assign Staff to Alert
    PROCEDURE assign_staff_to_alert(p_alert_id IN NUMBER, p_staff_id IN NUMBER) IS
        v_staff_active staff.is_active%TYPE;
        v_alert_status alerts.status%TYPE;
        v_product_id alerts.product_id%TYPE;
    BEGIN
        -- Validate staff
        SELECT is_active INTO v_staff_active
        FROM staff WHERE staff_id = p_staff_id;
        
        IF v_staff_active != 'Y' THEN
            RAISE staff_inactive;
        END IF;
        
        -- Get alert details
        SELECT status, product_id INTO v_alert_status, v_product_id
        FROM alerts WHERE alert_id = p_alert_id;
        
        IF v_alert_status = 'RESOLVED' THEN
            DBMS_OUTPUT.PUT_LINE('Cannot assign resolved alert');
            RETURN;
        END IF;
        
        -- Assign staff
        UPDATE alerts 
        SET assigned_to = p_staff_id,
            status = 'ASSIGNED'
        WHERE alert_id = p_alert_id;
        
        -- Log assignment
        log_action(v_product_id, p_staff_id, 'ALERT_ASSIGNED', 
                  'Alert ' || p_alert_id || ' assigned to staff ' || p_staff_id);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Alert assigned successfully');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE product_not_found;
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error assigning alert: ' || SQLERRM);
    END assign_staff_to_alert;
    
    -- PROCEDURE 3: Process Sale
    PROCEDURE process_sale(p_product_id IN NUMBER, p_quantity IN NUMBER, p_staff_id IN NUMBER) IS
        v_stock products.stock_qty%TYPE;
        v_price products.unit_price%TYPE;
        v_discount products.discount_rate%TYPE;
        v_final_price sales.final_price%TYPE;
        v_next_sale_id sales.sale_id%TYPE;
    BEGIN
        -- Get product details
        SELECT stock_qty, unit_price, discount_rate 
        INTO v_stock, v_price, v_discount
        FROM products 
        WHERE product_id = p_product_id;
        
        -- Check stock
        IF v_stock < p_quantity THEN
            RAISE insufficient_stock;
        END IF;
        
        -- Calculate final price
        v_final_price := ROUND(p_quantity * v_price * (1 - v_discount/100), 2);
        
        -- Get next sale ID
        BEGIN
            SELECT sales_seq.NEXTVAL INTO v_next_sale_id FROM dual;
        EXCEPTION
            WHEN OTHERS THEN
                SELECT NVL(MAX(sale_id), 0) + 1 INTO v_next_sale_id FROM sales;
        END;
        
        -- Create sale record
        INSERT INTO sales (sale_id, product_id, quantity, sale_date, discount_applied, unit_price, final_price, staff_id, payment_method)
        VALUES (v_next_sale_id, p_product_id, p_quantity, SYSTIMESTAMP, v_discount, v_price, v_final_price, p_staff_id, 'CASH');
        
        -- Update stock
        UPDATE products 
        SET stock_qty = stock_qty - p_quantity
        WHERE product_id = p_product_id;
        
        -- Log sale
        log_action(p_product_id, p_staff_id, 'SALE_PROCESSED', 
                  'Sold ' || p_quantity || ' units for ' || v_final_price || ' with ' || v_discount || '% discount');
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Sale processed: ' || v_final_price);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE product_not_found;
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error processing sale: ' || SQLERRM);
    END process_sale;
    
    -- PROCEDURE 4: Update All Product Statuses
    PROCEDURE update_all_product_statuses IS
        v_count NUMBER := 0;
    BEGIN
        -- Mark expired products
        UPDATE products 
        SET status = 'EXPIRED',
            discount_rate = 0
        WHERE expiry_date < SYSDATE 
          AND status != 'EXPIRED';
        v_count := v_count + SQL%ROWCOUNT;
        
        -- Update critical products
        UPDATE products 
        SET status = 'CRITICAL'
        WHERE expiry_date BETWEEN SYSDATE AND SYSDATE + 2
          AND status != 'CRITICAL'
          AND status != 'EXPIRED';
        v_count := v_count + SQL%ROWCOUNT;
        
        -- Update near expiry products
        UPDATE products 
        SET status = 'NEAR_EXPIRY'
        WHERE expiry_date BETWEEN SYSDATE + 3 AND SYSDATE + 7
          AND status NOT IN ('NEAR_EXPIRY', 'CRITICAL', 'EXPIRED');
        v_count := v_count + SQL%ROWCOUNT;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Updated status for ' || v_count || ' products');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error updating statuses: ' || SQLERRM);
    END update_all_product_statuses;
    
    -- PROCEDURE 5: Log Action
    PROCEDURE log_action(p_product_id IN NUMBER, p_staff_id IN NUMBER, p_action IN VARCHAR2, p_notes IN VARCHAR2 DEFAULT NULL) IS
        v_next_log_id action_log.log_id%TYPE;
    BEGIN
        -- Get next log ID
        BEGIN
            SELECT action_log_seq.NEXTVAL INTO v_next_log_id FROM dual;
        EXCEPTION
            WHEN OTHERS THEN
                SELECT NVL(MAX(log_id), 0) + 1 INTO v_next_log_id FROM action_log;
        END;
        
        INSERT INTO action_log (log_id, product_id, staff_id, action_taken, action_date, notes)
        VALUES (v_next_log_id, p_product_id, p_staff_id, p_action, SYSTIMESTAMP, p_notes);
    END log_action;
    
    -- FUNCTION 1: Get Product Status
    FUNCTION get_product_status(p_product_id IN NUMBER) RETURN VARCHAR2 IS
        v_status products.status%TYPE;
    BEGIN
        SELECT status INTO v_status
        FROM products 
        WHERE product_id = p_product_id;
        
        RETURN v_status;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'NOT_FOUND';
        WHEN OTHERS THEN
            RETURN 'ERROR';
    END get_product_status;
    
    -- FUNCTION 2: Calculate Discount
    FUNCTION calculate_discount(p_product_id IN NUMBER) RETURN NUMBER IS
        v_days NUMBER;
    BEGIN
        v_days := calculate_days_until_expiry(p_product_id);
        
        RETURN CASE 
            WHEN v_days <= 1 THEN 50
            WHEN v_days <= 2 THEN 40
            WHEN v_days <= 3 THEN 30
            WHEN v_days <= 7 THEN 20
            WHEN v_days <= 14 THEN 10
            ELSE 0
        END;
    END calculate_discount;
    
    -- FUNCTION 3: Get Total Expiring Count
    FUNCTION get_total_expiring_count(p_days_threshold IN NUMBER DEFAULT 7) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM products
        WHERE expiry_date BETWEEN SYSDATE AND SYSDATE + p_days_threshold
          AND status != 'EXPIRED';
        
        RETURN v_count;
    END get_total_expiring_count;
    
    -- FUNCTION 4: Get Staff Performance
    FUNCTION get_staff_performance(p_staff_id IN NUMBER, p_days_back IN NUMBER DEFAULT 30) RETURN NUMBER IS
        v_performance NUMBER;
    BEGIN
        SELECT COUNT(DISTINCT a.alert_id) INTO v_performance
        FROM alerts a
        JOIN action_log al ON a.product_id = al.product_id
        WHERE a.assigned_to = p_staff_id
          AND a.status = 'RESOLVED'
          AND al.action_taken LIKE '%RESOLVED%'
          AND al.action_date >= SYSDATE - p_days_back;
        
        RETURN NVL(v_performance, 0);
    END get_staff_performance;
    
    -- FUNCTION 5: Check if Product is Expired
    FUNCTION is_product_expired(p_product_id IN NUMBER) RETURN BOOLEAN IS
        v_expiry_date products.expiry_date%TYPE;
    BEGIN
        SELECT expiry_date INTO v_expiry_date
        FROM products 
        WHERE product_id = p_product_id;
        
        RETURN v_expiry_date < SYSDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN TRUE;
        WHEN OTHERS THEN
            RETURN TRUE;
    END is_product_expired;
    
    -- PROCEDURE: Get Expiring Products using REF CURSOR
    PROCEDURE get_expiring_products(
        p_days_threshold IN NUMBER DEFAULT 7,
        p_results OUT expiring_products_refcur
    ) IS
    BEGIN
        OPEN p_results FOR
            SELECT 
                p.product_id,
                p.product_name,
                p.category,
                p.expiry_date,
                p.expiry_date - SYSDATE as days_remaining,
                calculate_discount(p.product_id) as recommended_discount
            FROM products p
            WHERE p.expiry_date BETWEEN SYSDATE AND SYSDATE + p_days_threshold
              AND p.status != 'EXPIRED'
            ORDER BY p.expiry_date;
    END get_expiring_products;
    
END expiry_management_pkg;
/

-- 5. CURSOR EXAMPLES
-- ===================

-- CURSOR EXAMPLE 1: Explicit Cursor for Processing
DECLARE
    CURSOR expiring_products_cursor IS
        SELECT p.product_id, p.product_name, p.expiry_date, p.stock_qty,
               p.expiry_date - SYSDATE as days_remaining
        FROM products p
        WHERE p.expiry_date BETWEEN SYSDATE AND SYSDATE + 7
          AND p.status IN ('ACTIVE', 'NEAR_EXPIRY')
        ORDER BY p.expiry_date;
    
    v_product_record expiring_products_cursor%ROWTYPE;
    v_alert_count NUMBER := 0;
    v_next_alert_id alerts.alert_id%TYPE;
BEGIN
    OPEN expiring_products_cursor;
    
    DBMS_OUTPUT.PUT_LINE('Processing expiring products...');
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
    
    LOOP
        FETCH expiring_products_cursor INTO v_product_record;
        EXIT WHEN expiring_products_cursor%NOTFOUND;
        
        -- Process each product
        DBMS_OUTPUT.PUT_LINE('Product: ' || v_product_record.product_name || 
                            ' | Days remaining: ' || TRUNC(v_product_record.days_remaining) ||
                            ' | Stock: ' || v_product_record.stock_qty);
        
        -- Create alert for critical items
        IF v_product_record.days_remaining <= 2 THEN
            -- Get next alert ID
            BEGIN
                SELECT alerts_seq.NEXTVAL INTO v_next_alert_id FROM dual;
            EXCEPTION
                WHEN OTHERS THEN
                    SELECT NVL(MAX(alert_id), 0) + 1 INTO v_next_alert_id FROM alerts;
            END;
            
            INSERT INTO alerts (alert_id, product_id, alert_type, alert_date, status, assigned_to)
            VALUES (v_next_alert_id, v_product_record.product_id, 'CRITICAL', SYSTIMESTAMP, 'PENDING', NULL);
            v_alert_count := v_alert_count + 1;
        END IF;
    END LOOP;
    
    CLOSE expiring_products_cursor;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total products processed: ' || expiring_products_cursor%ROWCOUNT);
    DBMS_OUTPUT.PUT_LINE('Critical alerts created: ' || v_alert_count);
EXCEPTION
    WHEN OTHERS THEN
        IF expiring_products_cursor%ISOPEN THEN
            CLOSE expiring_products_cursor;
        END IF;
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- 6. WINDOW FUNCTION QUERIES
-- ===========================

-- WINDOW FUNCTION 1: Product Expiry Ranking
SELECT 
    product_id,
    product_name,
    category,
    expiry_date,
    expiry_date - SYSDATE as days_remaining,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY expiry_date) as expiry_rank_in_category,
    RANK() OVER (ORDER BY expiry_date) as overall_expiry_rank,
    DENSE_RANK() OVER (ORDER BY expiry_date) as dense_expiry_rank,
    LAG(product_name) OVER (ORDER BY expiry_date) as previous_expiring_product,
    LEAD(product_name) OVER (ORDER BY expiry_date) as next_expiring_product,
    COUNT(*) OVER (PARTITION BY category) as total_in_category,
    AVG(expiry_date - SYSDATE) OVER (PARTITION BY category) as avg_days_remaining_in_category
FROM products
WHERE status != 'EXPIRED'
ORDER BY expiry_date;

-- WINDOW FUNCTION 2: Staff Performance Analysis
SELECT 
    s.staff_id,
    s.name,
    s.department,
    COUNT(DISTINCT a.alert_id) as total_alerts_assigned,
    SUM(CASE WHEN a.status = 'RESOLVED' THEN 1 ELSE 0 END) as resolved_alerts,
    ROUND(SUM(CASE WHEN a.status = 'RESOLVED' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(DISTINCT a.alert_id), 0), 2) as resolution_rate,
    RANK() OVER (ORDER BY SUM(CASE WHEN a.status = 'RESOLVED' THEN 1 ELSE 0 END) DESC) as performance_rank,
    DENSE_RANK() OVER (PARTITION BY s.department ORDER BY SUM(CASE WHEN a.status = 'RESOLVED' THEN 1 ELSE 0 END) DESC) as dept_performance_rank,
    LAG(s.name) OVER (ORDER BY SUM(CASE WHEN a.status = 'RESOLVED' THEN 1 ELSE 0 END) DESC) as better_performing_staff,
    LEAD(s.name) OVER (ORDER BY SUM(CASE WHEN a.status = 'RESOLVED' THEN 1 ELSE 0 END) DESC) as worse_performing_staff
FROM staff s
LEFT JOIN alerts a ON s.staff_id = a.assigned_to
WHERE s.is_active = 'Y'
GROUP BY s.staff_id, s.name, s.department
ORDER BY resolved_alerts DESC;

-- WINDOW FUNCTION 3: Sales Analysis with Moving Averages
SELECT 
    product_id,
    TO_CHAR(sale_date, 'YYYY-MM-DD') as sale_day,
    SUM(quantity) as daily_quantity,
    SUM(final_price) as daily_revenue,
    AVG(SUM(final_price)) OVER (
        ORDER BY TO_CHAR(sale_date, 'YYYY-MM-DD')
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as seven_day_avg_revenue,
    SUM(SUM(final_price)) OVER (
        ORDER BY TO_CHAR(sale_date, 'YYYY-MM-DD')
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) as cumulative_revenue,
    ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY SUM(final_price) DESC) as revenue_rank_per_product
FROM sales
WHERE sale_date >= SYSDATE - 90
GROUP BY product_id, TO_CHAR(sale_date, 'YYYY-MM-DD')
ORDER BY sale_day, product_id;