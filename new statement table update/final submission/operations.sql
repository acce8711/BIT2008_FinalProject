--1) Adding a user
CREATE OR REPLACE FUNCTION add_user(user_id INT, name_first VARCHAR(30), name_last VARCHAR(30), user_password VARCHAR(20), phone_number NUMERIC (10, 0), address VARCHAR (50))
	RETURNS VOID
	AS $$
	BEGIN
		INSERT INTO client VALUES(user_id, name_first, name_last, user_password);
	    INSERT INTO client_phone VALUES(user_id, phone_number);
	    INSERT INTO client_address VALUES(user_id, address);
	END;
	$$
	LANGUAGE plpgsql;

--Test 
SELECT add_user(15,'Bob','Rocks','124dh',611233,'6th avenue');

--2) Adding an account
CREATE OR REPLACE FUNCTION add_account(acc_id INT, balance NUMERIC(10) DEFAULT 0, type_account VARCHAR(20) DEFAULT 'savings', cosigners INT DEFAULT 1, signatures INT DEFAULT 1)
	RETURNS VOID
	AS $$
	BEGIN
		INSERT INTO account (account_id, total_balance, account_type, num_cosigner, required_signatures) VALUES(acc_id, balance, type_account, cosigners, signatures);
	END;
	$$
	LANGUAGE plpgsql;
	
--Test 
SELECT add_account(8);

--3) Add, edit, or remove the access level of a certain user to a certain account.
CREATE OR REPLACE FUNCTION edit_access(user_id INT, account INT, sign_r BOOLEAN, view_r BOOLEAN, pay_r BOOLEAN)
	RETURNS VOID
	AS $$
	BEGIN
		IF ((user_id NOT IN (SELECT client_id FROM client_account)) OR (account NOT IN (SELECT account_id FROM client_account))) THEN
			RAISE EXCEPTION 'the client is not associated with the account';
		END IF;
		UPDATE client_account
		SET sign_role = sign_r,
			view_role = view_r,
			pay_role = pay_r
		WHERE client_account.client_id = user_id AND client_account.account_id = account;
	END;
	$$
	LANGUAGE plpgsql;

--Test 
SELECT edit_access(13,5,TRUE,TRUE,TRUE);

--4) Creating a statement
CREATE OR REPLACE FUNCTION create_statement(state_id INT, source_acc INT, initiator INT, note VARCHAR(100), total_amount INT DEFAULT 0)
	RETURNS VOID
	AS $$
	BEGIN
		INSERT INTO statements(statement_id, note, source_account, initiator_client, total_amount) VALUES(state_id, note, source_acc, initiator, total_amount);
	END;
	$$
	LANGUAGE plpgsql;
						
--Test 
SELECT create_statement(11,7,8,'test');

--5) Edit a statement. 
CREATE OR REPLACE FUNCTION edit_statement(state_id INT, source_acc INT DEFAULT NULL, initiator INT DEFAULT NULL, statement_note VARCHAR(100) DEFAULT NULL, amount INT DEFAULT NULL)
	RETURNS VOID
	AS $$
	BEGIN
		--checking if statement exists
		IF (state_id NOT IN (SELECT statement_id FROM statements)) THEN
			RAISE EXCEPTION 'statement does not exist';
		END IF;

		IF (source_acc IS NOT NULL) THEN
			UPDATE statements
			SET source_account = source_acc
			WHERE statements.statement_id = state_id;
		END IF;
		IF (initiator IS NOT  NULL) THEN
			UPDATE statements
			SET initiator_client = initiator
			WHERE statements.statement_id = state_id;
		END IF;
		IF (statement_note IS NOT  NULL) THEN
			UPDATE statements
			SET note = statement_note 
			WHERE statements.statement_id = state_id;
		END IF;
		IF (amount IS NOT  NULL) THEN
			UPDATE statements
			SET total_amount = amount
			WHERE statements.statement_id = state_id;
		END IF;
		
	END;
	$$
	LANGUAGE plpgsql;

--Test
SELECT edit_statement(11, 1, 1, 'I have been edited once again',0);

--5) Remove a statement. 
CREATE OR REPLACE FUNCTION remove_statement(state_id INT)
	RETURNS VOID
	AS $$
	BEGIN
		--checking if statement exists
		IF (state_id NOT IN (SELECT statement_id FROM statements)) THEN
			RAISE EXCEPTION 'statement does not exist';
		END IF;
		
		DELETE FROM statements
		WHERE statements.statement_id = state_id;
		
	END;
	$$
	LANGUAGE plpgsql;
	
--Test
SELECT remove_statement(8);

--6) Sign or unsign a statement. 
CREATE OR REPLACE FUNCTION sign_unsign_statement(id_statement INT, client_id INT, statement_sign BOOLEAN)
	RETURNS VOID
	AS $$
	BEGIN
		--checking if client_id and statement are in statement_signer table
		IF(id_statement NOT IN (SELECT statement_id FROM statement_signer) OR client_id NOT IN (SELECT signer_id FROM statement_signer)) THEN
			RAISE EXCEPTION 'client is not a signer for the statement';
		END IF;
		
		UPDATE statement_signer
		SET sign = statement_sign
		WHERE statement_signer.signer_id = client_id AND statement_signer.statement_id = id_statement;

	END;
	$$
	LANGUAGE plpgsql;

--Test 
SELECT sign_unsign_statement(4,4, TRUE);

--7) Pay a statement 
CREATE OR REPLACE FUNCTION pay_statement(id_statement INT, client_id INT)
	RETURNS VOID
	AS $$
	BEGIN
		--checking if client_id and statement are in statement_confrimation table
		IF(id_statement NOT IN (SELECT statement_id FROM statement_confirmation) OR client_id NOT IN (SELECT payer_id FROM statement_confirmation)) THEN
			RAISE EXCEPTION 'client is not a payer for the statement';
		END IF;
		
		UPDATE statement_confirmation
		SET confirmed = TRUE
		WHERE statement_confirmation.payer_id = client_id AND statement_confirmation.statement_id = id_statement;

	END;
	$$
	LANGUAGE plpgsql;

--Test 
SELECT pay_statement(4,4);

--8) Add incoming and outgoing transactions to an account 
CREATE OR REPLACE FUNCTION add_transaction(id_statement INT, account_id INT, amount INT, type_transaction VARCHAR(30) DEFAULT 'withdrawal', note VARCHAR(100) DEFAULT '')
	RETURNS VOID
	AS $$
	BEGIN
	
		INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to, note) VALUES(id_statement, amount, type_transaction, account_id, note);

	END;
	$$
	LANGUAGE plpgsql;
									   
--Test 
SELECT add_transaction(6, 7, 100, 'deposit');