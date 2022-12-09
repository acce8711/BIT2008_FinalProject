--Statement table triggers
CREATE OR REPLACE FUNCTION statement_edit_delete()
	RETURNS TRIGGER
	AS $$
	DECLARE signature_count INT;
	BEGIN
	
    SELECT COUNT(*) INTO signature_count
	FROM statement_signer
	WHERE statement_signer.sign = TRUE AND statement_signer.statement_id = NEW.statement_id;
	
	--checking if the statement is already confirmed
	IF ((SELECT statement_confirmation.confirmed
		FROM statement_confirmation
		WHERE statement_confirmation.statement_id = COALESCE(NEW.statement_id, OLD.statement_id)) = TRUE) THEN
		RAISE EXCEPTION 'Statement is confirmed. Cannot be deleted or edited';	
	END IF;
	
	--checking if the trigger operation was UPDATE and the statement already has at least one signature
	IF ( signature_count >= 1 AND TG_OP = 'UPDATE') THEN
			RAISE EXCEPTION 'Statement cannot be edited. There is already at least one signature';	
	END IF;
	
	--Returning NEW or OLD depending on whether the trgger operation was UPDATE or DELETE
	IF (TG_OP = 'UPDATE') THEN
		RETURN NEW;
	ELSE
		RETURN OLD;
	END IF;
	
	END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER edit_statement_trigger
BEFORE UPDATE
ON statements
FOR EACH ROW
--adding pg_trigger_depth to prevent error when statement total is updated due to transactions
WHEN (pg_trigger_depth() < 1)
EXECUTE PROCEDURE statement_edit_delete();


CREATE TRIGGER delete_statement_trigger
BEFORE DELETE
ON statements
FOR EACH ROW
EXECUTE PROCEDURE statement_edit_delete();


--Trigger that checks if the intitaor is associated with the statement source account
CREATE OR REPLACE FUNCTION verify_initiator()
	RETURNS TRIGGER
	AS $$
	BEGIN
	
	--checking if the initiator is associated to the statement account and has the payer role
	IF (NEW.initiator_client IN (
		SELECT client_account.client_id
		FROM client_account
		WHERE client_account.account_id = NEW.source_account
	)) THEN
	  	RETURN NEW;
	ELSE
		RAISE EXCEPTION 'invalid initiator.';
	END IF;
	
	END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER verify_initiator_trigger
BEFORE INSERT
ON statements
FOR EACH ROW
EXECUTE PROCEDURE verify_initiator();

--Statement_confirmation table triggers

--Trigger that checks if entered payer actually has pay role and is asscoiated with the statement source account
CREATE OR REPLACE FUNCTION verify_payer()
	RETURNS TRIGGER
	AS $$
	BEGIN
	
	--checking if the payer is associated to the statement source account and has the payer role
	IF (NEW.payer_id IN (
		SELECT client_account.client_id
		FROM client_account
		WHERE client_account.pay_role = TRUE 
		AND client_account.account_id = (
			SELECT statements.source_account
			FROM statements
			WHERE statements.statement_id = NEW.statement_id)
	)) THEN
	  	RETURN NEW;
	ELSE
		RAISE EXCEPTION 'invalid payer.';
	END IF;
	
	END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER verify_payer_insert_trigger
BEFORE INSERT
ON statement_confirmation
FOR EACH ROW
EXECUTE PROCEDURE verify_payer();

CREATE TRIGGER verify_payer_update_trigger
BEFORE UPDATE
ON statement_confirmation
FOR EACH ROW
EXECUTE PROCEDURE verify_payer();

CREATE OR REPLACE FUNCTION confirm_statement()
	RETURNS TRIGGER
	AS $$
	DECLARE signature_count INT;
	BEGIN
	
    SELECT COUNT(*) INTO signature_count
	FROM statement_signer
	WHERE statement_signer.sign = TRUE AND statement_signer.statement_id = NEW.statement_id;
	
	--checking if the statement is already confirmed
	IF (OLD.confirmed = TRUE) THEN
		RAISE EXCEPTION 'statement is already confirmed.';
	END IF;
	
	IF(signature_count <
	  (SELECT account.required_signatures
	  FROM account
	  WHERE account_id = (SELECT statements.source_account
						 FROM statements
						 WHERE statements.statement_id = NEW.statement_id)
	  ) AND NEW.confirmed = TRUE)THEN
	 	RAISE EXCEPTION 'not enough signatures.';
	END IF;
	RETURN NEW;
	END;
	$$
	LANGUAGE plpgsql;
	
CREATE TRIGGER confirm_statement_trigger
BEFORE UPDATE
ON statement_confirmation
FOR EACH ROW
EXECUTE PROCEDURE confirm_statement();

CREATE TRIGGER confirm_statement_insert_trigger
BEFORE INSERT
ON statement_confirmation
FOR EACH ROW
EXECUTE PROCEDURE confirm_statement();


--Trigger will update from and to accounts once statement is confirmed
CREATE OR REPLACE FUNCTION update_account_balance()
	RETURNS TRIGGER
	AS $$
	DECLARE transaction_to_process RECORD; from_account INT; total INT; 
	BEGIN
	
	IF (NEW.confirmed = FALSE) THEN
		RETURN NULL;
   	END IF;
	
	SELECT statements.source_account INTO from_account
	FROM statements
	WHERE statements.statement_id = NEW.statement_id;
	
	SELECT statements.total_amount INTO total
	FROM statements
	WHERE statements.statement_id = NEW.statement_id;
	
	UPDATE account
	SET total_balance = account.total_balance + total
	WHERE account.account_id = from_account;
	
	FOR transaction_to_process IN (SELECT *
								  FROM transactions
								  WHERE transactions.statement_id = NEW.statement_id)
	LOOP
	IF (transaction_to_process.transaction_type = 'deposit') THEN
		UPDATE account
		SET total_balance = account.total_balance + transaction_to_process.amount
		WHERE account.account_id = transaction_to_process.transaction_to;
	ELSE 
		UPDATE account
		SET total_balance = account.total_balance - transaction_to_process.amount
		WHERE account.account_id = transaction_to_process.transaction_to;
	END IF;
	END LOOP;
	
	RETURN NULL;
	
	END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER update_account_balance_trigger
AFTER UPDATE
ON statement_confirmation
FOR EACH ROW
EXECUTE PROCEDURE update_account_balance();

CREATE TRIGGER update_account_balance_insert_trigger
AFTER INSERT
ON statement_confirmation
FOR EACH ROW
EXECUTE PROCEDURE update_account_balance();


--Statement_signer table triggers

--Trigger verifes that an inserted signer is asssociated to the statemennt source account, has a sign role and the statement is not already cnfirmed
CREATE OR REPLACE FUNCTION verify_signer()
	RETURNS TRIGGER
	AS $$
	BEGIN
	
	IF (NEW.statement_id IN (
		SELECT statement_confirmation.statement_id 
		FROM statement_confirmation
		WHERE statement_confirmation.confirmed = TRUE)) THEN
		RAISE EXCEPTION 'signer cannot be added. statement can no longer be edited';
	END IF;
	
	--checking if the client(signer) is associated with the statement source account and has sign role
	IF(NEW.signer_id IN (
		SELECT client_account.client_id
		FROM client_account
		WHERE client_account.sign_role = TRUE AND client_account.account_id = (
			SELECT statements.source_account
			FROM statements
			WHERE statements.statement_id = NEW.statement_id))
	 ) THEN
	    RETURN NEW;
	ELSE
		RAISE EXCEPTION 'signer cannot be added/changed. user does not have sign role or is not associated with the source account';
	END IF;
	
	END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER verify_signer_trigger
BEFORE INSERT
ON statement_signer
FOR EACH ROW
EXECUTE PROCEDURE verify_signer();

CREATE TRIGGER verify_signer__update_trigger
BEFORE UPDATE
ON statement_signer
FOR EACH ROW
EXECUTE PROCEDURE verify_signer();

CREATE OR REPLACE FUNCTION sign_unsign()
	RETURNS TRIGGER
	AS $$
	BEGIN
	IF (NEW.statement_id IN (
		SELECT statement_confirmation.statement_id 
		FROM statement_confirmation
		WHERE statement_confirmation.confirmed = TRUE)) THEN
		RAISE EXCEPTION 'cannot sign/unsign. statement can no longer be edited';
	END IF;
	RETURN NEW;
	END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER sign_unsign_trigger
BEFORE UPDATE
ON statement_signer
FOR EACH ROW
EXECUTE PROCEDURE sign_unsign();

CREATE TRIGGER sign_unsign_insert_trigger
BEFORE INSERT
ON statement_signer
FOR EACH ROW
EXECUTE PROCEDURE sign_unsign();

CREATE OR REPLACE FUNCTION remove_signer()
	RETURNS TRIGGER
	AS $$
	BEGIN
	IF (OLD.statement_id IN (
		SELECT statement_confirmation.statement_id 
		FROM statement_confirmation
		WHERE statement_confirmation.confirmed = TRUE)) THEN
		RAISE EXCEPTION 'signer could not be removed. statement can no longer be edited';
	END IF;
	RETURN OLD;
	END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER remove_signer_trigger
BEFORE DELETE
ON statement_signer
FOR EACH ROW
EXECUTE PROCEDURE remove_signer();

--Transactions table triggers

--Creating a trigger that checks if statement that the transaction is being added to is confirmed. If yes then, transaction will not be inserted/deleted
CREATE OR REPLACE FUNCTION check_if_confirmed_transactions()
	RETURNS TRIGGER
	AS $$
	BEGIN
	IF (TG_OP = 'UPDATE') THEN
		RAISE EXCEPTION 'transactions cannot be edited';
	END IF;
	--checking if the statement that the transaction is being added to is confirmed
	IF ((SELECT statement_confirmation.confirmed 
		FROM statement_confirmation
		WHERE statement_confirmation.statement_id = COALESCE(NEW.statement_id, OLD.statement_id)
	   ) = TRUE) THEN
	   RAISE EXCEPTION 'statement is not longer editable. transactions cannot be added/removed.';
	--if the statement that the transaction is associated with is not confirmed then the transaction will be added to transactions table
	ELSE
		RETURN COALESCE(NEW, OLD);
	END IF;
	END;
	$$
	LANGUAGE plpgsql;
--Trigger to check if transaction can be inserted
CREATE TRIGGER can_transaction_insert_trigger
BEFORE INSERT
ON transactions
FOR EACH ROW
EXECUTE PROCEDURE check_if_confirmed_transactions();

--Trigger to check if transaction can be deleted
CREATE TRIGGER can_transaction_delete_trigger
BEFORE DELETE
ON transactions
FOR EACH ROW
EXECUTE PROCEDURE check_if_confirmed_transactions();

--Trigger to prevent transactions from getting updated (assuming that transactions can not be edited, only inserted or removed)
CREATE TRIGGER can_transaction_update_trigger
BEFORE UPDATE
ON transactions
FOR EACH ROW
EXECUTE PROCEDURE check_if_confirmed_transactions();


--Trigger for setting the statement total to the total of its transactions when new row in transactions is added
CREATE OR REPLACE FUNCTION set_statement_total()
	RETURNS TRIGGER
	AS $$
	BEGIN
	
	-- if the transaction type is 'deposit' then transaction amount will be added to total statement amount.
	IF (NEW.transaction_type = 'deposit') THEN
		UPDATE statements
		SET total_amount = statements.total_amount - NEW.amount
		WHERE statements.statement_id = NEW.statement_id;
		RETURN NEW;
	-- if the deposit type is 'withdrawal' then transaction amount will be deducted from total statement amount.
	ELSE
		UPDATE statements
		SET total_amount = statements.total_amount + NEW.amount
		WHERE statements.statement_id = NEW.statement_id;
		RETURN NEW;
	END IF;
	
	END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER set_statement_total_trigger
AFTER INSERT
ON transactions
FOR EACH ROW
EXECUTE PROCEDURE set_statement_total();


--Trigger for setting the statement total to the total of its transactions when new row in transactions is deleted
CREATE OR REPLACE FUNCTION set_statement_total_delete()
	RETURNS TRIGGER
	AS $$
	BEGIN
	
	-- if the transaction type is 'deposit' then transaction amount will be added to total statement amount.
	IF (OLD.transaction_type = 'deposit') THEN
		UPDATE statements
		SET total_amount = statements.total_amount + OLD.amount
		WHERE statements.statement_id = OLD.statement_id;
		RETURN OLD;
	-- if the deposit type is 'withdrawal' then transaction amount will be deducted from total statement amount.
	ELSE
		UPDATE statements
		SET total_amount = statements.total_amount - OLD.amount
		WHERE statements.statement_id = OLD.statement_id;
		RETURN OLD;
	END IF;
	
	END;
	$$
	LANGUAGE plpgsql;
	
CREATE TRIGGER set_statement_total_delete_trigger
AFTER DELETE
ON transactions
FOR EACH ROW
EXECUTE PROCEDURE set_statement_total_delete();





