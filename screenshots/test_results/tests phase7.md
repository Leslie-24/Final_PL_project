SYSTEM INFORMATION:
-------------------
Current User: EXPIRY_ADMIN
Day of Week: 7 (1=Sun,7=Sat)
Is Weekday: NO
Is Holiday: NO
Is Restricted: NO

TEST 1: Trigger blocks INSERT on weekday
-----------------------------------------
Status: Today is NOT a weekday
Note: This test requires a weekday

TEST 2: Trigger allows INSERT on weekend
----------------------------------------
Status: Today IS weekend and NOT holiday
✓ PASS: INSERT was allowed
  ✓ Audit log captured the operation

TEST 3: Trigger blocks INSERT on holiday
----------------------------------------
Status: Today is NOT a holiday (adding test holiday)
  Added today as a holiday for testing
✓ PASS: INSERT was blocked
  Error: ORA-04092: cannot COMMIT in a trigger

TEST 4: Audit log captures all attempts
--------------------------------------
Total audit entries: 6
✓ PASS: Audit log contains entries

TEST 5: Error messages are clear
--------------------------------
No error messages in audit log
Assuming error messages are clear based on trigger code

TEST 6: User info properly recorded
-----------------------------------
Current user: EXPIRY_ADMIN
Latest audit user: EXPIRY_ADMIN
✓ PASS: User info correctly recorded

=============================================
TESTING SUMMARY
=============================================
Tests passed: 4 out of 6

SYSTEM STATUS:
--------------
Triggers created: 7
Triggers valid: 7
Audit entries: 6


PL/SQL procedure successfully completed.

