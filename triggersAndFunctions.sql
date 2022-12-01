/*Create triggers and functions*/

--change to view?
--1)
SELECT first_name
FROM client
WHERE client_id IN (
SELECT client_id
FROM client_account
WHERE sign_role = TRUE);

SELECT * FROM account;

SELECT * 
FROM account
WHERE account_id in (
	SELECT account_id
	FROM account
	WHERE required_signatures < (
	SELECT accout
		

--3)
SELECT * 
FROM statements
WHERE confirmed = TRUE;

--4)
		
CREATE FUNCTION paid_transactions (account_id INT)
	RETURNS TABLE (
	amount VARCHAR(30),
	transaction_type VARCHAR(30),
	transaction_time TIMESTAMP,
	note VARCHAR(100))
	AS $$
	BEGIN
	RETURN QUERY
		SELECT transactions.amount, transactions.transaction_type, transactions.transaction_time, transactions.note
		FROM transactions
		WHERE transaction_to = 1 AND statement_id in (
			SELECT statement_id
			FROM statements
			WHERE confirmed = FALSE
		);
	END;
	$$ language plpgsql
		
--5) Need to put into function
	SELECT *
	FROM statement_signer
	WHERE signed = False AND client_id = AND client_id IN (
	SELECT client_id 
	FROM client_account
	WHERE sign = TRUE);
		
--6)
