/*Write queries here*/
/*Create triggers and functions*/

/*LOGGING*/

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
		
--5) assuming that declined signatures means where user has not signed the statement (FALSE)
--CHECKED - CORRECT
CREATE OR REPLACE FUNCTION declined_signatures (client INT)
	RETURNS TABLE (
					statement_id INT,
					client_id INT,
					sign BOOLEAN)
	AS $$
	BEGIN
	RETURN QUERY
		SELECT statement_signer.statement_id, statement_signer.client_id, statement_signer.sign
		FROM statement_signer
		WHERE statement_signer.sign = FALSE AND statement_signer.client_id = client AND statement_signer.client_id IN (
			--can remove this subquery once trigger contraints added to statement_signer table
			SELECT client_account.client_id 
			FROM client_account
			WHERE client_account.sign_role = TRUE);
	END;
	$$ language plpgsql

SELECT * FROM declined_signatures(1);
		
/* Attempt at 6)
SELECT *
FROM transactions
WHERE transactions.statement_id IN (
	SELECT statements.statement_id
	FROM statements
	WHERE statements.initiator_client = client AND statements.initiator_client IN (
		SELECT client_account.client_id
		FROM client_account
		WHERE client_account.sign_role = FALSE));
*/

--7) CHECKED - CORRECT
CREATE OR REPLACE FUNCTION client_can_sign (client INT)
	RETURNS TABLE (
					statement_id INT,
					note VARCHAR(100),
					source_account INT, 
					initiator_client INT,
					total_amount NUMERIC(10,0),
					confirmed BOOL,
					payer INT)
	AS $$
	BEGIN
	RETURN QUERY
		SELECT *
		FROM statements
		WHERE statements.statement_id IN (
			SELECT statement_signer.statement_id
			FROM statement_signer
			WHERE statement_signer.client_id = client AND statement_signer.client_id IN (
				--can remove this subquery once trigger contraints added to statement_signer table
				SELECT client_account.client_id 
				FROM client_account
				WHERE client_account.sign_role = TRUE));
	END;
	$$ language plpgsql

SELECT * FROM client_can_sign(1);

--8)assuming that "transaction that is initiated by a certain user" means the intitator of the statement that the transaction belongs to.
--checked - CORRECT
CREATE OR REPLACE FUNCTION client_initiate (client INT)
	RETURNS TABLE (
					statement_id INT,
					amount NUMERIC(10),
					transaction_type VARCHAR(30),
					transaction_time TIMESTAMP,
					note VARCHAR(100),
					transaction_to INT)
	AS $$
	BEGIN
	RETURN QUERY
		SELECT *
		FROM transactions
		WHERE transactions.statement_id IN (
			SELECT statements.statement_id
			FROM statements
			WHERE statements.initiator_client = client AND statements.initiator_client IN (
				SELECT client_account.client_id
				FROM client_account
				WHERE client_account.sign_role = FALSE));
	END;
	$$ language plpgsql
	
SELECT * FROM client_initiate(2);



--9) CHECKED - CORRECT
CREATE OR REPLACE FUNCTION account_deposit (account INT, min_deposit_amount INT)
	RETURNS TABLE (
					statement_id INT,
					amount NUMERIC(10),
					transaction_type VARCHAR(30),
					transaction_time TIMESTAMP,
					note VARCHAR(100),
					transaction_to INT)
	AS $$
	BEGIN
	RETURN QUERY
		SELECT * 
		FROM transactions
		WHERE transactions.transaction_type = 'deposit'
			AND transactions.transaction_to = account
			AND transactions.amount > min_deposit_amount;
			END;
	$$ language plpgsql

SELECT * FROM account_deposit(6,100);