
/* Triggers For Transactions */

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

SELECT client_account.client_id
FROM client_account
WHERE client_account.sign_role = TRUE AND client_account.account_id = 5;
