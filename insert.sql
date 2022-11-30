/*Insert CLient Data Here*/
INSERT INTO client (first_name, last_name, client_password) VALUES('Jim', 'Rocks', 'ILikeRocks');
INSERT INTO client (first_name, last_name, client_password) VALUES('Chloe', 'Joyce', 'idopds762');
INSERT INTO client (first_name, last_name, client_password) VALUES('Gavin', 'Morse', 'MorseCode9237');

/*Insert Account Data Here*/
INSERT INTO account (total_balance, account_type, num_cosigner) VALUES(130, 'savings', 3);
INSERT INTO account (total_balance, account_type, num_cosigner) VALUES(3000, 'savings', 1);
INSERT INTO account (total_balance, account_type, num_cosigner) VALUES(4500, 'checkings', 2);

/*Insert account_client Data Here*/
INSERT INTO client_account VALUES(1,2,TRUE,TRUE,TRUE);
INSERT INTO client_account VALUES(1,3,FALSE,TRUE,FALSE);



