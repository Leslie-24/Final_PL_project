-- 1. Verify all objects were created
SELECT 'OBJECT VERIFICATION' as query_type FROM dual
UNION ALL
SELECT '==================' FROM dual
UNION ALL
SELECT 'Tables:' FROM dual
UNION ALL
SELECT '  - ' || table_name FROM user_tables WHERE table_name IN ('HOLIDAYS', 'SECURITY_AUDIT_LOG')
UNION ALL
SELECT '' FROM dual
UNION ALL
SELECT 'Sequences:' FROM dual
UNION ALL
SELECT '  - ' || sequence_name FROM user_sequences WHERE sequence_name IN ('HOLIDAY_SEQ', 'SECURITY_AUDIT_SEQ')
UNION ALL
SELECT '' FROM dual
UNION ALL
SELECT 'Functions:' FROM dual
UNION ALL
SELECT '  - ' || object_name FROM user_objects 
WHERE object_type = 'FUNCTION' AND object_name LIKE 'CHECK_IF_%'
UNION ALL
SELECT '' FROM dual
UNION ALL
SELECT 'Triggers:' FROM dual
UNION ALL
SELECT '  - ' || trigger_name FROM user_triggers WHERE trigger_name LIKE 'RESTRICT_%';

-- 2. Check holiday data
SELECT 'HOLIDAY DATA' as query_type FROM dual
UNION ALL
SELECT '============' FROM dual
UNION ALL
SELECT 'ID  Holiday Name          Date         Active' FROM dual
UNION ALL
SELECT '--- -------------------- ------------ ------' FROM dual;

SELECT 
    RPAD(holiday_id, 3) || ' ' ||
    RPAD(holiday_name, 20) || ' ' ||
    TO_CHAR(holiday_date, 'DD-MON-YYYY') || ' ' ||
    is_active as holiday_info
FROM holidays
ORDER BY holiday_date;

-- 3. Check audit log entries
SELECT 'AUDIT LOG SUMMARY' as query_type FROM dual
UNION ALL
SELECT '=================' FROM dual
UNION ALL
SELECT 'Total entries: ' || COUNT(*) FROM security_audit_log
UNION ALL
SELECT 'Denied operations: ' || SUM(CASE WHEN status = 'DENIED' THEN 1 ELSE 0 END) FROM security_audit_log
UNION ALL
SELECT 'Successful operations: ' || SUM(CASE WHEN status = 'SUCCESS' THEN 1 ELSE 0 END) FROM security_audit_log
UNION ALL
SELECT '' FROM dual
UNION ALL
SELECT 'Recent audit entries (last 10):' FROM dual
UNION ALL
SELECT '-------------------------------' FROM dual
UNION ALL
SELECT 'Time     Table        Operation  User            Status' FROM dual
UNION ALL
SELECT '-------- ------------ --------- --------------- --------' FROM dual;

SELECT 
    TO_CHAR(operation_date, 'HH24:MI:SS') || ' ' ||
    RPAD(table_name, 12) || ' ' ||
    RPAD(operation_type, 9) || ' ' ||
    RPAD(user_name, 15) || ' ' ||
    status as audit_entry
FROM (
    SELECT * FROM security_audit_log 
    ORDER BY operation_date DESC
)
WHERE ROWNUM <= 10;

-- 4. Check trigger status
SELECT 'TRIGGER STATUS' as query_type FROM dual
UNION ALL
SELECT '==============' FROM dual
UNION ALL
SELECT 'Trigger Name                  Table        Type           Status' FROM dual
UNION ALL
SELECT '----------------------------  -----------  -------------  --------' FROM dual;

SELECT 
    RPAD(trigger_name, 28) || ' ' ||
    RPAD(table_name, 11) || ' ' ||
    RPAD(trigger_type, 13) || ' ' ||
    status as trigger_status
FROM user_triggers
WHERE trigger_name LIKE 'RESTRICT_%'
ORDER BY table_name;

-- 5. Test restriction functions
SELECT 'RESTRICTION CHECK' as query_type FROM dual
UNION ALL
SELECT '=================' FROM dual;

SELECT 
    'Current Date: ' || TO_CHAR(SYSDATE, 'Day, DD-MON-YYYY') as info FROM dual
UNION ALL
SELECT 'Is Weekday: ' || check_if_weekday FROM dual
UNION ALL
SELECT 'Is Holiday: ' || check_if_holiday FROM dual
UNION ALL
SELECT 'Is Restricted: ' || check_if_restricted FROM dual;

-- 6. Quick test of the system
SELECT 'SYSTEM TEST' as query_type FROM dual
UNION ALL
SELECT '===========' FROM dual;

DECLARE
    v_result VARCHAR2(100);
BEGIN
    IF check_if_restricted = 'YES' THEN
        v_result := 'Today is restricted (weekday/holiday) - DML operations should be blocked';
    ELSE
        v_result := 'Today is not restricted (weekend/non-holiday) - DML operations should be allowed';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_result);
    
    -- Try a test insert
    BEGIN
        INSERT INTO products (product_id, product_name, category, purchase_date, expiry_date, unit_price)
        VALUES (99999, 'Audit Test Product', 'Test', SYSDATE, SYSDATE + 30, 19.99);
        
        DBMS_OUTPUT.PUT_LINE('Test INSERT: SUCCESS (as expected for today)');
        
        -- Clean up
        DELETE FROM products WHERE product_id = 99999;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test INSERT: BLOCKED - ' || SQLERRM);
    END;
END;
/