/*I am not done yet :(*/

/*
Store the history of all operations on an account/statement including sign, unsign, pay and initiation.

Create tables to keep track of any account operations with a timestamp
1. Initiate statement audit table
2. Statement sign or unsign audit table
3. Statement pay audit table

*/
CREATE TABLE statement_initiate_audit(
    statement_id SERIAL, --initiated statement
	source_account INT, --account that statement is initiated on
	initiator_client INT,
    tstamp TIMESTAMP NOT NULL,
    FOREIGN KEY(source_account) REFERENCES account(account_id)ON DELETE CASCADE,
	FOREIGN KEY(initiator_client) REFERENCES client(client_id)ON DELETE CASCADE ,
	PRIMARY KEY(statement_id)	
)

CREATE TABLE statement_sign_audit(
    statement_id INT,
	signer_id INT,
	sign BOOLEAN DEFAULT FALSE,
    tstamp TIMESTAMP NOT NULL,
	FOREIGN KEY(statement_id) REFERENCES statements(statement_id)ON DELETE CASCADE,
	FOREIGN KEY(signer_id) REFERENCES client(client_id)ON DELETE CASCADE,
	PRIMARY KEY(statement_id, signer_id)
)

CREATE TABLE statement_pay_audit(
    statement_id INT,
	payer_id INT,
	confirmed BOOLEAN DEFAULT FALSE,
    tstamp TIMESTAMP NOT NULL,
	FOREIGN KEY(statement_id) REFERENCES statements(statement_id)ON DELETE CASCADE,
	FOREIGN KEY(payer_id) REFERENCES client(client_id)ON DELETE CASCADE,
	PRIMARY KEY(statement_id)	
)

/*
Create a function for each account/statement operation
1. initiate
2. sign/unsign
3. pay
*/


CREATE OR REPLACE FUNCTION log_statement_initiate_operation()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
BEGIN
    if (TG_OP = 'UPDATE') then
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
	  end if;
RETURN NEW;
END;
$$

CREATE OR REPLACE FUNCTION log_statement_sign_operation()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
BEGIN
    if (TG_OP = 'UPDATE') then
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
	  end if;
RETURN NEW;
END;
$$

CREATE OR REPLACE FUNCTION log_statement_pay_operation()
    RETURNS TRIGGER
    LANGUAGE plpgsql
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

/*Create a trigger for each table that will be used in account/statement operations*/

CREATE TRIGGER log_initiate_operation_trigger
AFTER INSERT
ON statements
FOR EACH ROW
EXECUTE PROCEDURE log_statement_initiate_operation();

CREATE TRIGGER log_sign_operation_trigger
AFTER UPDATE OF sign ON statement_signer
FOR EACH ROW
EXECUTE PROCEDURE log_statement_sign_operation();

CREATE TRIGGER log_pay_operation_trigger
AFTER UPDATE OF confirmed ON statement_confirmation
FOR EACH ROW
EXECUTE PROCEDURE log_statement_pay_operation();

/*• Store the log of all the changes to the roles of each client.*/
CREATE TABLE client_role_changes_audit(
    client_id INT,
    account_id INT,
    sign_role BOOLEAN NOT NULL,
    view_role BOOLEAN NOT NULL,
    pay_role BOOLEAN NOT NULL,
    tstamp TIMESTAMP NOT NULL,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE,
    FOREIGN KEY(account_id) REFERENCES account(account_id) ON DELETE CASCADE,
    PRIMARY KEY(client_id, account_id)
)

CREATE OR REPLACE FUNCTION log_client_role_change()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
BEGIN
    if (TG_OP = "UPDATE") then
       INSERT INTO client_role_changes (
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
    end if;
RETURN NEW;
END;
$$

CREATE TRIGGER client_role_change_trigger
AFTER UPDATE OF sign_role, view_role,pay_role
ON client_account
FOR EACH ROW
EXECUTE PROCEDURE log_client_role_change();

/*
Store the last time the tables are edited

Add new column called "lastModified" to each table to store last edit time
Make default value the current time
Make a trigger for each table on any update
Call function that will change the timestamp in lastModified when triggered
*/

/*Create Tables Here*/
CREATE TABLE client(
	client_id INT,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	client_password	VARCHAR(20) NOT NULL,
    lastModified TIMESTAMP DEFAULT now(),
	PRIMARY KEY(client_id)
);


--Create new alternate client table called "client_lM" (lM = lastModified)

CREATE TABLE client_lM(
	client_id INT,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	client_password	VARCHAR(20) NOT NULL,
    lastModified TIMESTAMP DEFAULT now(),
	PRIMARY KEY(client_id)
);

--Insert and select to test see the new lastModified column
INSERT INTO client_lM VALUES (1, 'Bob', 'Bobby', 'wowwhatagoodpassword555');
SELECT * from client_lM; --it shows the timestamp :)

--modify the client table 
UPDATE client_lM
SET client_password = 'changed'
WHERE client_id = 1;
SELECT * from client_lM WHERE client_id = 1;


CREATE TABLE client_phone(
	client_id INT,
	phone_numbr	NUMERIC (10, 0) NOT NULL,
    lastModified TIMESTAMP DEFAULT now(),
	FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE,
	PRIMARY KEY(client_id, phone_numbr)
);

CREATE TABLE client_address(
	client_id INT,
	address	VARCHAR (50) NOT NULL,
    lastModified TIMESTAMP DEFAULT now(),
	FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE,
	PRIMARY KEY(client_id, address)
);


CREATE TABLE account(
	account_id SERIAL,
	total_balance NUMERIC(10) DEFAULT 0,	
	account_type VARCHAR(20) DEFAULT 'savings' CHECK (account_type = 'savings' OR account_type = 'checkings'),
	num_cosigner INT DEFAULT 1,
	required_signatures INT DEFAULT 1 CHECK(required_signatures <= num_cosigner),
    lastModified TIMESTAMP DEFAULT now(),
	PRIMARY KEY(account_id)
);


CREATE TABLE client_account(
	client_id INT,
	account_id	INT,
	sign_role BOOLEAN NOT NULL,
	view_role BOOLEAN NOT NULL,
	pay_role BOOLEAN NOT NULL,
    lastModified TIMESTAMP DEFAULT now(),
	FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE,
	FOREIGN KEY(account_id) REFERENCES account (account_id) ON DELETE CASCADE ,
	PRIMARY KEY(client_id, account_id)	
);

CREATE TABLE statements(
	statement_id SERIAL,
	note VARCHAR(100) DEFAULT '',
	source_account INT, 
	initiator_client INT,
	total_amount NUMERIC(10,0) DEFAULT 0,
    lastModified TIMESTAMP DEFAULT now(),
	FOREIGN KEY(source_account) REFERENCES account(account_id)ON DELETE CASCADE,
	FOREIGN KEY(initiator_client) REFERENCES client(client_id)ON DELETE CASCADE ,
	PRIMARY KEY(statement_id)
);

CREATE TABLE statement_confirmation (
	statement_id INT,
	payer_id INT,
	confirmed BOOLEAN DEFAULT FALSE,
    lastModified TIMESTAMP DEFAULT now(),
	FOREIGN KEY(statement_id) REFERENCES statements(statement_id)ON DELETE CASCADE,
	FOREIGN KEY(payer_id) REFERENCES client(client_id)ON DELETE CASCADE,
	PRIMARY KEY(statement_id)
);

CREATE TABLE statement_signer(
	statement_id INT,
	signer_id INT,
	sign BOOLEAN DEFAULT FALSE,
    lastModified TIMESTAMP DEFAULT now(),
	FOREIGN KEY(statement_id) REFERENCES statements(statement_id)ON DELETE CASCADE,
	FOREIGN KEY(signer_id) REFERENCES client(client_id)ON DELETE CASCADE,
	PRIMARY KEY(statement_id, signer_id)
);

CREATE TABLE transactions(
	statement_id INT,
	amount NUMERIC(10) NOT NULL,
	transaction_type VARCHAR(30) DEFAULT 'withdrawal' CHECK (transaction_type = 'withdrawal' OR transaction_type = 'deposit'),
	transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	note VARCHAR(100) DEFAULT '',
	transaction_to INT,
    lastModified TIMESTAMP DEFAULT now(),
	FOREIGN KEY(statement_id) REFERENCES statements(statement_id) ON DELETE CASCADE,
	FOREIGN KEY(transaction_to) REFERENCES account(account_id) ON DELETE CASCADE,
	PRIMARY KEY(statement_id, amount, transaction_type, transaction_time, note, transaction_to)
);

/*Create function that changes the lastModified timestamp in each table*/
CREATE OR REPLACE FUNCTION update_timestamp()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
BEGIN
     NEW.lastModified = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$

/*

Create triggers for each table to call update_timestamp.

Need to use BEFORE UPDATE or else you will be put into infinite loop

*/
CREATE TRIGGER client_lastModified_update
BEFORE UPDATE ON
ON client
FOR EACH ROW
EXECUTE update_timestamp();

CREATE TRIGGER client_phone_lastModified_update
BEFORE UPDATE ON
ON client_phone
FOR EACH ROW
EXECUTE update_timestamp();

CREATE TRIGGER client_address_lastModified_update
BEFORE UPDATE ON
ON client_address
FOR EACH ROW
EXECUTE update_timestamp();

CREATE TRIGGER account_lastModified_update
BEFORE UPDATE ON
ON account
FOR EACH ROW
EXECUTE update_timestamp();

CREATE TRIGGER client_account_lastModified_update
BEFORE UPDATE ON
ON client_account
FOR EACH ROW
EXECUTE update_timestamp();

CREATE TRIGGER statements_lastModified_update
BEFORE UPDATE ON
ON statements
FOR EACH ROW
EXECUTE update_timestamp();

CREATE TRIGGER statement_signer_lastModified_update
BEFORE UPDATE ON
ON statement_signer
FOR EACH ROW
EXECUTE update_timestamp();

CREATE TRIGGER transactions_lastModified_update
BEFORE UPDATE ON
ON transactions
FOR EACH ROW
EXECUTE update_timestamp();

CREATE TRIGGER statement_confirmation_lastModified_update
BEFORE UPDATE ON
ON statement_confirmation
FOR EACH ROW
EXECUTE update_timestamp();



--testing with new table 






