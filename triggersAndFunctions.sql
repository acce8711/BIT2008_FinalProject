
/* Triggers For Transactions */

/*
--Creating a trigger that checks if statement that the transaction is being added to is confirmed. If yes then, transaction will not be added
CREATE OR REPLACE FUNCTION check_if_confirmed_transactions()
	RETURNS TRIGGER
	AS $$
	BEGIN
	--if the trigger operation was INSERT
	IF (TG_OP = 'INSERT') THEN
		--Checking if the statement that the transactions is associated with is confirmed. If yes, then transaction will not be added to transactions and an error will be displayed to user
		IF ((SELECT statements.confirmed 
			FROM statements
			WHERE statements.statement_id = NEW.statement_id
		   ) = TRUE) THEN
		   RAISE EXCEPTION 'statement is not longer editable. transactions cannot be added/removed.';
		--if the statement that the transaction is associated with is not confirmed then the transaction will be added to transactions table
		ELSE
			RETURN NEW;
		END IF;
	--if the trigger operation was DELETE
	ELSE
		--Checking if the statement that the transactions is associated with is confirmed. If yes, then transaction will not be deleted from transactions and an error will be displayed to user
		IF ((SELECT statements.confirmed 
			FROM statements
			WHERE statements.statement_id = OLD.statement_id
			) = TRUE) THEN
			 RAISE EXCEPTION 'statement is not longer editable. transactions cannot be added/removed.';
		ELSE
			--if the statement that the transaction is associated with is not confirmed then the transaction will be removed from transactions table
			RETURN OLD;
		END IF;
	END IF;
	END;
	$$
	LANGUAGE plpgsql;
*/
--Creating a trigger that checks if statement that the transaction is being added to is confirmed. If yes then, transaction will not be inserted/deleted
CREATE OR REPLACE FUNCTION check_if_confirmed_transactions()
	RETURNS TRIGGER
	AS $$
	BEGIN
	--if the trigger operation was INSERT
	IF ((SELECT statements.confirmed 
		FROM statements
		WHERE statements.statement_id = COALESCE(NEW.statement_id, OLD.statement_id)
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


--Trigger for setting the statement total to the total of its transactions when new row in transactions is added
--Creating a function for trigger
CREATE OR REPLACE FUNCTION set_statement_total()
	RETURNS TRIGGER
	AS $$
	BEGIN
	--i think this if statement needs to be removed (need to check)
	IF (SELECT statements.confirmed 
		FROM statements
		WHERE statements.statement_id = NEW.statement_id
	   ) = TRUE THEN
	   RAISE NOTICE 'The Credit Card you have entered has expired.';
	END IF;
	-- if the transaction type is 'deposit' then transaction amount will be added to total statement amount.
	IF (NEW.transaction_type = 'Deposit') THEN
		UPDATE statements
		SET total_amount = statements.total_amount + NEW.amount
		WHERE statements.statement_id = NEW.statement_id;
		RETURN NEW;
	-- if the deposit type is 'withdrawal' then transaction amount will be deducted from total statement amount.
	ELSE
		UPDATE statements
		SET total_amount = statements.total_amount - NEW.amount
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


/*Triggers for statement_signer table*/

--Trigger verifes that an inserted signer is asssociated to the statemennt source account and has a sign role
CREATE OR REPLACE FUNCTION verify_signer()
	RETURNS TRIGGER
	AS $$
	BEGIN
	IF (NEW.statement_id IN (
		SELECT statements.statement_id 
		FROM statements
		WHERE statements.confirmed = TRUE)) THEN
		RAISE EXCEPTION 'statement can no longer be edited';
	END IF;
	--checking if the client(signer) is associated with the statement source account and has sign role
	IF(NEW.client_id IN (
		SELECT client_account.client_id
		FROM client_account
		WHERE client_account.sign_role = TRUE AND client_account.account_id = (
			SELECT statements.source_account
			FROM statements
			WHERE statements.statement_id = NEW.statement_id))
	 ) THEN
	    RETURN NEW;
	ELSE
		RAISE EXCEPTION 'invalid signer.';
	END IF;
	END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER verify_signer_trigger
BEFORE INSERT
ON statement_signer
FOR EACH ROW
EXECUTE PROCEDURE verify_signer();


/*Triggers for statements table*/

--Trigger that checks if entered payer actually has pay role and is asscoiated with the statement source account
CREATE OR REPLACE FUNCTION verify_payer()
	RETURNS TRIGGER
	AS $$
	BEGIN
	--checking if the payer is associated to the statement account and has the payer role
	IF (NEW.payer IN (
		SELECT client_account.client_id
		FROM client_account
		WHERE client_account.pay_role = TRUE AND client_account.account_id = NEW.source_account
	)) THEN
	  	RETURN NEW;
	ELSE
		RAISE EXCEPTION 'invalid payer.';
	END IF;
	END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER verify_payer_trigger
BEFORE INSERT
ON statements
FOR EACH ROW
EXECUTE PROCEDURE verify_payer();

--Trigger that checks if entered payer actually has pay role and is asscoiated with the statement source account
CREATE OR REPLACE FUNCTION verify_payer()
	RETURNS TRIGGER
	AS $$
	BEGIN
	--checking if the payer is associated to the statement source account and has the payer role
	IF (NEW.payer IN (
		SELECT client_account.client_id
		FROM client_account
		WHERE client_account.pay_role = TRUE AND client_account.account_id = NEW.source_account
	)) THEN
	  	RETURN NEW;
	ELSE
		RAISE EXCEPTION 'invalid payer.';
	END IF;
	END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER verify_payer_trigger
BEFORE INSERT
ON statements
FOR EACH ROW
EXECUTE PROCEDURE verify_payer();

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

--Trigger that checks if the statement is already cofnirmed or has at least one client who signed it. Needs more work
CREATE OR REPLACE FUNCTION statement_edit_delete()
	RETURNS TRIGGER
	AS $$
	DECLARE signature_count INT;
	BEGIN
    SELECT COUNT(*) INTO signature_count
	FROM statement_signer
	WHERE statement_signer.sign = TRUE AND statement_signer.statement_id = NEW.statement_id;
	IF (OLD.confirmed = TRUE) THEN
		RAISE EXCEPTION 'statement is confirmed. Cannot be deleted or edited';
	END IF;
	
	IF (NEW.confirmed = TRUE) THEN
		IF (signature_count >= (SELECT account.required_signatures
						   FROM account
						   WHERE coalesce(OLD.source_account, NEW.source_account) = account.account_id)
		   )THEN
			RETURN NEW;
		ELSE
			RAISE EXCEPTION 'not enough signatures';
		END IF;
	END IF;
	
	IF ( signature_count >= 1 AND TG_OP = 'UPDATE') THEN
			RAISE EXCEPTION 'statement cannot be edited. There is already at least one signature';	
	END IF;
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
EXECUTE PROCEDURE statement_edit_delete();

CREATE TRIGGER delete_statement_trigger
BEFORE DELETE
ON statements
FOR EACH ROW
EXECUTE PROCEDURE statement_edit_delete();

(SELECT COUNT(*) AS signature_count
		FROM statement_signer
		WHERE statement_signer.statement_id = 1 AND statement_signer.sign = TRUE);
		
/*		
CREATE OR REPLACE FUNCTION confirm_statement()
	RETURNS TRIGGER
	AS $$
	DECLARE signature_count INT;
	BEGIN
	SELECT COUNT(*) INTO signature_count
	FROM statement_signer
	WHERE statement_signer.sign = TRUE AND statement_signer.statement_id = NEW.statement_id;
    IF (OLD.confirmed = TRUE) THEN
		RAISE EXCEPTION 'statement is already confirmed';	
	END IF;
	IF (signature_count >= (SELECT account.required_signatures
						   FROM account
						   WHERE OLD.source_account = account.account_id)
	   )THEN
	    RETURN NEW;
	ELSE
		RAISE EXCEPTION 'not enough signatures';
	END IF;
	END;
	$$
	LANGUAGE plpgsql;	
		
CREATE TRIGGER confirm_statement_trigger
BEFORE UPDATE OF confirmed
ON statements
FOR EACH ROW
EXECUTE PROCEDURE confirm_statement();
*/
		

