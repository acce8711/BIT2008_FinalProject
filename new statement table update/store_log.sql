/*
Store the history of all operations on an account/statement including sign, unsign, pay and initiation.

Create tables to keep track of any account operations with a timestamp
1. Initiate statement audit table
2. Statement sign or unsign audit table
3. Statement pay audit table

*/
CREATE TABLE statement_initiate_audit(
	audit_id SERIAL,
    statement_id INT,
	source_account INT,
	initiator_client INT,
    tstamp TIMESTAMP NOT NULL,
    FOREIGN KEY(statement_id) REFERENCES statements(statement_id)ON DELETE CASCADE,
    FOREIGN KEY(source_account) REFERENCES account(account_id)ON DELETE CASCADE,
	FOREIGN KEY(initiator_client) REFERENCES client(client_id)ON DELETE CASCADE,
	PRIMARY KEY(audit_id)	
);

CREATE TABLE statement_sign_audit(
	audit_id SERIAL,
    statement_id INT,
	signer_id INT,
	sign BOOLEAN DEFAULT FALSE,
    tstamp TIMESTAMP NOT NULL,
	FOREIGN KEY(statement_id) REFERENCES statements(statement_id)ON DELETE CASCADE,
	FOREIGN KEY(signer_id) REFERENCES client(client_id)ON DELETE CASCADE,
	PRIMARY KEY(audit_id)
);

CREATE TABLE statement_pay_audit(
	audit_id SERIAL,
    statement_id INT,
	payer_id INT,
	confirmed BOOLEAN DEFAULT FALSE,
    tstamp TIMESTAMP NOT NULL,
	FOREIGN KEY(statement_id) REFERENCES statements(statement_id)ON DELETE CASCADE,
	FOREIGN KEY(payer_id) REFERENCES client(client_id)ON DELETE CASCADE,
	PRIMARY KEY(audit_id)	
);



SELECT * FROM statement_initiate_audit;
SELECT * FROM statement_sign_audit;
SELECT * FROM statement_pay_audit;
SELECT * FROM client_role_changes_audit;


/*
Create a function for each account/statement operation
1. initiate
2. sign/unsign
3. pay
*/

CREATE OR REPLACE FUNCTION log_statement_initiate_operation()
RETURNS TRIGGER
AS $$
BEGIN

INSERT INTO statement_initiate_audit(
statement_id,
source_account,
initiator_client,
tstamp
)
VALUES(
NEW.statement_id,
NEW.source_account,
NEW.initiator_client,
CURRENT_TIMESTAMP
);

RETURN NEW;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION log_statement_sign_operation()
    RETURNS TRIGGER
AS $$
BEGIN
   
INSERT INTO statement_sign_audit(
statement_id,
signer_id,
sign,
tstamp
)
VALUES(
NEW.statement_id,
NEW.signer_id,
NEW.sign,
CURRENT_TIMESTAMP  
);
	  
RETURN NEW;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION log_statement_pay_operation()
    RETURNS TRIGGER
AS $$
BEGIN
    if (TG_OP = 'UPDATE') then
       INSERT INTO statement_pay_audit(
        statement_id,
        payer_id,
        confirmed,
        tstamp
       )
       VALUES(
        NEW.statement_id,
        NEW.payer_id,
        NEW.confirmed,
        CURRENT_TIMESTAMP
       );
       end if;
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

------Create a trigger for each table that will be used in account/statement operations--------------------

CREATE TRIGGER log_initiate_operation_trigger
AFTER INSERT
ON statements
FOR EACH ROW
EXECUTE PROCEDURE log_statement_initiate_operation();

CREATE TRIGGER log_sign_operation_update_trigger
AFTER UPDATE OF sign 
ON statement_signer
FOR EACH ROW
EXECUTE PROCEDURE log_statement_sign_operation();

CREATE TRIGGER log_sign_operation_insert_trigger
AFTER INSERT 
ON statement_signer
FOR EACH ROW
EXECUTE PROCEDURE log_statement_sign_operation();

CREATE TRIGGER log_pay_operation_update_trigger
AFTER UPDATE OF confirmed
ON statement_confirmation
FOR EACH ROW
EXECUTE PROCEDURE log_statement_pay_operation();

CREATE TRIGGER log_pay_operation_insert_trigger
AFTER INSERT 
ON statement_confirmation
FOR EACH ROW
EXECUTE PROCEDURE log_statement_pay_operation();


--------Store the log of all the changes to the roles of each client----------------------------------------
CREATE TABLE client_role_changes_audit(
	audit_id SERIAL,
    client_id INT,
    account_id INT,
    sign_role BOOLEAN NOT NULL,
    view_role BOOLEAN NOT NULL,
    pay_role BOOLEAN NOT NULL,
    tstamp TIMESTAMP NOT NULL,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE,
    FOREIGN KEY(account_id) REFERENCES account(account_id) ON DELETE CASCADE,
    PRIMARY KEY(audit_id)
);


CREATE OR REPLACE FUNCTION log_client_role_change()
RETURNS TRIGGER
AS $$
BEGIN
    
INSERT INTO client_role_changes_audit (
client_id,
account_id,
sign_role,
view_role,
pay_role,
tstamp 
)
VALUES(
NEW.client_id,
NEW.account_id,
NEW.sign_role,
NEW.view_role,
NEW.pay_role,
CURRENT_TIMESTAMP
);   
RETURN NEW;

END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER client_role_change_trigger
AFTER UPDATE OF sign_role, view_role, pay_role
ON client_account
FOR EACH ROW
EXECUTE PROCEDURE log_client_role_change();


---------------------Store the last time the tables are edited------------------------------------------------------

--Create a function that changes the lastModified timestamp in each table--------------------------------

CREATE OR REPLACE FUNCTION update_timestamp()
    RETURNS TRIGGER
AS $$
BEGIN
    NEW.lastModified = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

--Create triggers for each table to call update_timestamp-----------------------------------------

CREATE TRIGGER client_lastModified_update
BEFORE UPDATE
ON client
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER client_phone_lastModified_update
BEFORE UPDATE
ON client_phone
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER client_address_lastModified_update
BEFORE UPDATE
ON client_address
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER account_lastModified_update
BEFORE UPDATE
ON account
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER client_account_lastModified_update
BEFORE UPDATE
ON client_account
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER statements_lastModified_update
BEFORE UPDATE
ON statements
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER statement_signer_lastModified_update
BEFORE UPDATE
ON statement_signer
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER transactions_lastModified_update
BEFORE UPDATE
ON transactions
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

CREATE TRIGGER statement_confirmation_lastModified_update
BEFORE UPDATE
ON statement_confirmation
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

-------------------------------Test with client table insertion---------------------------------------------
INSERT INTO client VALUES (15, 'Please', 'Work', 'before');
SELECT * from client WHERE client_id = 15; --timestamp is 11:34:45
--Update the entry
UPDATE client
SET client_password = 'after'
WHERE client_id = 15;
SELECT * from client WHERE client_id = 15;--timestamp is 11:38:20. It works :D.
------------------------------------------------------------------------------------------------------------
