use bankdb;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Drop tables in the correct order
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS CreditCards;
DROP TABLE IF EXISTS Loans;
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS BankAccounts;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Branches;
DROP TABLE IF EXISTS Customers;

-- Enable foreign key checks again
SET FOREIGN_KEY_CHECKS = 1;
