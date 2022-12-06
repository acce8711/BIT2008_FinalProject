/*I am not done yet :(*/

CREATE TABLE account_sign_audit(
    client_id INT,
    account_id INT,
    sign BOOLEAN NOT NULL,
    tstamp TIMESTAMP NOT NULL,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE,
	FOREIGN KEY(account_id) REFERENCES account (account_id) ON DELETE CASCADE ,
	PRIMARY KEY(client_id, account_id)	
)


CREATE TABLE account_pay_audit(
    client_id INT,
    account_id INT,
    amount NUMERIC(10) DEFAULT 0,
    tstamp TIMESTAMP NOT NULL,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE,
	FOREIGN KEY(account_id) REFERENCES account (account_id) ON DELETE CASCADE ,
	PRIMARY KEY(client_id, account_id)	
)

CREATE TABLE account_initiate_audit(
    initiator INT,
    account_id INT,
    tstamp TIMESTAMP NOT NULL,
    FOREIGN KEY(initiator) REFERENCES client(client_id) ON DELETE CASCADE,
	FOREIGN KEY(account_id) REFERENCES account (account_id) ON DELETE CASCADE ,
	PRIMARY KEY(client_id, account_id)	
)

CREATE TABLE client_role_changes(
    client_id INT,
    account_id INT,
    sign BOOLEAN NOT NULL,
    view BOOLEAN NOT NULL,
    pay BOOLEAN NOT NULL,
    tstamp TIMESTAMP NOT NULL,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE,
    FOREIGN KEY(account_id) REFERENCES account(account_id) ON DELETE CASCADE,
    PRIMARY KEY(client_id, account_id)
)

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

--add functions to make sure that initiator is a user of the source account
CREATE TABLE statements(
	statement_id SERIAL,
	note VARCHAR(100) DEFAULT '',
	source_account INT, 
	initiator_client INT,
	--create trigegr to prevent user from enetering an amount that is not 0
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

/*Hmmm might need to edit transactions table because currently duplicate values are allowed*/
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
 NEW.lastModified = now();
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










