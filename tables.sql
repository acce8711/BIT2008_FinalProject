/*Create Tables Here*/
CREATE TABLE client(
	client_id SERIAL,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	client_password	VARCHAR(20) NOT NULL,
	PRIMARY KEY(client_id)
);

CREATE TABLE client_phone(
	client_id INT,
	phone_numbr	NUMERIC (10, 0) NOT NULL,
	FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE,
	PRIMARY KEY(client_id)
);

CREATE TABLE client_address(
	client_id INT,
	address	VARCHAR (50) NOT NULL,
	FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE,
	PRIMARY KEY(client_id)
);

CREATE TABLE account(
	account_id SERIAL,
	total_balance NUMERIC(10) DEFAULT 0,	
	account_type VARCHAR(20) DEFAULT 'savings' CHECK (account_type = 'savings' OR account_type = 'checkings'),
	num_cosigner INT DEFAULT 1,
	required_signatures INT DEFAULT 1 CHECK(required_signatures <= num_cosigner),
	PRIMARY KEY(account_id)
);


CREATE TABLE client_account(
	client_id INT,
	account_id	INT,
	sign_role BOOLEAN NOT NULL,
	view_role BOOLEAN NOT NULL,
	pay_role BOOLEAN NOT NULL,
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
	confirmed BOOL DEFAULT FALSE,
	payer INT,
	FOREIGN KEY(source_account) REFERENCES account(account_id)ON DELETE CASCADE,
	FOREIGN KEY(initiator_client) REFERENCES client(client_id)ON DELETE CASCADE ,
	FOREIGN KEY(payer) REFERENCES client(client_id)ON DELETE CASCADE,
	PRIMARY KEY(statement_id)
);

CREATE TABLE statement_signer(
	statement_id INT,
	client_id INT,
	sign BOOLEAN DEFAULT FALSE,
	FOREIGN KEY(statement_id) REFERENCES statements(statement_id)ON DELETE CASCADE,
	FOREIGN KEY(client_id) REFERENCES client(client_id)ON DELETE CASCADE,
	PRIMARY KEY(statement_id, client_id)
);

CREATE TABLE transactions(
	statement_id INT,
	amount NUMERIC(10) DEFAULT 0,
	transaction_type VARCHAR(30) DEFAULT 'withdrawal' CHECK (transaction_type = 'withdrawal' OR transaction_type = 'deposit'),
	transaction_time TIMESTAMP NOT NULL,
	note VARCHAR(100) DEFAULT '',
	transaction_to INT,
	FOREIGN KEY(statement_id) REFERENCES statements(statement_id) ON DELETE CASCADE,
	FOREIGN KEY(statement_id) REFERENCES statements(statement_id) ON DELETE CASCADE,
	PRIMARY KEY(statement_id, amount, transaction_type, transaction_time, note, transaction_to)
);
