# STEP 1 - Create Database

FILE  - **01_Create_Database.sql**

What this does :

### CREATE DATABASE PointPay;
### USE PointPay;

Creates the PointPay Database and switches to the current database.

Every table, view, trigger, function and procedure created afterwards will belong to PointPay instead of master which is SQL Server's default database.


# STEP 2 - Create Tables

FILE - **02_Create_Tables.sql**

What this does :

### CREATE TABLE Employees
Creates the Employees table to store employee account, login, and profile information.

### CREATE TABLE Wallets
Creates the Wallets table and establishes a one-to-one relationship between each employee and their wallet.

### CREATE TABLE Products
Creates the Products table to store the product catalogue, pricing, stock quantity, and availability.

### CREATE TABLE Orders
Creates the Orders table to store purchase information, payment details, order status, and order history.

### CREATE TABLE WalletTransactions
Creates the WalletTransactions table to record all wallet credits, debits, refunds, and point transactions.

### CREATE TABLE OrderItems
Creates the OrderItems table to store individual products associated with each order, including quantity and purchase prices.

### CREATE TABLE Returns
Creates the Returns table to manage return requests, approvals, and refund information.

### Constraints Implemented
- Primary Keys (PK)
- Foreign Keys (FK)
- Unique Constraints
- Check Constraints
- Default Constraints

This script also establishes the relationships between all seven tables and enforces referential integrity using primary keys, foreign keys, and additional constraints.


# STEP 3 - Insert Sample Data

FILE - **03_Insert_Data.sql**

What this does:

Populates the PointPay database with realistic sample data for testing
and demonstration purposes.

The data is inserted in the correct dependency order to satisfy all
foreign key constraints.

Tables populated:

1. Employees (50 Records)
   Fictional employee data using common U.S. Census names with SHA2-256
   hashed passwords.

2. Wallets (50 Records)
   One wallet assigned to each employee.

3. Products (50 Records)
   Employee reward catalogue inspired by publicly available reward
   platforms and retail product listings.

4. Orders (100 Records)
   Employee reward redemption orders spread across April–June 2026 with
   Completed, Pending and Cancelled statuses.

5. OrderItems
   Products associated with each order. These records represent the
   source of truth for order totals.

The monetary fields in the Orders table are intentionally initialised
to their default values. The final order totals are calculated
automatically later using a User Defined Function and Trigger.

Data Sources:

- U.S. Census Bureau – Frequently Occurring Surnames
- U.S. Social Security Administration – Popular Baby Names
- Product catalogue inspired by publicly available employee rewards
  platforms and approximate retail prices from Awardco, Reward Gateway,
  Amazon UK, Logitech, Dell, Apple, JBL and Anker.

All data is used for educational purposes only.



# STEP 4 - User Defined Functions

FILE - **04_User_Defined_Functions.sql**

What this does:

Creates reusable SQL Server User Defined Functions (UDFs) used
throughout the PointPay database.

Functions created:

1. udf_CalculateOrderTotal
   Calculates the total monetary value of an order by summing all
   products purchased.

2. udf_GetWalletBalance
   Calculates an employee's wallet balance using wallet transactions.

3. udf_IsProductAvailable
   Checks whether sufficient stock exists before allowing a purchase.

These functions are later used by triggers, stored procedures and
views to reduce code duplication and improve maintainability.

Test Queries:

```sql
SELECT dbo.udf_CalculateOrderTotal(1);

SELECT dbo.udf_GetWalletBalance(1);

SELECT dbo.udf_IsProductAvailable(1,2);
```

All functions were successfully tested after creation.


# STEP 5 - Create Triggers

FILE - **05_Triggers.sql**

What this does:

Creates SQL Server triggers used to automate business rules
within the PointPay database.

Triggers created:

1. trg_UpdateOrderTotal
   Automatically recalculates an order's total whenever
   products are added, modified or removed from OrderItems.

2. trg_CheckProductAvailability
   Prevents inactive or out-of-stock products from being
   added to an order.

3. trg_ProcessApprovedReturn
   Automatically updates wallet transactions when a return
   request is approved.

These triggers improve data consistency by automatically
maintaining derived values and enforcing business rules.
