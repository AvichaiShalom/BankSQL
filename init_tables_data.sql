USE bankdb;

-- הכנסת נתונים לטבלת Branches
INSERT INTO Branches (branch_name, address) VALUES
('Main Branch', '123 Main St'),
('North Branch', '456 North Rd'),
('East Branch', '789 East Blvd'),
('West Branch', '101 West Ave'),
('South Branch', '202 South Ln'),
('Central Branch', '303 Central Pkwy'),
('Park Branch', '404 Park St'),
('Market Branch', '505 Market Rd'),
('River Branch', '606 River Blvd'),
('Mountain Branch', '707 Mountain Dr'),
('Coastal Branch', '808 Coastal Rd'),
('Lakeside Branch', '909 Lakeside St'),
('Sunset Branch', '1001 Sunset Blvd'),
('Spring Branch', '1102 Spring Ln'),
('Hilltop Branch', '1203 Hilltop Ave'),
('Oak Branch', '1304 Oak St'),
('Pine Branch', '1405 Pine Rd'),
('Maple Branch', '1506 Maple Blvd'),
('Cedar Branch', '1607 Cedar St'),
('Willow Branch', '1708 Willow Ave');

-- הכנסת נתונים לטבלת Customers
INSERT INTO Customers (first_name, last_name, address, phone_number, email) VALUES
('John', 'Doe', '123 Elm St', '1234567890', 'john.doe@example.com'),
('Jane', 'Smith', '456 Oak St', '0987654321', 'jane.smith@example.com'),
('James', 'Brown', '789 Pine St', '1112233445', 'james.brown@example.com'),
('Mary', 'Johnson', '101 Maple St', '2223344556', 'mary.johnson@example.com'),
('Robert', 'Miller', '112 Cedar St', '3334455667', 'robert.miller@example.com'),
('Linda', 'Davis', '123 Birch St', '4445566778', 'linda.davis@example.com'),
('William', 'Garcia', '134 Pine Rd', '5556677889', 'william.garcia@example.com'),
('Elizabeth', 'Martinez', '145 Oak Ave', '6667788990', 'elizabeth.martinez@example.com'),
('David', 'Hernandez', '156 Maple Rd', '7778899001', 'david.hernandez@example.com'),
('Susan', 'Lopez', '167 Cedar Blvd', '8889900112', 'susan.lopez@example.com'),
('Charles', 'Gonzalez', '178 Birch Blvd', '9991001223', 'charles.gonzalez@example.com'),
('Joseph', 'Wilson', '189 Elm Ave', '1001122334', 'joseph.wilson@example.com'),
('Mary', 'Anderson', '200 Pine St', '2112233445', 'mary.anderson@example.com'),
('Thomas', 'Thomas', '211 Maple Ave', '3223344556', 'thomas.thomas@example.com'),
('Patricia', 'Taylor', '222 Cedar Rd', '4334455667', 'patricia.taylor@example.com'),
('Christopher', 'Moore', '233 Birch Rd', '5445566778', 'christopher.moore@example.com'),
('Sarah', 'Jackson', '244 Elm Rd', '6556677889', 'sarah.jackson@example.com'),
('Daniel', 'White', '255 Oak Blvd', '7667788990', 'daniel.white@example.com'),
('Karen', 'Harris', '266 Maple Blvd', '8778899001', 'karen.harris@example.com'),
('George', 'Clark', '277 Cedar Ave', '9889900112', 'george.clark@example.com');

-- הכנסת נתונים לטבלת Employees
INSERT INTO Employees (first_name, last_name, job_title, branch_id) VALUES
('Alice', 'Johnson', 'Manager', 1),
('Bob', 'Williams', 'Teller', 2),
('Charlie', 'Brown', 'Loan Officer', 3),
('David', 'Clark', 'Teller', 4),
('Eve', 'Adams', 'Manager', 5),
('Frank', 'Morris', 'Loan Officer', 6),
('Grace', 'Lewis', 'Manager', 7),
('Hannah', 'Walker', 'Teller', 8),
('Ivy', 'Roberts', 'Loan Officer', 9),
('Jack', 'Nelson', 'Manager', 10),
('Kathy', 'Young', 'Teller', 11),
('Louis', 'King', 'Loan Officer', 12),
('Mona', 'Scott', 'Manager', 13),
('Nathan', 'Baker', 'Teller', 14),
('Olivia', 'Perez', 'Loan Officer', 15),
('Paul', 'Carter', 'Manager', 16),
('Quincy', 'Evans', 'Teller', 17),
('Rachel', 'Gonzalez', 'Loan Officer', 18),
('Steve', 'Martinez', 'Manager', 19),
('Tina', 'Hernandez', 'Teller', 20),

('Anna',  'Morgan',   'Manager', 1),  -- branch 1 now has 3 managers
('Ben',   'Foster',   'Manager', 1),

('Tom',   'Hanks',    'Teller',  2),  -- branch 2 will have 5 tellers
('Jerry', 'Seinfeld', 'Teller',  2),
('Kate',  'Winslet',  'Teller',  2),
('Mike',  'Jordan',   'Teller',  2);

-- הכנסת נתונים לטבלת BankAccounts
INSERT INTO BankAccounts (customer_id, account_type, balance, responsible_employee_id) VALUES
(1, 'Checking', 5000.00, 1),
(2, 'Savings', 3000.00, 2),
(3, 'Checking', 1500.00, 3),
(4, 'Savings', 2000.00, 4),
(5, 'Checking', 2500.00, 5),
(6, 'Savings', 1000.00, 6),
(7, 'Checking', 4000.00, 7),
(8, 'Savings', 3000.00, 8),
(9, 'Checking', 2000.00, 9),
(10, 'Savings', 1500.00, 10),
(11, 'Checking', 500.00, 11),
(12, 'Savings', 1000.00, 12),
(13, 'Checking', 3500.00, 13),
(14, 'Savings', 4000.00, 14),
(15, 'Checking', 4500.00, 15),
(16, 'Savings', 1000.00, 16),
(17, 'Checking', 6000.00, 17),
(18, 'Savings', 3000.00, 18),
(19, 'Checking', 7500.00, 19),
(20, 'Savings', 1200.00, 20),

(1, 'Savings',     2500.00,  1),    -- לקוח 1: עכשיו 3 חשבונות
(1, 'Investment',  8000.00,  3),
(2, 'Checking',    1800.00,  2),    -- לקוח 2: עכשיו 3 חשבונות
(2, 'Savings',     2200.00,  4);

-- הכנסת נתונים לטבלת CreditCards
INSERT INTO CreditCards (bank_account_id, card_type, credit_limit, expiry_date) VALUES
(1, 'Visa', 10000.00, '2026-12-31'),
(2, 'MasterCard', 5000.00, '2025-11-30'),
(3, 'Visa', 7500.00, '2027-01-31'),
(4, 'MasterCard', 4000.00, '2026-06-30'),
(5, 'Visa', 12000.00, '2025-12-15'),
(6, 'MasterCard', 2000.00, '2026-03-01'),
(7, 'Visa', 15000.00, '2027-07-31'),
(8, 'MasterCard', 8000.00, '2025-09-30'),
(9, 'Visa', 5000.00, '2026-11-30'),
(10, 'MasterCard', 4000.00, '2027-08-15'),
(11, 'Visa', 10000.00, '2026-10-10'),
(12, 'MasterCard', 7000.00, '2025-06-20'),
(13, 'Visa', 6000.00, '2027-02-01'),
(14, 'MasterCard', 12000.00, '2026-05-22'),
(15, 'Visa', 5000.00, '2027-04-30'),
(16, 'MasterCard', 3000.00, '2026-09-10'),
(17, 'Visa', 4000.00, '2025-07-18'),
(18, 'MasterCard', 6000.00, '2027-03-25'),
(19, 'Visa', 15000.00, '2025-12-01'),
(20, 'MasterCard', 2000.00, '2026-11-15'),

(19, 'Visa',        13000.00, '2026-12-31'),
(17, 'MasterCard',  14000.00, '2026-11-30');  

-- הכנסת נתונים לטבלת Transactions
INSERT INTO Transactions (sender_account_id, receiver_bank_number, receiver_branch_number, receiver_account_number, amount, transaction_type) VALUES
(1, '001', '101', '0001', 100.00, 'Transfer'),
(2, '002', '102', '0002', 200.00, 'Deposit'),
(3, NULL, NULL, NULL, 50.00, 'Withdrawal'),
(4, '003', '103', '0003', 75.00, 'Transfer'),
(5, '004', '104', '0004', 150.00, 'Deposit'),
(6, NULL, NULL, NULL, 25.00, 'Withdrawal'),
(7, '005', '105', '0005', 300.00, 'Transfer'),
(8, '006', '106', '0006', 500.00, 'Deposit'),
(9, NULL, NULL, NULL, 125.00, 'Withdrawal'),
(10, '007', '107', '0007', 200.00, 'Transfer'),
(11, '008', '108', '0008', 350.00, 'Deposit'),
(12, NULL, NULL, NULL, 75.00, 'Withdrawal'),
(13, '009', '109', '0009', 450.00, 'Transfer'),
(14, '010', '110', '0010', 600.00, 'Deposit'),
(15, NULL, NULL, NULL, 200.00, 'Withdrawal'),
(16, '011', '111', '0011', 700.00, 'Transfer'),
(17, '012', '112', '0012', 800.00, 'Deposit'),
(18, NULL, NULL, NULL, 150.00, 'Withdrawal'),
(19, '013', '113', '0013', 250.00, 'Transfer'),
(20, '014', '114', '0014', 300.00, 'Deposit'),

-- לקוח 1, חשבון 21
(16, NULL, NULL, NULL, 400.00, 'Deposit'),
(18, NULL, NULL, NULL, 120.00, 'Withdrawal'),

-- לקוח 2, חשבון 23
(17, NULL, NULL, NULL, 600.00, 'Deposit'),
(17, NULL, NULL, NULL, 250.00, 'Withdrawal');


-- הכנסת נתונים לטבלת Loans
INSERT INTO Loans (bank_account_id, loan_amount, start_date, end_date, interest_rate) VALUES
(1, 10000.00, '2024-01-01', '2026-01-01', 5.00),
(2, 5000.00, '2024-02-01', '2025-02-01', 4.00),
(3, 15000.00, '2024-03-01', '2026-03-01', 6.00),
(4, 20000.00, '2024-04-01', '2025-04-01', 5.50),
(5, 10000.00, '2024-05-01', '2026-05-01', 4.75),
(6, 5000.00, '2024-06-01', '2025-06-01', 5.25),
(7, 20000.00, '2024-07-01', '2026-07-01', 5.00),
(8, 15000.00, '2024-08-01', '2025-08-01', 5.50),
(9, 10000.00, '2024-09-01', '2026-09-01', 6.00),
(10, 5000.00, '2024-10-01', '2025-10-01', 4.25),
(11, 20000.00, '2024-11-01', '2026-11-01', 5.75),
(12, 10000.00, '2024-12-01', '2025-12-01', 5.50),
(13, 15000.00, '2025-01-01', '2027-01-01', 6.00),
(14, 5000.00, '2025-02-01', '2026-02-01', 5.25),
(15, 20000.00, '2025-03-01', '2027-03-01', 4.75),
(16, 15000.00, '2025-04-01', '2026-04-01', 5.00),
(17, 10000.00, '2025-05-01', '2027-05-01', 4.50),
(18, 5000.00, '2025-06-01', '2026-06-01', 5.00),
(19, 15000.00, '2025-07-01', '2027-07-01', 6.50),
(20, 20000.00, '2025-08-01', '2027-08-01', 5.25);

-- הכנסת נתונים לטבלת Payments
INSERT INTO Payments (credit_card_id, payment_amount, payment_date) VALUES
(1, 500.00, '2024-01-15'),
(2, 200.00, '2024-02-10'),
(3, 150.00, '2024-03-05'),
(4, 400.00, '2024-04-01'),
(5, 500.00, '2024-05-25'),
(6, 250.00, '2024-06-20'),
(7, 700.00, '2024-07-10'),
(8, 350.00, '2024-08-15'),
(9, 450.00, '2024-09-12'),
(10, 600.00, '2024-10-05'),
(11, 300.00, '2024-11-30'),
(12, 200.00, '2024-12-10'),
(13, 150.00, '2025-01-15'),
(14, 500.00, '2025-02-20'),
(15, 600.00, '2025-03-05'),
(16, 700.00, '2025-04-01'),
(17, 250.00, '2025-05-10'),
(18, 350.00, '2025-06-25'),
(19, 450.00, '2025-07-15'),
(20, 500.00, '2025-08-01'),
(21, 350.00, '2025-04-20');
