USE bankdb;



SET SQL_SAFE_UPDATES = 0;
START TRANSACTION;



-- מחיקת לקוחות שאינם פעילים במערכת ואין להם חשבונות בנק
DELETE FROM Customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM BankAccounts);



-- מחיקת עסקאות השייכות לחשבונות בנק שנסגרו
DELETE FROM Transactions
WHERE sender_account_id NOT IN (
    SELECT bank_account_id
    FROM BankAccounts
);



-- מחיקת תשלומים שבוצעו בכרטיסי אשראי שפג תוקפם לפני יותר משנה
DELETE FROM Payments
WHERE credit_card_id IN (
    SELECT credit_card_id
    FROM CreditCards
    WHERE expiry_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);



-- מחיקת עובדים שאינם אחראים על אף לקוח
DELETE FROM Employees
WHERE employee_id NOT IN (SELECT DISTINCT responsible_employee_id
						FROM BankAccounts
						where responsible_employee_id is not null);



-- מחיקת סניפים שאינם פעילים, סניפים שאין בהם עובדים
DELETE FROM Branches
WHERE branch_id NOT IN (SELECT DISTINCT branch_id FROM Employees);



-- מחיקת לקוחות שאינם פעילים, לא בצעו טרנזרציות בחצי שנה האחרונה
DELETE FROM Customers
WHERE customer_id NOT IN (SELECT DISTINCT ba.customer_id
						FROM Transactions t
						join BankAccounts ba
							on t.sender_account_id = ba.bank_account_id
						where t.transaction_datetime > DATE_SUB(CURDATE(), INTERVAL 6 MONTH));



-- מוחק לקוחות חסרי מייל
DELETE FROM Customers
WHERE email IS NULL;



-- מוחק לקוחות חסרי טלפון
DELETE FROM Customers
WHERE phone_number IS NULL;



-- מוחק לקוחות שסכום הכסף שלהם השמור בבנק הוא 0
DELETE FROM Customers
WHERE customer_id IN (
        SELECT customer_id
        FROM BankAccounts
        GROUP BY customer_id
        HAVING SUM(balance) = 0
);



-- מחיקת סניפים ששמם מתחיל ב Old
DELETE FROM Branches
WHERE branch_name LIKE 'Old %';



-- מחיקת סניפים חסרי כתובת
DELETE FROM Branches
WHERE address IS NULL;



-- מחיקת עובדים שעובדים בסניף לא קיים
DELETE e
FROM Employees AS e
LEFT JOIN Branches AS b
	ON b.branch_id = e.branch_id
WHERE b.branch_id IS NULL;



-- מחיקת חשבונות הנמצעים בחוב של מיליון שקל
DELETE FROM BankAccounts
WHERE balance < -1000000;



-- מוחק חשבונות עם 0 ביתרה שאין להם כרטיסי אשראי והלוואות
DELETE ba
FROM BankAccounts AS ba
LEFT JOIN CreditCards AS cc ON cc.bank_account_id = ba.bank_account_id
LEFT JOIN Loans AS l
	ON l.bank_account_id  = ba.bank_account_id
WHERE ba.balance = 0
  AND cc.credit_card_id IS NULL
  AND l.loan_id        IS NULL;



-- מחיקת חשבונות של לקוחות לא קיימים
DELETE ba
FROM BankAccounts AS ba
LEFT JOIN Customers AS c ON c.customer_id = ba.customer_id
WHERE c.customer_id IS NULL;



-- מוחק כרטיסי אשראי שפג תוקפם לפני יותר משנתיים
DELETE FROM CreditCards
WHERE expiry_date < DATE_SUB(CURDATE(), INTERVAL 2 YEAR);



-- מוחק כרטיסי אשראי שחשבון הבנק שהם משוייכים אליו לא קיים
DELETE cc
FROM CreditCards AS cc
LEFT JOIN BankAccounts AS ba ON ba.bank_account_id = cc.bank_account_id
WHERE ba.bank_account_id IS NULL;



-- מוחק עסקאות שסכומם הוא 0
DELETE FROM Transactions
WHERE amount = 0;



-- מוחק העברות שחסר בהם את פרטי המקבל
DELETE FROM Transactions
WHERE transaction_type = 'Transfer'
  AND (receiver_bank_number   IS NULL
    OR receiver_branch_number IS NULL
    OR receiver_account_number IS NULL);



-- מוחק משיכות והפקדות שיש בהם פרטים לא רצויים
DELETE FROM Transactions
WHERE (transaction_type IN ('Withdrawal','Deposit'))
	AND (receiver_bank_number IS NOT NULL
	OR receiver_branch_number IS NOT NULL
	OR receiver_account_number IS NOT NULL);



-- מוחק עסקאות משיכה של סכום שלילי, טעות בהקלדה
DELETE FROM Transactions
WHERE transaction_type = 'Withdrawal' AND amount < 0;



-- מוחק עסקאות שבוצעו על ידי חשבון קפוא
DELETE t
FROM Transactions AS t
JOIN BankAccounts AS ba ON ba.bank_account_id = t.sender_account_id
WHERE ba.account_type = 'Frozen';



-- מוחק הלוואות שסכומן הוא 0
DELETE FROM Loans
WHERE loan_amount = 0;



-- מוחק הלוואות שמשוייכות לחשבון לא קיים
DELETE l
FROM Loans AS l
LEFT JOIN BankAccounts AS ba ON ba.bank_account_id = l.bank_account_id
WHERE ba.bank_account_id IS NULL;



-- מוחק תשלומים שסכומם הוא 0
DELETE FROM Payments
WHERE payment_amount = 0;



-- מוחק תשלומים מכרטיס אשראי שכבר לא קיים
DELETE p
FROM Payments AS p
LEFT JOIN CreditCards AS cc ON cc.credit_card_id = p.credit_card_id
WHERE cc.credit_card_id IS NULL;



ROLLBACK;
SET SQL_SAFE_UPDATES = 1;