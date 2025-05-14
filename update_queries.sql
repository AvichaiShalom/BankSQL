USE bankdb;



SET SQL_SAFE_UPDATES = 0;
START TRANSACTION;



-- עדכון יתרת חשבון לאחר ביצוע הפקדה
UPDATE BankAccounts ba
JOIN Transactions t ON ba.bank_account_id = t.sender_account_id
SET ba.balance = ba.balance + t.amount
WHERE t.transaction_type = 'Deposit';



-- עדכון מגבלת אשראי ללקוחות עם יתרת חשבון גבוהה מ-10,000 ש"ח
UPDATE CreditCards
SET credit_limit = credit_limit * 1.1
WHERE bank_account_id IN (
    SELECT bank_account_id
    FROM BankAccounts
    WHERE balance > 10000
);



-- עדכון הלוואות שתאריך הסיום שלהן עבר, על ידי עדכון שדה אחר במידה וישנו כזה
UPDATE Loans
SET interest_rate = interest_rate * 1.01 -- העלאת ריבית כקנס
WHERE end_date < CURDATE();



-- להוריד את סכום ההעברה מהחשבון השולח
UPDATE BankAccounts ba
JOIN Transactions t ON ba.bank_account_id = t.sender_account_id
SET ba.balance = ba.balance - t.amount
WHERE t.transaction_type = 'Transfer';



-- להפחית את מסגרת האשראי של כרטיסים שבהם חוב החודש גבוה מהמסגרת הקיימת
UPDATE CreditCards cc
SET credit_limit = credit_limit * 0.5
WHERE credit_limit < (
    SELECT SUM(payment_amount) 
    FROM Payments p 
    WHERE p.credit_card_id = cc.credit_card_id 
    GROUP BY p.credit_card_id
);



-- אם ללקוח יש הלוואה שפג תוקפה ועוד לא נסגרה, להוריד את מסגרת האשראי שלו
UPDATE CreditCards
SET credit_limit = credit_limit * 0.9
WHERE bank_account_id IN (
    SELECT bank_account_id 
    FROM Loans 
    WHERE end_date < CURDATE() AND loan_amount > 0
);



-- להוסיף את הריבית לסכום ההלוואה באופן מחזורי
UPDATE Loans
SET loan_amount = loan_amount * (1 + (interest_rate / 100))
WHERE end_date > CURDATE();



-- שינוי כתובת של לקוח לכתובת אחרת
UPDATE Customers
SET address = '901 Rooket St'
WHERE customer_id = 1;



-- עדכון תפקיד של עובד
UPDATE Employees
SET job_title = 'Senior Banker'
WHERE employee_id = 3;



-- העלאת תפקיד לכל העובדים בסניף מסוים
UPDATE Employees
SET job_title = 'Branch Manager'
WHERE branch_id = 1 AND job_title = 'Assistant Manager';



-- 
UPDATE BankAccounts
SET account_type = 'Checking'
WHERE account_type = 'Savings' AND customer_id = 2;



-- אפס את יתרת החשבונות הבלתי פעילים
UPDATE BankAccounts
SET balance = 0
WHERE bank_account_id NOT IN (SELECT DISTINCT sender_account_id FROM Transactions);

-- מוסיף קידומת של +972 למספרים שאינם מתחילים בקידום זאת
UPDATE Customers
SET phone_number = CONCAT('+972', phone_number)
WHERE phone_number NOT LIKE '+972%';



-- שינוי דומיין של אימיל מסויום לכל הלקוחות
UPDATE Customers
SET email = REPLACE(email, '@example.com', '@example.org')
WHERE email LIKE '%@example.com';



-- שינוי שם המשפחה לשם משפחה באותיות גדולות ללקוח עם יתרה גדולה
UPDATE Customers AS c
JOIN BankAccounts AS ba ON ba.customer_id = c.customer_id
SET c.last_name = UPPER(c.last_name)
WHERE ba.balance > 20000;


-- מוריד רווחים כפולים משם פרטי
UPDATE Customers
SET first_name = REPLACE(first_name,'  ',' ')
WHERE first_name LIKE '%  %';



-- מוריד רווחים כפולים משם משפחה
UPDATE Customers
SET last_name = REPLACE(last_name,'  ',' ')
WHERE last_name LIKE '%  %';



-- הוסף את המילה Branch לשם סניף שאין לו את המילה הזאת בסוף השם
UPDATE Branches
SET branch_name = CONCAT(branch_name,' Branch')
WHERE branch_name NOT LIKE '%Branch';



-- הוסף כינוי  (big branch) מעם מעל 5 מנהלים
UPDATE Branches AS b
JOIN (
      SELECT branch_id, COUNT(*) AS cnt
      FROM Employees
      WHERE job_title = 'Manager'
      GROUP BY branch_id
      HAVING COUNT(*) > 5
) AS x ON x.branch_id = b.branch_id
SET b.branch_name = CONCAT(b.branch_name,' (big branch)');



-- קידום פקיד בנק שיש לו יותר מ 3 אנשים שהוא אחראי עליהם
UPDATE Employees AS e
JOIN (
      SELECT responsible_employee_id, COUNT(*) AS cnt
      FROM BankAccounts
      WHERE responsible_employee_id IS NOT NULL
      GROUP BY responsible_employee_id
      HAVING COUNT(*) >= 3
) AS x ON x.responsible_employee_id = e.employee_id
SET e.job_title = 'Lead Teller'
WHERE e.job_title = 'Teller';



-- העברת בנקאים עם 0 לקוחות לסניף הראשי
UPDATE Employees AS e
LEFT JOIN BankAccounts AS ba ON ba.responsible_employee_id = e.employee_id
JOIN Branches        AS b  ON b.branch_name = 'Main Branch'
SET  e.branch_id = b.branch_id
WHERE ba.bank_account_id IS NULL
  AND e.job_title = 'Teller';



-- הפיכת חשבונות עו"ש שיש בהם מעל 10000 ש"ח לחשבונות עו"ש פרימיום
UPDATE BankAccounts
SET account_type = 'Premium Checking'
WHERE account_type = 'Checking' AND balance >= 10000;



-- מחליפה עובדים אחראים על חשבונות לאחד מהמנהלים המוגדרים באותו סניף
UPDATE BankAccounts AS ba
JOIN Employees     AS e ON e.branch_id = (
       SELECT branch_id FROM Employees WHERE employee_id = ba.responsible_employee_id LIMIT 1
) AND e.job_title = 'Manager'
SET ba.responsible_employee_id = e.employee_id;



-- הקפאת חשבון במינוס
UPDATE BankAccounts
SET account_type = 'Frozen'
WHERE balance < 0;



-- העלאת ריבית חודשית של 0.2% לחשבונות חסחון
UPDATE BankAccounts
SET balance = balance * 1.002
WHERE account_type = 'Savings';



-- מוסיף 3 שנים לתוקף של כרטיסים שפג תוקפם עוד 3 חודשים
UPDATE CreditCards
SET expiry_date = DATE_ADD(expiry_date, INTERVAL 3 YEAR)
WHERE expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 3 MONTH);





ROLLBACK;
SET SQL_SAFE_UPDATES = 1;