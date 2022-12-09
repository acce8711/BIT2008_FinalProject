/*LOGGING*/


--1) Show the name of the clients who have a ”sign” role on at least one account.
SELECT first_name, last_name
FROM client
WHERE client_id IN (
	SELECT client_id
	FROM client_account
	WHERE sign_role = TRUE);
	
--2) Show the list of the accounts with fewer required signatures than the signers.
SELECT account.account_id, account.total_balance, account.account_type, account.num_cosigner, account.required_signatures, signer_account.num_signers as number_of_signers
FROM account
INNER JOIN (SELECT client_account.account_id, COUNT(client_account.sign_role) as num_signers
			FROM client_account
			WHERE client_account.sign_role = TRUE
			GROUP BY client_account.account_id) AS signer_account
ON signer_account.account_id = account.account_id
WHERE account.required_signatures < signer_account.num_signers;


--3) Show the list of every statement that is confirmed.
SELECT * 
FROM statements
WHERE statements.statement_id IN (
	SELECT statement_confirmation.statement_id
	FROM statement_confirmation
	WHERE statement_confirmation.confirmed = TRUE);

--4)Show the list of all transactions to a certain account that is not paid.
/*ASSUMPTION: assuming that by "account is not paid" it means deposit transactions 
for statements that are not confirmed and are associated with the account.*/
CREATE OR REPLACE FUNCTION paid_transactions (account_id INT)
	RETURNS TABLE (
					statement_id INT,
					amount NUMERIC(10,2),
					transaction_type VARCHAR(30),
					transaction_time TIMESTAMP,
					note VARCHAR(100))
	AS $$
	BEGIN
	RETURN QUERY
		SELECT transactions.statement_id, transactions.amount, transactions.transaction_type, transactions.transaction_time, transactions.note
		FROM transactions
		WHERE transactions.transaction_to = account_id AND transactions.transaction_type = 'deposit' AND transactions.statement_id in (
			SELECT statement_confirmation.statement_id
			FROM statement_confirmation
			WHERE statement_confirmation.confirmed = FALSE
		);
	END;
	$$ language plpgsql

--Test	
SELECT * FROM paid_transactions (6);
		
--5) Show the list of all declined signatures of a certain client.
--assuming that declined signatures means where user has not signed the statement (FALSE)
CREATE OR REPLACE FUNCTION declined_signatures (client INT)
	RETURNS TABLE (
					statement_id INT,
					client_id INT,
					sign BOOLEAN)
	AS $$
	BEGIN
	RETURN QUERY
		SELECT statement_signer.statement_id, statement_signer.signer_id, statement_signer.sign
		FROM statement_signer
		WHERE statement_signer.sign = FALSE AND statement_signer.signer_id = client;
	END;
	$$ language plpgsql

--Test
SELECT * FROM declined_signatures(1);
		
-- 6) Show the list of all of the accounts that two certain clients have in common.
CREATE OR REPLACE FUNCTION accounts_in_common (client_1 INT, client_2 INT)
	RETURNS TABLE (
					account_id INT,
					total_balance NUMERIC(10,2),
					account_type VARCHAR(20), 
					num_cosigner INT,
					required_signatures INT
					)
	AS $$
	BEGIN
	RETURN QUERY
		SELECT account.account_id, account.total_balance, account.account_type, account.num_cosigner, account.required_signatures
		FROM account
		WHERE account.account_id IN (SELECT client_account.account_id
									 FROM client_account
									 WHERE client_account.client_id = client_2 
									 AND client_account.account_id IN (SELECT client_account.account_id
																	   FROM client_account
																	   WHERE client_account.client_id = client_1));
	END;
	$$ language plpgsql

--Test
SELECT * FROM accounts_in_common(5,6);


--7) Show the list of all statements that a certain client can sign.
CREATE OR REPLACE FUNCTION client_can_sign (client INT)
	RETURNS TABLE (
					statement_id INT,
					note VARCHAR(100),
					source_account INT, 
					initiator_client INT,
					total_amount NUMERIC(10,2)
					)
	AS $$
	BEGIN
	RETURN QUERY
		SELECT statements.statement_id, statements.note, statements.source_account, statements.initiator_client, statements.total_amount
		FROM statements
		WHERE statements.statement_id IN (
			SELECT statement_signer.statement_id
			FROM statement_signer
			WHERE statement_signer.signer_id = client);
	END;
	$$ language plpgsql;

--Test
SELECT * FROM client_can_sign(2);


--8) Show the list of every transaction that is initiated by a certain user but the person does not have the ”sign” permission on it.
--assuming that "transaction that is initiated by a certain user" means the intitator of the statement that the transaction belongs to.
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
		SELECT transactions.statement_id, transactions.amount, transactions.transaction_type, transactions.transaction_time, transactions.note, transactions.transaction_to
		FROM transactions
		WHERE transactions.statement_id IN (
			SELECT statements.statement_id
			FROM statements
			WHERE statements.initiator_client = client AND statements.initiator_client IN (
				SELECT client_account.client_id
				FROM client_account
				WHERE client_account.sign_role = FALSE));
	END;
	$$ language plpgsql;

--Test
SELECT * FROM client_initiate(6);


--9) Show the list of every deposit into a certain account that is above a certain amount.
--assuming that we only show deposits for transactions whose statements have been confirmed/paid.
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
		SELECT transactions.statement_id, transactions.amount, transactions.transaction_type, transactions.transaction_time, transactions.note, transactions.transaction_to 
		FROM transactions
		WHERE transactions.transaction_type = 'deposit'
			AND transactions.transaction_to = account
			AND transactions.amount > min_deposit_amount
			AND transactions.statement_id IN (
				SELECT statement_confirmation.statement_id
				FROM statement_confirmation
				WHERE statement_confirmation.confirmed = TRUE
			);
	END;
	$$ language plpgsql;

SELECT * FROM account_deposit(3,100);