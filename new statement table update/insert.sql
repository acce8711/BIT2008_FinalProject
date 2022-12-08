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


--Inserting statements data
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(1, 'my statement1', 1, 1);
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(2, 'my statement2', 2, 6);
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(3, 'my statement3', 3, 10);
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(4, 'my statement4', 4, 4);
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(5, 'my statement5', 5, 11);
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(6, 'my statement6', 6, 5);
INSERT INTO statements (statement_id, note, source_account, initiator_client) VALUES(7, 'my statement7', 7, 8);


--Inserting statement_confirmation data
INSERT INTO statement_confirmation VALUES(6, 1, FALSE);
INSERT INTO statement_confirmation VALUES(2, 6, FALSE);
INSERT INTO statement_confirmation VALUES(3, 9, FALSE);
INSERT INTO statement_confirmation VALUES(4, 4, FALSE);
INSERT INTO statement_confirmation VALUES(5, 2, FALSE);
INSERT INTO statement_confirmation VALUES(6, 11, FALSE);

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






/*Insert statement_confirmation data here*/



/*Insert statement_signer Data Here*/
--need to add triggers functions constraints that check if client id is associated with the statemnts source account and has sign role

--INSERT INTO statement_signer VALUES(2, 2, TRUE); --trigger error: no sign role
--INSERT INTO statement_signer VALUES(8, 1, TRUE); --trigger error: no sign role

--INSERT INTO statement_signer VALUES(13, 1, TRUE); --trigger error: no sign role
--INSERT INTO statement_signer VALUES(16, 1, TRUE); --trigger error: no sign role



--testing if invalid signer can be inserted. it cannot. trigger 'verify_signer_trigger' works :D
INSERT INTO statement_signer VALUES(20, 8, TRUE);


/*Insert Transaction Data Here*/
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 10, 'deposit', 5); --trigger error: Statement cannot be edited. There is already at least one signature.
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 105, 'deposit', 6); --trigger error: Statement cannot be edited. There is already at least one signature.
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 10, 'withdrawal', 6); --trigger error: Statement cannot be edited. There is already at least one signature.
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 5, 'deposit', 4); --trigger error: Statement cannot be edited. There is already at least one signature.
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(1, 10, 'deposit', 6); --trigger error: Statement cannot be edited. There is already at least one signature.
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(2, 101, 'deposit', 4); --trigger error: Statement cannot be edited. There is already at least one signature.
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(2, 10, 'deposit', 4); --trigger error: Statement cannot be edited. There is already at least one signature.
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(2, 100, 'withdrawal', 4); --trigger error: Statement cannot be edited. There is already at least one signature.
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(3, 100, 'withdrawal', 6); --wow, this one actually works! 
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(3, 1002, 'deposit', 6); --this one works too!

INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(2, 1002, 'deposit', 6); --trigger error: Statement cannot be edited. There is already at least one signature.
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(2, 2, 'withdrawal', 6); --trigger error: Statement cannot be edited. There is already at least one signature.

INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(13, 1002, 'deposit', 5); -- insert or update on table "transactions" violates foreign key constraint "transaction_statement_id_fkey" 
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(13, 2, 'withdrawal', 1); -- insert or update on table "transactions" violates foreign key constraint "transaction_statement_id_fkey"
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(13, 20, 'withdrawal', 1); -- insert or update on table "transactions" violates foreign key constraint "transaction_statement_id_fkey"

--testing if trasaction can be added if statement is confirmed. It cannot be added. Trigger works :D
INSERT INTO transactions(statement_id, amount, transaction_type, transaction_to) VALUES(4, 100, 'withdrawals', 4);

UPDATE statements
SET total_amount = 2
WHERE statements.statement_id = 2; 

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

UPDATE client_phone
SET phone_numbr = 6137869244
WHERE client_id = 1 AND phone_numbr=6137869233; 


DELETE FROM transactions
WHERE statement_id = 1;

DELETE FROM statements
WHERE statement_id=7;

DELETE FROM statement_confirmation


DELETE FROM client_phone;

DELETE FROM client_account;

SELECT * FROM statements;
SELECT * FROM client_account;
SELECT * FROM statements;
SELECT * FROM statement_confirmation;
SELECT * FROM statement_signer;
SELECT * FROM transactions;
SELECT * FROM client;
SELECT * FROM client_phone;
SELECT * FROM client_address;
SELECT * FROM account;



