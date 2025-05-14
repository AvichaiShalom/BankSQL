USE bankdb;

-- יצירת טבלת לקוחות
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    address VARCHAR(100),
    phone_number VARCHAR(15),
    email VARCHAR(100)
);

-- יצירת טבלת סניפים
CREATE TABLE Branches (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(50) NOT NULL,
    address VARCHAR(100)
);

-- יצירת טבלת עובדים
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    job_title VARCHAR(50) NOT NULL,
    branch_id INT NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

-- יצירת טבלת חשבונות בנק
CREATE TABLE BankAccounts (
    bank_account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    responsible_employee_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (responsible_employee_id) REFERENCES Employees(employee_id)
);

-- יצירת טבלת כרטיסי אשראי
CREATE TABLE CreditCards (
    credit_card_id INT PRIMARY KEY AUTO_INCREMENT,
    bank_account_id INT NOT NULL,
    card_type VARCHAR(20) NOT NULL,
    credit_limit DECIMAL(15,2) NOT NULL,
    expiry_date DATE NOT NULL,
    FOREIGN KEY (bank_account_id) REFERENCES BankAccounts(bank_account_id)
);

-- יצירת טבלת עסקאות
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    sender_account_id INT NOT NULL,
    receiver_bank_number VARCHAR(20) DEFAULT NULL,
    receiver_branch_number VARCHAR(20) DEFAULT NULL,
    receiver_account_number VARCHAR(20) DEFAULT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    transaction_type ENUM('Transfer', 'Deposit', 'Withdrawal') NOT NULL,
    FOREIGN KEY (sender_account_id) REFERENCES BankAccounts(bank_account_id)
);

-- יצירת טבלת הלוואות
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    bank_account_id INT NOT NULL,
    loan_amount DECIMAL(15,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (bank_account_id) REFERENCES BankAccounts(bank_account_id)
);

-- יצירת טבלת תשלומים
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    credit_card_id INT NOT NULL,
    payment_amount DECIMAL(15,2) NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (credit_card_id) REFERENCES CreditCards(credit_card_id)
);
