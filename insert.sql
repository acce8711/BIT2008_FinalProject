/*Insert CLient Data Here*/
INSERT INTO client (first_name, last_name, client_password) VALUES('Jim', 'Rocks', 'ILikeRocks');
INSERT INTO client (first_name, last_name, client_password) VALUES('Chloe', 'Joyce', 'idopds762');
INSERT INTO client (first_name, last_name, client_password) VALUES('Gavin', 'Morse', 'MorseCode9237');
INSERT INTO client (first_name, last_name, client_password) VALUES('Abbott', 'Bryce', 'dsjdnh78273');
INSERT INTO client (first_name, last_name, client_password) VALUES('Kara', 'Adams', 'shdhusdh3');
INSERT INTO client (first_name, last_name, client_password) VALUES('Breonia', 'Adams', 'Morsd7');
INSERT INTO client (first_name, last_name, client_password) VALUES('Anyssa', 'Morse', 'Morsdd6');
INSERT INTO client (first_name, last_name, client_password) VALUES('Gavin', 'Alcantar', 'uhd37');
INSERT INTO client (first_name, last_name, client_password) VALUES('Zackry', 'Alvarez', 'zswve98');
INSERT INTO client (first_name, last_name, client_password) VALUES('Parsa', 'Aldridge', 'USSUns9237');
INSERT INTO client (first_name, last_name, client_password) VALUES('Brooke', 'Ballard', 'sas2e9237');
INSERT INTO client (first_name, last_name, client_password) VALUES('Max', 'Ballard', 'sas2e9237');
INSERT INTO client (first_name, last_name, client_password) VALUES('Patrick', 'Ballard', 'sjdiohd982');
INSERT INTO client (first_name, last_name, client_password) VALUES('Suzy', 'Ballard', 'baguetteouioui92');

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
/*Insert account_client Data Here*/
INSERT INTO client_account VALUES(1,4,TRUE,TRUE,TRUE);
INSERT INTO client_account VALUES(1,5,TRUE,FALSE,FALSE);
INSERT INTO client_account VALUES(2,4,FALSE,TRUE,FALSE);
INSERT INTO client_account VALUES(8,5,TRUE,TRUE,TRUE);
INSERT INTO client_account VALUES(9,5,TRUE,TRUE,TRUE);
INSERT INTO client_account VALUES(10,6,TRUE,TRUE,TRUE);
INSERT INTO client_account VALUES(11,6,TRUE,FALSE,FALSE);

/*Insert Statement Data Here*/
--need to add trigger or function to make sure that payer is assoicated with source account
INSERT INTO statements (note, source_account, initiator_client, payer) VALUES('my statement', 4, 2, 1);
INSERT INTO statements (note, source_account, initiator_client, payer) VALUES('my statement', 5, 8, 8);

/*Insert statement_signer Data Here*/
--need to add triggers functions contraints that check if client id is asscoiated with the statemnts source account and has sign role
INSERT INTO statement_signer VALUES(1, 1, TRUE);
INSERT INTO statement_signer VALUES(2, 8, FALSE);
INSERT INTO statement_signer VALUES(2, 1, FALSE);

/*Insert Transaction Data Here*/
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 10, 'deposit', 5);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 105, 'deposit', 6);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 10, 'withdrawal', 6);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(2, 5, 'deposit', 4);



SELECT * FROM client;

