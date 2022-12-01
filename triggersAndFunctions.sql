/*Create triggers and functions*/

--change to view?
--1) Checked - CORRECT
SELECT first_name, last_name
FROM client
WHERE client_id IN (
	SELECT client_id
	FROM client_account
	WHERE sign_role = TRUE);

SELECT * FROM client_account;
SELECT * FROM client;


		

--3) Checked - CORRECT
SELECT * 
FROM statements
WHERE confirmed = TRUE;

--4)assmunming that by "account is not paid" it means deposit transactions for statement that is not confirmed.
--checked - CORRECT
CREATE OR REPLACE FUNCTION paid_transactions (account_id INT)
	RETURNS TABLE (
					amount NUMERIC(10,0),
					transaction_type VARCHAR(30),
					transaction_time TIMESTAMP,
					note VARCHAR(100))
	AS $$
	BEGIN
	RETURN QUERY
		SELECT transactions.amount, transactions.transaction_type, transactions.transaction_time, transactions.note
		FROM transactions
		WHERE transactions.transaction_to = account_id AND transactions.transaction_type = 'deposit' AND transactions.statement_id in (
			SELECT statements.statement_id
			FROM statements
			WHERE statements.confirmed = FALSE
		);
	END;
	$$ language plpgsql

	
SELECT * FROM paid_transactions (6);
		
--5) Need to put into function
	SELECT *
	FROM statement_signer
	WHERE signed = False AND client_id = AND client_id IN (
	SELECT client_id 
	FROM client_account
	WHERE sign = TRUE);
		
--6)
