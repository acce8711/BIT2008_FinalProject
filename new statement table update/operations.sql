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

--Test - WORKS
SELECT add_user(15,'Bob','Rocks','124dh',611233,'6th avenue');

--2) Adding an account
CREATE OR REPLACE FUNCTION add_account(balance NUMERIC(10) DEFAULT 0, type_account VARCHAR(20) DEFAULT 'savings', cosigners INT DEFAULT 1, signatures INT DEFAULT 1)
	RETURNS VOID
	AS $$
	BEGIN
		INSERT INTO account (total_balance, account_type, num_cosigner, required_signatures) VALUES(balance, type_account, cosigners, signatures);
	END;
	$$
	LANGUAGE plpgsql;
	
--Test - WORKS
SELECT add_account();
SELECT add_account(1234,cosigners => 2, signatures => 2);

/* I don't think we need this
--Add access level of a certain user (assuming that user does not already have an asscoiation wit the account)
CREATE OR REPLACE FUNCTION add_access(user_id INT, account INT, sign_r BOOLEAN, view_r BOOLEAN, pay_r BOOLEAN)
	RETURNS VOID
	AS $$
	BEGIN
		INSERT INTO client_account VALUES(user_id, account, sign_r, view_r, pay_r);
	END;
	$$
	LANGUAGE plpgsql;

--Test - WORKS
SELECT add_access(14, 5, TRUE, FALSE, TRUE);
*/

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

--Test - WORKS
SELECT edit_access(14,6,FALSE,FALSE,FALSE);

--4) Creating a statement
CREATE OR REPLACE FUNCTION create_statement(source_acc INT, initiator INT, note VARCHAR(100), total_amount INT DEFAULT 0)
	RETURNS VOID
	AS $$
	BEGIN
		INSERT INTO statements(note, source_account, initiator_client, total_amount) VALUES(note, source_acc, initiator, total_amount);
	END;
	$$
	LANGUAGE plpgsql;
						
--Test - WORKS
SELECT create_statement(4,2,'hello');
SELECT create_statement(4,1,'hello2',10);

--5) Edit or remove a statement. Not sure what this wants

--6) Sign or unsign a statement. 
CREATE OR REPLACE FUNCTION sign_unsign_statement(id_statement INT, client_id INT, sign BOOLEAN)
	RETURNS VOID
	AS $$
	BEGIN
		INSERT INTO statements(note, source_account, initiator_client, total_amount) VALUES(note, source_acc, initiator, total_amount);
	END;
	$$
	LANGUAGE plpgsql;



									   
	
	
