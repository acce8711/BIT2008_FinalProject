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
		RAISE EXCEPTION 'statement is confirmed. Cannot be deleted or edited';	
	END IF;
	
	--checking if the trigger operation was UPDATE and the statement already has at least one signature
	IF ( signature_count >= 1 AND TG_OP = 'UPDATE') THEN
			RAISE EXCEPTION 'statement cannot be edited. There is already at least one signature';	
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
	  ))THEN
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
	DECLARE from_account INT; total INT;
	BEGIN
	
	SELECT statements.source_account INTO from_account
	FROM statements
	WHERE statements.statement_id = NEW.statement_id;
	
	SELECT statements.total_amount INTO total
	FROM statements
	WHERE statements.statement_id = NEW.statement_id;
	
	IF (NEW.confirmed = FALSE) THEN
		RETURN NULL;
   	END IF;
	
	UPDATE account
	SET account.total_balance = account.total_balance + total
	WHERE account.account_id = from_account;
	RETURN NULL;
	
	END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER update_account_balance_trigger
AFTER UPDATE
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
		RAISE EXCEPTION 'signer cannot be added. user does not have sign role.';
	END IF;
	
	END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER verify_signer_trigger
BEFORE INSERT
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



