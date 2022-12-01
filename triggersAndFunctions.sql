
/* Triggers :) */

--Creating a trigger that checks if statement that the transaction is being added to is confirmed. If yes then, transaction will not be added
CREATE OR REPLACE FUNCTION check_if_confirmed_transactions()
	RETURNS TRIGGER
	AS $$
	BEGIN
	IF ((SELECT statements.confirmed 
		FROM statements
		WHERE statements.statement_id = NEW.statement_id
	   ) = TRUE) THEN
	   RAISE EXCEPTION 'transactions cannot be added, statement is not longer editable';
	ELSE
		RETURN NEW;
	END IF;
	END;
	$$
	LANGUAGE plpgsql;

CREATE TRIGGER check_if_confirmed_transactions_trigger
BEFORE INSERT
ON transactions
FOR EACH ROW
EXECUTE PROCEDURE check_if_confirmed_transactions();


--Trigger for setting the statement total to the total of its transactions when new row in transactions is added
--Creating a function for trigger
CREATE OR REPLACE FUNCTION set_statement_total()
	RETURNS TRIGGER
	AS $$
	BEGIN
	IF (SELECT statements.confirmed 
		FROM statements
		WHERE statements.statement_id = NEW.statement_id
	   ) = TRUE THEN
	   RAISE NOTICE 'The Credit Card you have entered has expired.'
       ROLLBACK TRANSACTION
	--checking if the transaction type is 'deposit'
	IF (NEW.transaction_type = 'Deposit') THEN
		UPDATE statements
		SET total_amount = statements.total_amount + NEW.amount
		WHERE statements.statement_id = NEW.statement_id;
		RETURN NEW;
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



