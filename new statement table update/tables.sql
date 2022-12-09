CREATE TABLE client(
	client_id INT,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	client_password	VARCHAR(50) NOT NULL,
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
	address	VARCHAR (100) NOT NULL,
    lastModified TIMESTAMP DEFAULT now(),
	FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE,
	PRIMARY KEY(client_id, address)
);


CREATE TABLE account(
	account_id INT,
	total_balance NUMERIC(10,2) DEFAULT 0,	
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
	statement_id INT,
	note VARCHAR(100) DEFAULT '',
	source_account INT, 
	initiator_client INT,
	total_amount NUMERIC(10,2) DEFAULT 0,
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
	amount NUMERIC(10,2) NOT NULL,
	transaction_type VARCHAR(30) DEFAULT 'withdrawal' CHECK (transaction_type = 'withdrawal' OR transaction_type = 'deposit'),
	transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	note VARCHAR(100) DEFAULT '',
	transaction_to INT,
    lastModified TIMESTAMP DEFAULT now(),
	FOREIGN KEY(statement_id) REFERENCES statements(statement_id) ON DELETE CASCADE,
	FOREIGN KEY(transaction_to) REFERENCES account(account_id) ON DELETE CASCADE,
	PRIMARY KEY(statement_id, amount, transaction_type, transaction_time, note, transaction_to)
);
