-- 1. Holiday Management Table
CREATE TABLE holidays (
    holiday_id NUMBER PRIMARY KEY,
    holiday_name VARCHAR2(100) NOT NULL,
    holiday_date DATE NOT NULL,
    holiday_type VARCHAR2(20) DEFAULT 'PUBLIC',
    is_active CHAR(1) DEFAULT 'Y',
    created_date DATE DEFAULT SYSDATE
);

CREATE SEQUENCE holiday_seq START WITH 1 INCREMENT BY 1;

INSERT INTO holidays (holiday_id, holiday_name, holiday_date) 
VALUES (1, 'Christmas Day', DATE '2025-12-25');

INSERT INTO holidays (holiday_id, holiday_name, holiday_date) 
VALUES (2, 'New Years Day', DATE '2026-01-01');

INSERT INTO holidays (holiday_id, holiday_name, holiday_date) 
VALUES (3, 'Independence Day', DATE '2026-01-04');

COMMIT;

-- 2. Audit Log Table
CREATE TABLE security_audit_log (
    audit_id NUMBER PRIMARY KEY,
    table_name VARCHAR2(50) NOT NULL,
    operation_type VARCHAR2(10) NOT NULL,
    operation_date DATE DEFAULT SYSDATE,
    user_name VARCHAR2(50) DEFAULT USER,
    status VARCHAR2(20) DEFAULT 'ATTEMPTED'
);

CREATE SEQUENCE security_audit_seq START WITH 1 INCREMENT BY 1;

-- 3. Restriction Check Functions
CREATE OR REPLACE FUNCTION check_if_weekday RETURN VARCHAR2 IS
    v_day NUMBER;
BEGIN
    SELECT TO_CHAR(SYSDATE, 'D') INTO v_day FROM dual;
    IF v_day BETWEEN 2 AND 6 THEN -- Monday(2) to Friday(6)
        RETURN 'YES';
    ELSE
        RETURN 'NO';
    END IF;
END;
/

CREATE OR REPLACE FUNCTION check_if_holiday RETURN VARCHAR2 IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM holidays 
    WHERE holiday_date = TRUNC(SYSDATE) AND is_active = 'Y';
    
    IF v_count > 0 THEN
        RETURN 'YES';
    ELSE
        RETURN 'NO';
    END IF;
END;
/

CREATE OR REPLACE FUNCTION check_if_restricted RETURN VARCHAR2 IS
BEGIN
    IF check_if_weekday = 'YES' OR check_if_holiday = 'YES' THEN
        RETURN 'YES';
    ELSE
        RETURN 'NO';
    END IF;
END;
/

-- 4. Simple Triggers (4 triggers)
CREATE OR REPLACE TRIGGER restrict_products_insert
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF check_if_restricted = 'YES' THEN
        INSERT INTO security_audit_log (audit_id, table_name, operation_type, status)
        VALUES (security_audit_seq.NEXTVAL, 'PRODUCTS', 'INSERT', 'DENIED');
        COMMIT;
        RAISE_APPLICATION_ERROR(-20001, 'INSERT on PRODUCTS not allowed on weekdays or holidays');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER restrict_alerts_insert
BEFORE INSERT ON alerts
FOR EACH ROW
BEGIN
    IF check_if_restricted = 'YES' THEN
        INSERT INTO security_audit_log (audit_id, table_name, operation_type, status)
        VALUES (security_audit_seq.NEXTVAL, 'ALERTS', 'INSERT', 'DENIED');
        COMMIT;
        RAISE_APPLICATION_ERROR(-20002, 'INSERT on ALERTS not allowed on weekdays or holidays');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER restrict_sales_insert
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
    IF check_if_restricted = 'YES' THEN
        INSERT INTO security_audit_log (audit_id, table_name, operation_type, status)
        VALUES (security_audit_seq.NEXTVAL, 'SALES', 'INSERT', 'DENIED');
        COMMIT;
        RAISE_APPLICATION_ERROR(-20003, 'INSERT on SALES not allowed on weekdays or holidays');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER restrict_action_log_insert
BEFORE INSERT ON action_log
FOR EACH ROW
BEGIN
    IF check_if_restricted = 'YES' THEN
        INSERT INTO security_audit_log (audit_id, table_name, operation_type, status)
        VALUES (security_audit_seq.NEXTVAL, 'ACTION_LOG', 'INSERT', 'DENIED');
        COMMIT;
        RAISE_APPLICATION_ERROR(-20004, 'INSERT on ACTION_LOG not allowed on weekdays or holidays');
    END IF;
END;
/

-- 5. Compound Trigger (1 trigger)
CREATE OR REPLACE TRIGGER restrict_staff_compound
FOR INSERT OR UPDATE OR DELETE ON staff
COMPOUND TRIGGER

    v_operation VARCHAR2(10);
    
    BEFORE STATEMENT IS
    BEGIN
        -- Determine operation type
        IF INSERTING THEN
            v_operation := 'INSERT';
        ELSIF UPDATING THEN
            v_operation := 'UPDATE';
        ELSE
            v_operation := 'DELETE';
        END IF;
    END BEFORE STATEMENT;
    
    BEFORE EACH ROW IS
    BEGIN
        IF check_if_restricted = 'YES' THEN
            INSERT INTO security_audit_log (audit_id, table_name, operation_type, status)
            VALUES (security_audit_seq.NEXTVAL, 'STAFF', v_operation, 'DENIED');
            COMMIT;
            RAISE_APPLICATION_ERROR(-20005, v_operation || ' on STAFF not allowed on weekdays or holidays');
        END IF;
    END BEFORE EACH ROW;
    
END restrict_staff_compound;
/