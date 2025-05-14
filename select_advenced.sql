USE bankdb;



-- הצגת רשימה של לקוחות, סך ההפקדות והמשיכות שלהם, וממוצע סכום העסקה שלהם
SELECT
    c.first_name,
    c.last_name,
    SUM(CASE WHEN t.transaction_type = 'Deposit' THEN t.amount ELSE 0 END) AS total_deposits,
    SUM(CASE WHEN t.transaction_type = 'Withdrawal' THEN t.amount ELSE 0 END) AS total_withdrawals,
    AVG(t.amount) AS average_transaction_amount
FROM
    Customers c
JOIN
    BankAccounts ba ON c.customer_id = ba.customer_id
JOIN
    Transactions t ON ba.bank_account_id = t.sender_account_id
GROUP BY
    c.customer_id;



-- הצגת סכום ההלוואות הכולל בכל סניף, ומספר ההלוואות הממוצע ללקוח בכל סניף
SELECT
    b.branch_name,
    SUM(l.loan_amount) AS total_loan_amount,
    AVG(loan_count) AS average_loans_per_customer
FROM
    Branches b
JOIN
    Employees e ON b.branch_id = e.branch_id
JOIN
    BankAccounts ba ON e.employee_id = ba.responsible_employee_id
JOIN
    Loans l ON ba.bank_account_id = l.bank_account_id
JOIN (SELECT ba.customer_id, count(l.loan_id) as loan_count
	from bankaccounts ba
		join loans l on ba.bank_account_id = l.bank_account_id
		group by ba.customer_id)
		as customer_loan on ba.customer_id = customer_loan.customer_id
GROUP BY
    b.branch_id
HAVING count(l.loan_id) > 0;



-- הצגת רשימה של כרטיסי אשראי, סכום התשלומים הכולל שלהם, והתשלום המקסימלי שבוצע בכרטיס
SELECT
    cc.credit_card_id,
    cc.card_type,
    SUM(p.payment_amount) AS total_payments,
    MAX(p.payment_amount) AS max_payment
FROM
    CreditCards cc
JOIN
    Payments p ON cc.credit_card_id = p.credit_card_id
GROUP BY
    cc.credit_card_id;



-- הצגת רשימה של עובדים, מספר הלקוחות שהם אחראים עליהם, וסכום יתרות החשבונות של הלקוחות שלהם
SELECT
    e.first_name,
    e.last_name,
    COUNT(ba.bank_account_id) AS number_of_accounts,
    SUM(ba.balance) AS total_balance_of_accounts
FROM
    Employees e
LEFT JOIN
    BankAccounts ba ON e.employee_id = ba.responsible_employee_id
GROUP BY
    e.employee_id;



-- הצגת רשימה של לקוחות שיש להם יותר מחשבון בנק אחד
SELECT
    c.first_name,
    c.last_name,
    COUNT(ba.bank_account_id) AS number_of_accounts
FROM
    Customers c
JOIN
    BankAccounts ba ON c.customer_id = ba.customer_id
GROUP BY
    c.customer_id
HAVING
    COUNT(ba.bank_account_id) > 1;



-- הצגת 5 העסקאות האחרונות שבוצעו במערכת
SELECT
    c.first_name,
    c.last_name,
    t.transaction_id,
    t.transaction_datetime,
    t.amount
FROM
    Customers c
JOIN
    BankAccounts ba ON c.customer_id = ba.customer_id
JOIN
    Transactions t ON ba.bank_account_id = t.sender_account_id
JOIN (
    SELECT
        sender_account_id,
        transaction_id
    FROM
        Transactions
    ORDER BY
        transaction_datetime DESC
    LIMIT 5
) AS latest_transactions ON t.transaction_id = latest_transactions.transaction_id
					AND t.sender_account_id = latest_transactions.sender_account_id
ORDER BY
    c.last_name, t.transaction_datetime DESC;



-- הצגת רשימה של לקוחות וסוג כרטיס האשראי שלהם (אם קיים)
SELECT
    c.first_name,
    c.last_name,
    cc.card_type
FROM
    Customers c
LEFT JOIN
    BankAccounts ba ON c.customer_id = ba.customer_id
LEFT JOIN
    CreditCards cc ON ba.bank_account_id = cc.bank_account_id;



-- הצגת רשימה של סניפים ומספר החשבונות שנפתחו בהם
SELECT
    b.branch_name,
    count(ba.bank_account_id) AS num_of_accounts
FROM
    Branches b
	join employees e on b.branch_id = e.branch_id
	join bankaccounts ba on e.employee_id = ba.responsible_employee_id
GROUP BY
    b.branch_id
ORDER BY num_of_accounts desc;



-- מציג סכום הלוואות בעבור כל סוג כרטיס אשראי
SELECT
    cc.card_type,
    SUM(l.loan_amount) AS total_loan_amount
FROM
    CreditCards cc
JOIN
    BankAccounts ba ON cc.bank_account_id = ba.bank_account_id
JOIN
    Loans l ON ba.bank_account_id = l.bank_account_id
GROUP BY
    cc.card_type;



-- מציג סך הלוואות לכל לקוח
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)      AS full_name,
    SUM(l.loan_amount)                          AS total_loans
FROM Customers        AS c
JOIN BankAccounts     AS ba ON ba.customer_id = c.customer_id
JOIN Loans            AS l  ON l.bank_account_id = ba.bank_account_id
GROUP BY c.customer_id
HAVING SUM(l.loan_amount) > 0;



-- מציג את העסקה האחרונה של כל לקוח
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ( SELECT MAX(t.transaction_datetime)
      FROM BankAccounts ba2
      JOIN Transactions t ON t.sender_account_id = ba2.bank_account_id
      WHERE ba2.customer_id = c.customer_id
    ) AS last_txn_date
FROM Customers c;



-- מציג את היתרה המצטברת של כל החשבונות בכל סניף
SELECT
    b.branch_id,
    b.branch_name,
    SUM(ba.balance)      AS total_branch_balance
FROM Branches   b
JOIN Employees  e  ON e.branch_id = b.branch_id
JOIN BankAccounts ba ON ba.responsible_employee_id = e.employee_id
GROUP BY b.branch_id;



-- מציג ממוצע יתרות בחשבונות בעבור כל סניף
SELECT
    b.branch_name,
    AVG(ba.balance) AS avg_balance
FROM Branches b
JOIN Employees e  ON e.branch_id = b.branch_id
JOIN BankAccounts ba ON ba.responsible_employee_id = e.employee_id
GROUP BY b.branch_id;



-- מציג את מספר הפקידים בכל סניף
SELECT b.branch_id, b.branch_name,
       ( SELECT COUNT(*) FROM Employees
         WHERE branch_id = b.branch_id AND job_title = 'Teller') AS teller_count
FROM Branches b
ORDER BY teller_count DESC;



-- מציג את כל הסניפים שיש בהן או יותר מ2 מנהלים או יותר מ5 פקידים
( SELECT b.branch_id, b.branch_name, '2 or more Managers OR 5 or More Tellers' AS criterion
  FROM Branches AS b
  JOIN Employees AS e ON b.branch_id = e.branch_id
  WHERE e.job_title = 'Manager'
  GROUP BY b.branch_id, b.branch_name
  HAVING COUNT(e.employee_id) >= 2
)
UNION
( SELECT b.branch_id, b.branch_name, '2 or more Managers OR 5 or More Tellers' AS criterion
  FROM Branches AS b
  JOIN Employees AS e ON b.branch_id = e.branch_id
  WHERE e.job_title = 'Teller'
  GROUP BY b.branch_id, b.branch_name
  HAVING COUNT(e.employee_id) >= 5
);



-- מציג בעבור כל עובד את סכום ההלוואות של החשבונות שהוא אחראי עליהם
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    SUM(l.loan_amount) AS managed_loan_total
FROM Employees   e
JOIN BankAccounts ba ON ba.responsible_employee_id = e.employee_id
JOIN Loans        l  ON l.bank_account_id = ba.bank_account_id
GROUP BY e.employee_id
HAVING managed_loan_total IS NOT NULL; -- מציג רק עובדים שיש להם לפחות הלוואה אחת שהם אחראים עליה



-- מציג בעבור כל עובד את ממוצע מסגרות האשראי של הבנקים שהוא אחראי עליהם
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    ( SELECT AVG(cc.credit_limit)
      FROM   BankAccounts ba2
      JOIN   CreditCards  cc ON cc.bank_account_id = ba2.bank_account_id
      WHERE  ba2.responsible_employee_id = e.employee_id
    ) AS avg_credit_limit
FROM Employees e;



-- מציג עובדים שלא אחראים על אף חשבון
SELECT e.employee_id, e.first_name, e.last_name
FROM Employees e
LEFT JOIN BankAccounts ba ON ba.responsible_employee_id = e.employee_id
WHERE ba.bank_account_id IS NULL;



-- מציג כרטיסי האשראי שיהיו פגי תוקף עוד חצי שנה או פחות
SELECT
    credit_card_id,
    card_type,
    expiry_date
FROM CreditCards
WHERE expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 6 MONTH);



-- סכום התשלומים בשנה האחרונה לכל כרטיס אשראי
SELECT
    cc.credit_card_id,
    cc.card_type,
    SUM(p.payment_amount) AS payments_last_year
FROM CreditCards cc
JOIN Payments p ON p.credit_card_id = cc.credit_card_id
WHERE p.payment_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY cc.credit_card_id;



-- מציג כרטיסי אשראי מסוג ויזה או מאסטרקארד עם מסגרת מעל 10000
(SELECT credit_card_id, 'Visa' AS brand, credit_limit
FROM CreditCards
WHERE card_type = 'Visa' AND credit_limit > 10000)
UNION
(SELECT credit_card_id, 'MasterCard' AS brand, credit_limit
FROM CreditCards
WHERE card_type = 'MasterCard' AND credit_limit > 10000);



-- מציג פרטים בעבור כל שולח של טרנזקציה
SELECT
    t.transaction_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    t.amount,
    t.transaction_type
FROM Transactions t
JOIN BankAccounts ba ON ba.bank_account_id = t.sender_account_id
JOIN Customers c ON c.customer_id = ba.customer_id;



-- מציג בעבור כל חשבון את הטרנזקציה האחרונה אם קיימת כזאת
SELECT
    ba.bank_account_id,
    t.transaction_datetime,
    t.amount
FROM BankAccounts ba
LEFT JOIN (
      SELECT sender_account_id,
             MAX(transaction_datetime) AS last_dt
      FROM   Transactions
      GROUP  BY sender_account_id
) AS x  ON x.sender_account_id = ba.bank_account_id
LEFT JOIN Transactions t
       ON t.sender_account_id   = x.sender_account_id
      AND t.transaction_datetime = x.last_dt;



-- מציג את כל ההלוואות שנגמרות עוד 30 יום
SELECT *
FROM Loans
WHERE end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY);



-- מציג כרטיסי אשראי שלא ביצעו אף תשלום
SELECT
    cc.credit_card_id,
    cc.card_type,
    cc.credit_limit
FROM CreditCards cc
LEFT JOIN Payments p ON p.credit_card_id = cc.credit_card_id
WHERE p.payment_id IS NULL;