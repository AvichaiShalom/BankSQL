USE bankdb;

-- שליפה מכל טבלת לקוחות עם תנאי על שם פרטי
SELECT * FROM Customers WHERE first_name = 'John';

-- שליפה מכל טבלת סניפים עם תנאי על שם הסניף
SELECT * FROM Branches WHERE branch_name = 'Main Branch';

-- שליפה מכל טבלת עובדים עם תנאי על תפקיד
SELECT * FROM Employees WHERE job_title = 'Manager';

-- שליפה מכל טבלת חשבונות בנק עם תנאי על יתרת החשבון
SELECT * FROM BankAccounts WHERE balance > 1000.00;

-- שליפה מכל טבלת כרטיסי אשראי עם תנאי על סוג הכרטיס
SELECT * FROM CreditCards WHERE card_type = 'Visa';

-- שליפה מכל טבלת עסקאות עם תנאי על סוג עסקה
SELECT * FROM Transactions WHERE transaction_type = 'Deposit';

-- שליפה מכל טבלת הלוואות עם תנאי על סכום הלוואה
SELECT * FROM Loans WHERE loan_amount > 5000.00;

-- שליפה מכל טבלת תשלומים עם תנאי על סכום התשלום
SELECT * FROM Payments WHERE payment_amount > 100.00;
