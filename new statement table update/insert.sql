/*Insert CLient Data Here*/
INSERT INTO client VALUES(1,'Jim', 'Rocks', 'ILikeRocks');
INSERT INTO client VALUES(2,'Chloe', 'Joyce', 'idopds762');
INSERT INTO client VALUES(3,'Gavin', 'Morse', 'MorseCode9237');
INSERT INTO client VALUES(4,'Abbott', 'Bryce', 'dsjdnh78273');
INSERT INTO client VALUES(5,'Kara', 'Adams', 'shdhusdh3');
INSERT INTO client VALUES(6,'Breonia', 'Adams', 'Morsd7');
INSERT INTO client VALUES(7,'Anyssa', 'Morse', 'Morsdd6');
INSERT INTO client VALUES(8,'Gavin', 'Alcantar', 'uhd37');
INSERT INTO client VALUES(9,'Zackry', 'Alvarez', 'zswve98');
INSERT INTO client VALUES(10,'Parsa', 'Aldridge', 'USSUns9237');
INSERT INTO client VALUES(11,'Brooke', 'Ballard', 'sas2e9237');
INSERT INTO client VALUES(12,'Max', 'Ballard', 'sas2e9237');
INSERT INTO client VALUES(13,'Patrick', 'Ballard', 'sjdiohd982');
INSERT INTO client VALUES(14,'Suzy', 'Ballard', 'baguetteouioui92');

--Inserting phone numbers
INSERT INTO client_phone VALUES(1, 5477890568);
INSERT INTO client_phone VALUES(1, 5477895938);
INSERT INTO client_phone VALUES(2, 6137902375);
INSERT INTO client_phone VALUES(3, 5470998762);
INSERT INTO client_phone VALUES(4, 5477890568);
INSERT INTO client_phone VALUES(4, 5477890734);
INSERT INTO client_phone VALUES(6, 6137869263);

--Inserting addresses
INSERT INTO client_address VALUES(1)

/*Insert Account Data Here*/
INSERT INTO account (total_balance, account_type, num_cosigner, required_signatures) VALUES(130, 'savings', 3, 2);
INSERT INTO account (total_balance, account_type, num_cosigner, required_signatures) VALUES(3000, 'savings', 2, 1);
INSERT INTO account (total_balance, account_type, num_cosigner, required_signatures) VALUES(4500, 'checkings', 2, 2);
INSERT INTO account (total_balance, account_type, num_cosigner, required_signatures) VALUES(14500, 'savings', 1, 1);
INSERT INTO account (total_balance, account_type, num_cosigner, required_signatures) VALUES(500, 'checkings', 2, 2);

SELECT * FROM client_account;
SELECT * FROM account;
SELECT * FROM client;
/*Insert account_client Data Here*/
INSERT INTO client_account VALUES(1,4,TRUE,TRUE,TRUE);
INSERT INTO client_account VALUES(1,5,TRUE,FALSE,FALSE);
INSERT INTO client_account VALUES(2,4,FALSE,TRUE,FALSE);
INSERT INTO client_account VALUES(8,5,TRUE,TRUE,TRUE);
INSERT INTO client_account VALUES(9,5,TRUE,TRUE,TRUE);


/*Insert Statement Data Here*/
--need to add trigger or function to make sure that payer is assoicated with source account
INSERT INTO statements (note, source_account, initiator_client) VALUES('my statement', 4, 2);
INSERT INTO statements (note, source_account, initiator_client) VALUES('my statement', 5, 8);
INSERT INTO statements (note, source_account, initiator_client) VALUES('my statement', 4, 8);
INSERT INTO statements (note, source_account, initiator_client) VALUES('my statement', 4, 8);
INSERT INTO statements (note, source_account, initiator_client) VALUES('my statement', 4, 1);
INSERT INTO statements (note, source_account, initiator_client) VALUES('my statement', 4, 1);


--checking if payer who is associaetd with source account but does not have pay role can be inserted. It cannot. Trigger verify_payer works :)
INSERT INTO statements (note, source_account, initiator_client, payer, confirmed) VALUES('testStatement', 5, 9, 1, TRUE);
--checking if payer who is not associaetd with source account but has a pay role can be inserted. It cannot. Trigger verify_payer works :)
INSERT INTO statements (note, source_account, initiator_client, payer, confirmed) VALUES('testStatement', 5, 9, 10, TRUE);

--checking if intitator who is not associated with the statement source account can be inserted. It cannot. Trigger verify_initiator works :D
INSERT INTO statements (note, source_account, initiator_client, payer, confirmed) VALUES('testStatement', 5, 10, 8, TRUE);


DELETE FROM statements WHERE statement_id = 10;

/*Insert statement_confirmation data here*/
INSERT INTO statement_confirmation VALUES(2, 8, FALSE);
INSERT INTO statement_confirmation VALUES(1, 2, FALSE);
INSERT INTO statement_confirmation VALUES(4, 2, TRUE);
INSERT INTO statement_confirmation VALUES(9, 1, TRUE);

INSERT INTO statement_confirmation VALUES(4, 1, TRUE);

INSERT INTO statement_confirmation VALUES(8, 2, FALSE);
INSERT INTO statement_confirmation VALUES(13, 1, FALSE);
INSERT INTO statement_confirmation VALUES(16, 1, FALSE);

/*Insert statement_signer Data Here*/
--need to add triggers functions contraints that check if client id is asscoiated with the statemnts source account and has sign role
INSERT INTO statement_signer VALUES(1, 1, TRUE);
INSERT INTO statement_signer VALUES(5, 1, TRUE);
INSERT INTO statement_signer VALUES(2, 2, TRUE);
INSERT INTO statement_signer VALUES(8, 1, TRUE);
INSERT INTO statement_signer VALUES(1, 1, TRUE);
INSERT INTO statement_signer VALUES(2, 8, TRUE);
INSERT INTO statement_signer VALUES(2, 1, TRUE);
INSERT INTO statement_signer VALUES(2, 9, TRUE);
INSERT INTO statement_signer VALUES(13, 1, TRUE);
INSERT INTO statement_signer VALUES(16, 1, TRUE);



--testing if invalid signer can be inserted. it cannot. trigger 'verify_signer_trigger' works :D
INSERT INTO statement_signer VALUES(20, 8, TRUE);


/*Insert Transaction Data Here*/
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 10, 'deposit', 5);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 105, 'deposit', 6);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 10, 'withdrawal', 6);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 5, 'deposit', 4);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 10, 'deposit', 6);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(2, 101, 'deposit', 4);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(2, 10, 'deposit', 4);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(2, 100, 'withdrawal', 4);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(3, 100, 'withdrawal', 6);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(3, 1002, 'deposit', 6);

INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(2, 1002, 'deposit', 6);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(2, 2, 'withdrawal', 6);

INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(13, 1002, 'deposit', 5);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(13, 2, 'withdrawal', 1);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(13, 20, 'withdrawal', 1);

--testing if trasaction can be added if statement is confirmed. It cannot be added. Trigger works :D
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(4, 100, 'withdrawals', 4);

UPDATE statements
SET total_amount = 2
WHERE statements.statement_id = 5; 

UPDATE statement_signer
SET sign = TRUE
WHERE statement_signer.statement_id = 8 AND statement_signer.signer_id = 1; 

UPDATE statement_confirmation
SET payer_id = 1
WHERE statement_id = 1; 

DELETE FROM statement_signer
WHERE statement_signer.statement_id = 2;

UPDATE statement_confirmation
SET payer_id = 2
WHERE statement_confirmation.statement_id = 16; 

UPDATE transactions
SET amount = 12
WHERE statement_id = 2 and amount =11; 

DELETE FROM transactions
WHERE statement_id = 1;

DELETE FROM statements
WHERE statement_id=12;

DELETE FROM statement_confirmation
WHERE statement_id=12;

SELECT * FROM statements;
SELECT * FROM client_account;
SELECT * FROM statement_confirmation;
SELECT * FROM statement_signer;
SELECT * FROM transactions;
SELECT * FROM client;
SELECT * FROM client_phone;
SELECT * FROM client_address;
SELECT * FROM account;

DELETE FROM transactions;

