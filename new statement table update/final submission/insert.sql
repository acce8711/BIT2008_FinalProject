--NOTE: run tables.sql, store_log.sql, triggers.sql before running the insert statements

--Inserting client data
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

--Inserting client_phone data
INSERT INTO client_phone VALUES(1, 5477890568);
INSERT INTO client_phone VALUES(1, 5477895938);
INSERT INTO client_phone VALUES(2, 6137902375);
INSERT INTO client_phone VALUES(3, 5470998762);
INSERT INTO client_phone VALUES(4, 5477890568);
INSERT INTO client_phone VALUES(4, 5477890734);
INSERT INTO client_phone VALUES(6, 6137869263);
INSERT INTO client_phone VALUES(7, 6131230007);
INSERT INTO client_phone VALUES(8, 6131230008);
INSERT INTO client_phone VALUES(9, 6131230009);
INSERT INTO client_phone VALUES(10, 6131230010);
INSERT INTO client_phone VALUES(11, 6131230011);
INSERT INTO client_phone VALUES(12, 6131230012);
INSERT INTO client_phone VALUES(13, 6131230013);
INSERT INTO client_phone VALUES(14, 6131230014);


--Inserting client_address data
INSERT INTO client_address VALUES(1, '100 Place Rd');
INSERT INTO client_address VALUES(2, '101 Rainbow Rd');
INSERT INTO client_address VALUES(3, '102 Rose Rd');
INSERT INTO client_address VALUES(4, '103 Lonely Rd');
INSERT INTO client_address VALUES(5, '104 Rocky Rd');
INSERT INTO client_address VALUES(6, '105 Slippery Rd');
INSERT INTO client_address VALUES(7, '106 Bumpy Rd');
INSERT INTO client_address VALUES(8, '107 Narrow Rd');
INSERT INTO client_address VALUES(9, '108 Broken Rd');
INSERT INTO client_address VALUES(10, '109 Super Rd');
INSERT INTO client_address VALUES(11, '110 Row Rd');
INSERT INTO client_address VALUES(12, '111 Column Rd');
INSERT INTO client_address VALUES(13, '112 Amina Way');
INSERT INTO client_address VALUES(14, '113 Emma Street');


--Inserting account data
INSERT INTO account (account_id, total_balance, account_type, num_cosigner, required_signatures) VALUES(1, 130.10, 'savings', 3, 2);
INSERT INTO account (account_id, total_balance, account_type, num_cosigner, required_signatures) VALUES(2, 3000.20, 'savings', 2, 1);
INSERT INTO account (account_id, total_balance, account_type, num_cosigner, required_signatures) VALUES(3, 4500.25, 'checkings', 2, 2);
INSERT INTO account (account_id, total_balance, account_type, num_cosigner, required_signatures) VALUES(4, 14500.45, 'savings', 1, 1);
INSERT INTO account (account_id, total_balance, account_type, num_cosigner, required_signatures) VALUES(5, 500.31, 'savings', 3, 1);
INSERT INTO account (account_id, total_balance, account_type, num_cosigner, required_signatures) VALUES(6, 500.50, 'checkings', 5, 5);
INSERT INTO account (account_id, total_balance, account_type, num_cosigner, required_signatures) VALUES(7, 545.65, 'checkings', 4, 2);
INSERT INTO account (account_id, total_balance, account_type, num_cosigner, required_signatures) VALUES(9, 890.65, 'checkings', 1, 0);
INSERT INTO account (account_id, total_balance, account_type, num_cosigner, required_signatures) VALUES(10, 600.65, 'checkings', 1, 0);



--Inserting client_account data 
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(1,1,TRUE,TRUE,TRUE);
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(3,1,TRUE,TRUE,FALSE);
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(7,1,TRUE,FALSE,TRUE);

INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(5,2,TRUE,TRUE,FALSE);
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(6,2,FALSE,TRUE,TRUE);
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(2,2,TRUE,TRUE,TRUE);

INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(9,3,TRUE,TRUE,TRUE);
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(10,3,TRUE,TRUE,FALSE);

INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(4,4,TRUE,TRUE,TRUE);

INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(11,5,TRUE,TRUE,TRUE);
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(12,5,TRUE,TRUE,FALSE);
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(13,5,TRUE,TRUE,FALSE);

INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(1,6,TRUE,TRUE,FALSE);
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(2,6,TRUE,TRUE,TRUE);
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(3,6,TRUE,TRUE,FALSE);
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(4,6,TRUE,FALSE,TRUE);
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(5,6,TRUE,TRUE,TRUE);
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(6,6,FALSE,FALSE,FALSE);

INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(9,7,TRUE,TRUE,TRUE);
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(10,7,TRUE,TRUE,FALSE);
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(11,7,TRUE,FALSE,TRUE);
INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(8,7,TRUE,FALSE,TRUE);

INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(1,9,TRUE,TRUE,TRUE);

INSERT INTO client_account (client_id,account_id, sign_role, view_role, pay_role) VALUES(2,10,TRUE,TRUE,TRUE);


--Inserting statements data
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(1, 'my statement1', 1, 1);
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(2, 'my statement2', 2, 6);
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(3, 'my statement3', 3, 10);
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(4, 'my statement4', 4, 4);
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(5, 'my statement5', 5, 11);
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(6, 'my statement6', 6, 5);
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(7, 'my statement7', 7, 8);
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(8, 'my statement8', 9, 1);
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(9, 'my statement9', 10, 2);
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(10, 'my statement10', 10, 2);


--Inserting statement_signer data
INSERT INTO statement_signer VALUES(1, 3, TRUE);
INSERT INTO statement_signer VALUES(1, 1, FALSE);

INSERT INTO statement_signer VALUES(2, 2, TRUE);

INSERT INTO statement_signer VALUES(3, 10, TRUE);
INSERT INTO statement_signer VALUES(3, 9, TRUE);

INSERT INTO statement_signer VALUES(4, 4, TRUE);

INSERT INTO statement_signer VALUES(5, 12, FALSE);
INSERT INTO statement_signer VALUES(5, 11, FALSE);

INSERT INTO statement_signer VALUES(6, 1, FALSE);
INSERT INTO statement_signer VALUES(6, 2, FALSE);
INSERT INTO statement_signer VALUES(6, 3, TRUE);

INSERT INTO statement_signer VALUES(7, 11, FALSE);
INSERT INTO statement_signer VALUES(7, 10, FALSE);
INSERT INTO statement_signer VALUES(7, 8, TRUE);


/*
INSERT INTO statement_signer VALUES(7, 1, FALSE);
INSERT INTO statement_signer VALUES(7, 2, FALSE);
INSERT INTO statement_signer VALUES(7, 3, FALSE);
INSERT INTO statement_signer VALUES(7, 4, TRUE);
INSERT INTO statement_signer VALUES(7, 5, FALSE);
*/

--Inserting transactions data
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 10, 'deposit', 2);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 23, 'withdrawal', 6);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 100, 'withdrawal', 5);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 25, 'deposit', 4);

INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(2, 25, 'deposit', 7);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(2, 104, 'deposit', 3);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(2, 67, 'withdrawal', 1);

INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(3, 65, 'withdrawal', 4);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(3, 10, 'deposit', 6);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(3, 100, 'deposit',5);

INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to, note) VALUES(4, 100, 'withdrawal', 7, 'thanks for the cash');
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to, note) VALUES(4, 45.36, 'deposit', 1, 'here is some cash');

INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to, note) VALUES(5, 100, 'deposit', 7, 'here is some cash');
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to, note) VALUES(5, 102, 'withdrawal', 4, 'thanks for the cash');
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to, note) VALUES(5, 23.5, 'deposit', 2, 'here is some cash');

INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to, note) VALUES(6, 100, 'deposit', 1, 'here is some cash');
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to, note) VALUES(6, 550.50, 'withdrawal', 3,  'thanks for the cash');
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to, note) VALUES(6, 25, 'deposit', 6, 'here is some cash');

INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(7, 100.95, 'withdrawal', 1);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(7, 200, 'deposit', 2);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(7, 347, 'deposit', 3);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(7, 25.3, 'withdrawal', 4);

INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(8, 100.95, 'withdrawal', 1);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(8, 34, 'deposit', 2);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(8, 100.60, 'deposit', 3);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(8, 25.3, 'withdrawal', 4);

INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(9, 1.95, 'withdrawal', 1);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(9, 220, 'deposit', 2);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(9, 332, 'deposit', 3);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(9, 25.3, 'withdrawal', 5);

INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(10, 10, 'deposit', 7);
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(10, 20, 'withdrawal', 4);

--Inserting statement_confirmation data
INSERT INTO statement_confirmation VALUES(1, 1, FALSE);
INSERT INTO statement_confirmation VALUES(2, 6, FALSE);
INSERT INTO statement_confirmation VALUES(3, 9, FALSE);
INSERT INTO statement_confirmation VALUES(4, 4, FALSE);
INSERT INTO statement_confirmation VALUES(5, 11, FALSE);
INSERT INTO statement_confirmation VALUES(6, 5, FALSE);
INSERT INTO statement_confirmation VALUES(7, 8, FALSE);
INSERT INTO statement_confirmation VALUES(8, 1, TRUE);
INSERT INTO statement_confirmation VALUES(9, 2, TRUE);
INSERT INTO statement_confirmation VALUES(10, 2, TRUE);



SELECT * FROM transactions;
SELECT * FROM client;
SELECT * FROM client_phone;
SELECT * FROM client_address;
SELECT * FROM account;
SELECT * FROM client_account;
SELECT * FROM statements;
SELECT * FROM statement_signer;
SELECT * FROM transactions;
SELECT * FROM statement_confirmation;

DELETE FROM statement_confirmation;

--Audit tables
--NOTE: need to run code from store_log.sql first
SELECT * FROM statement_initiate_audit;
SELECT * FROM statement_sign_audit;
SELECT * FROM statement_pay_audit;
SELECT * FROM client_role_changes_audit;

