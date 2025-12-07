=============================================
PHASE VI: PL/SQL COMPONENTS VALIDATION
=============================================

TEST 1: BASIC FUNCTIONS
-----------------------
Product 1001 (Product 1):
  Days until expiry: 32.95299768518518518518518518518518518519
  Recommended discount: 0%
  Alert status: ACTIVE

Product 1002 (Product 2):
  Days until expiry: 42.95299768518518518518518518518518518519
  Recommended discount: 0%
  Alert status: ACTIVE

Product 1003 (Product 3):
  Days until expiry: 32.95299768518518518518518518518518518519
  Recommended discount: 0%
  Alert status: ACTIVE

TEST 2: PACKAGE FUNCTIONS
--------------------------
Total expiring products (7 days): 8
Total expiring products (14 days): 16
Staff 101 performance: 0

TEST 3: PACKAGE PROCEDURES
---------------------------
Updating product statuses...
Updated status for 7 products
Product statuses updated successfully

TEST 4: REF CURSOR DEMONSTRATION
---------------------------------
Expiring products (next 7 days):
--------------------------------
1031: Product 31 (Canned) - 0 days - 50% discount
1082: Product 82 (Meat) - 0 days - 50% discount
1086: Product 86 (Frozen) - 0 days - 50% discount
1095: Product 95 (Canned) - 0 days - 50% discount
1010: Product 10 (Meat) - 2 days - 30% discount
Total expiring products found: 8

TEST 5: STAFF VALIDATION FUNCTION
---------------------------------
Staff 101 is valid for action

=============================================
VALIDATION COMPLETED SUCCESSFULLY!
=============================================


PL/SQL procedure successfully completed.

