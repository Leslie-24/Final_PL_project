
INFO                                                                    
------------------------------------------------------------------------
Current Date: Saturday , 06-DEC-2025

1 row selected. 

AUDIT CHECK RESULTS:
---------------------
Today is weekday: NO
Today is holiday: NO
Operation restricted: NO


PL/SQL procedure successfully completed.


TRIGGER_NAME                                                                                                                     TABLE_NAME                                                                                                                       TRIGGER_TYPE     STATUS  
-------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------- ---------------- --------
TRG_ACTION_LOG_RESTRICTION                                                                                                       ACTION_LOG                                                                                                                       BEFORE EACH ROW  ENABLED 
TRG_ALERTS_RESTRICTION                                                                                                           ALERTS                                                                                                                           BEFORE EACH ROW  ENABLED 
TRG_PRODUCTS_RESTRICTION                                                                                                         PRODUCTS                                                                                                                         BEFORE EACH ROW  ENABLED 
TRG_SALES_RESTRICTION                                                                                                            SALES                                                                                                                            BEFORE EACH ROW  ENABLED 
TRG_STAFF_COMPOUND                                                                                                               STAFF                                                                                                                            COMPOUND         ENABLED 

5 rows selected. 


HOLIDAY_ID HOLIDAY_NAME                                                                                         HOLIDAY_DATE         I STATUS
---------- ---------------------------------------------------------------------------------------------------- -------------------- - ------
         1 New Years Day                                                                                        01-JAN-2026          Y FUTURE
         3 Independence Day                                                                                     04-JAN-2026          Y FUTURE
         2 Christmas Day                                                                                        25-DEC-2025          Y FUTURE

3 rows selected. 


AUDIT_COUNT                                                         
--------------------------------------------------------------------
Security Audit Log entries: 0
Denied operations: 0
Successful operations: 0

3 rows selected. 


TRIGGER FUNCTIONALITY TEST:
---------------------------
✓ PRODUCTS: INSERT ALLOWED
✗ ALERTS: ORA-02291: integrity constraint (EXPIRY_ADMIN.FK_ALERTS_PRODUCT) violated - parent key not found
✗ SALES: ORA-02291: integrity constraint (EXPIRY_ADMIN.FK_SALES_PRODUCT) violated - parent key not found
✗ ACTION_LOG: ORA-02291: integrity constraint (EXPIRY_ADMIN.FK_LOG_PRODUCT) violated - parent key not found
✓ STAFF: INSERT ALLOWED

AUDIT LOG SUMMARY:
------------------


PL/SQL procedure successfully completed.

