--File to create tables for CPSC 304 library database project

DROP TABLE Employee_WorksAt;
DROP TABLE Member;
DROP TABLE BookInfo;
DROP TABLE MovieInfo;
DROP TABLE AudioBookInfo;
DROP TABLE BookID;
DROP TABLE AudioBookID;
DROP TABLE MovieID;
DROP VIEW ITEM_HELDAT_BORROWS;
DROP TABLE Person;
DROP TABLE Status;
DROP TABLE Users;
DROP TABLE Branch;
DROP TABLE Item;


CREATE TABLE Item (ItemID INTEGER,
                   Genre CHAR(15),
                   Title CHAR(40),
                   UserScore INTEGER,
                   LendingPeriod INTEGER,
  PRIMARY KEY(ItemID)
);

CREATE TABLE Branch(PostalCode CHAR(7),
                    Hours CHAR(9),
                    Address CHAR(50),
                    BranchName CHAR(30),
  PRIMARY KEY (PostalCode)
);

CREATE TABLE Users( ID INTEGER,
                    Name CHAR(24),
                    Email CHAR(60),
                    PhoneNumber CHAR(15),
                    Address CHAR(50),
                    Password CHAR(20),
  PRIMARY KEY (ID)
);

CREATE TABLE Person(	FullName CHAR(30),
                      Birthdate DATE,
                      Nationality CHAR(15),
  PRIMARY KEY (FullName, Birthdate)
);

CREATE TABLE Employee_WorksAt(ID INTEGER,
                              Position CHAR(20),
                              Salary INTEGER,
                              PostalCode CHAR(7),
  PRIMARY KEY (ID),
  CONSTRAINT fk_ewa_users FOREIGN KEY (ID) REFERENCES Users(ID) ON DELETE CASCADE ,
  CONSTRAINT fk_ewa_branch FOREIGN KEY (PostalCode) REFERENCES Branch(PostalCode) ON DELETE set null
);

CREATE TABLE Member(ID INTEGER,
                    Balance FLOAT,
                    CreditCardNumber INTEGER,
  PRIMARY KEY (ID),
  CONSTRAINT fk_m_user FOREIGN KEY (ID) REFERENCES Users(ID) ON DELETE CASCADE
);

CREATE TABLE Status(ItemID INTEGER,
                    CopyNumber INTEGER,
                    Available INTEGER, -- 1 for true, 0 for false
                    PostalCode CHAR(7),
                    DueDate DATE,
                    ID INTEGER,
  PRIMARY KEY(ItemID, CopyNumber),
  CONSTRAINT fk_s_postalCode
  FOREIGN KEY (PostalCode)
  REFERENCES BRANCH(PostalCode)
  ON DELETE CASCADE,
  CONSTRAINT fk_s_users FOREIGN KEY(ID) REFERENCES USERS(ID) ON DELETE CASCADE
);





CREATE TABLE BookInfo (ItemID INTEGER,
                       PageCount INTEGER,
                       Publisher CHAR(42),
                       FullName CHAR(30) NOT NULL,
                       Birthdate DATE NOT NULL,
  PRIMARY KEY (ItemID),
  CONSTRAINT fk_bi_itemID FOREIGN KEY (ItemID) REFERENCES Item (ItemID) ON DELETE CASCADE,
  CONSTRAINT fk_bi_person FOREIGN KEY (FullName, Birthdate) REFERENCES Person (FullName, Birthdate) ON DELETE CASCADE
);

CREATE TABLE BookID (ItemID INTEGER,
                     CopyNumber INTEGER,
  PRIMARY KEY(ItemID, CopyNumber),
  CONSTRAINT fk_bid_status FOREIGN KEY (ItemID, CopyNumber) REFERENCES Status (ItemID, CopyNumber) ON DELETE CASCADE
);

CREATE TABLE AudioBookInfo (	ItemID INTEGER PRIMARY KEY,
                              Duration INTEGER, --Minutes
                              Narrator CHAR(30),
                              Publisher CHAR(40),
                              FullName CHAR(30) NOT NULL,
                              Birthdate DATE NOT NULL,
  CONSTRAINT fk_abi_item FOREIGN KEY (ItemID) REFERENCES Item (ItemID) ON DELETE CASCADE,
  CONSTRAINT fk_abi_person FOREIGN KEY (FullName, Birthdate) REFERENCES Person (FullName, Birthdate) ON DELETE CASCADE
);

CREATE TABLE AudioBookID (ItemID INTEGER,
                          CopyNumber INTEGER,
  PRIMARY KEY(ItemID, CopyNumber),
  CONSTRAINT fk_abid_status FOREIGN KEY (ItemID, CopyNumber) REFERENCES Status (ItemID, CopyNumber) ON DELETE CASCADE
);

CREATE TABLE MovieInfo (ItemID INTEGER,
                        Rating CHAR(4),
                        Duration INTEGER, --minutes
                        FullName CHAR(30) NOT NULL,
                        Birthdate DATE NOT NULL,
  PRIMARY KEY (ItemID),
  CONSTRAINT fk_mi_item FOREIGN KEY (ItemID) REFERENCES Item (ItemID) ON DELETE CASCADE,
  CONSTRAINT fk_mi_person FOREIGN KEY (FullName, Birthdate) REFERENCES Person (FullName, Birthdate) ON DELETE CASCADE
);

CREATE TABLE MovieID (ItemID INTEGER,
                      CopyNumber INTEGER,
  PRIMARY KEY (ItemID, CopyNumber),
  CONSTRAINT fk_mid_status FOREIGN KEY (ItemID, CopyNumber) REFERENCES Status (ItemID, CopyNumber) ON DELETE CASCADE
);

CREATE VIEW Item_HeldAt_Borrows(ItemID, CopyNumber, Genre, Title, UserScore, LendingPeriod, Available, PostalCode, DueDate, ID) AS
  SELECT i.ItemID, s.CopyNumber, i.Genre, i.Title, i.UserScore, i.LendingPeriod, s.Available, s.PostalCode, s.DueDate, s.ID
  FROM Item i, Status s
  WHERE i.ItemID = s.ItemID;

INSERT INTO Branch (PostalCode,Hours,Address,BranchName) VALUES ('S0Y 3C4','10-5','P.O. Box 741, 8974 Sociis Avenue','Koerner Library');
INSERT INTO Branch (PostalCode,Hours,Address,BranchName) VALUES ('V5M 5X7','10-5','626-9835 Semper. Road','Irving K. Barber Library');
INSERT INTO Branch (PostalCode,Hours,Address,BranchName) VALUES ('K7S 3V2','10-5','Ap #954-5937 Mollis Road','Woodward Library');
INSERT INTO Branch (PostalCode,Hours,Address,BranchName) VALUES ('K0B 4M5','10-5','4224 Ut Street','Innovation Library');
INSERT INTO Branch (PostalCode,Hours,Address,BranchName) VALUES ('C8V 1M9','10-5','448-6919 Ligula Ave','Asian Library');



--Employees
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (1155,'Arsenio Jordan','purus.Duis@nonummyipsumnon.org','1-665-737-7392','P.O. Box 353, 7155 Luctus Avenue','DZF15BAV9EK');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (1937,'Jason Navarro','turpis@tellussem.com','1-492-640-6369','6371 Cras Street','IBY62BVG9ER');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (6640,'Dante Fox','ipsum@lorem.com','1-864-125-6611','P.O. Box 934, 1985 Phasellus Street','XBK59AQB0JQ');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (1620,'Hyacinth Richards','Duis.at@erosNamconsequat.net','1-703-426-7337','5980 Dolor Avenue','WHG23KDW4NI');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (2818,'Dorothy Parsons','sit.amet@orci.edu','1-941-193-6760','242-2289 Ante Avenue','YKM90GBY3CO');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (1289,'Chloe Barber','commodo@purusNullam.com','1-360-867-6460','3947 Sem St.','NFZ44XOW0WS');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (3505,'Wade Kent','et@massanon.co.uk','1-583-458-0987','Ap #854-3695 Sociosqu St.','CHN12QLM2CI');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (3518,'Phillip Giles','Fusce.mi@elitpharetraut.com','1-772-319-6740','Ap #498-292 Tristique Rd.','ZKH11QPT2UO');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (8599,'Michelle Mays','senectus.et.netus@cursusvestibulumMauris.org','1-717-123-4929','546 Adipiscing. Av.','UAP27IFF0BM');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (1327,'Jermaine Mills','vel.vulputate.eu@risusquis.net','1-286-120-6083','9126 Faucibus Street','CQX59THB1RO');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (4542,'Sandra Clark','rutrum.magna.Cras@egestasSed.edu','1-700-709-7959','558-6185 Eget Street','BDA91KBR9ZE');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (5806,'Wanda Boyle','felis@morbi.co.uk','1-439-974-8288','6292 Est St.','ENO12RRQ9KG');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (7052,'Yael Tucker','vulputate.risus.a@eueuismod.net','1-698-669-1441','Ap #275-3036 Nec St.','CSN27IJG3UA');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (1034,'Phoebe Patel','bibendum@lectus.co.uk','1-507-927-1330','Ap #374-3200 Condimentum. Av.','NSW32LJY4UO');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (5579,'Vincent Contreras','nulla@doloregestas.net','1-437-527-9842','Ap #211-3680 Libero Rd.','TEX92UGH5FY');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (2949,'Nathan Coleman','est.Mauris.eu@sagittis.co.uk','1-560-468-2803','Ap #860-3510 Mi Ave','LIV99JNZ8GO');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (2319,'Melodie Howe','aliquet.Phasellus.fermentum@atpretium.net','1-460-508-9824','807-2671 Tellus. Rd.','WNH91SKZ7KZ');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (9828,'Geraldine Waller','blandit.at.nisi@velarcuCurabitur.edu','1-741-925-1552','286-1753 A, Rd.','YIW78IWG8AS');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (8084,'Daria Mann','quis@Nullasempertellus.com','1-800-906-3625','9542 Dui. Av.','UQH24ANH1CF');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (1708,'Anika Guerra','consectetuer@molestieorcitincidunt.edu','1-342-332-6494','354-5191 Amet, Ave','HMN23AAZ8YS');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (9800,'Mariko Dotson','amet.consectetuer@dictumeueleifend.org','1-973-734-2400','P.O. Box 216, 9642 At, St.','PEW74MCJ5WH');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (5172,'Edward Mckee','dictum.cursus.Nunc@purus.co.uk','1-881-899-8610','388-9763 Curabitur Road','CKB38PDQ0FP');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (6834,'Ivy Jarvis','In.condimentum.Donec@euismodindolor.net','1-139-763-5746','5381 Sit Ave','OUS48FGZ3OI');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (3428,'Joelle Velazquez','turpis@sitamet.net','1-156-471-9446','Ap #884-7122 Dictum Rd.','HMO73OVA9OW');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (6569,'Boris Horn','dui@estarcu.ca','1-673-670-9905','685-265 Tempus, St.','AKQ60ZRQ5EZ');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (4660,'David Slater','consectetuer@eunullaat.edu','1-762-438-3945','9612 Convallis Ave','MDG96GQF2GY');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (6349,'Brenden Schroeder','enim@tempor.co.uk','1-675-282-3896','725-7085 Duis Rd.','QMW66UQX9RY');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (4097,'Teagan Klein','augue@iaculis.org','1-853-540-9714','4107 Enim. Ave','FRY33TDO4YN');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (4905,'Jermaine Simon','orci.adipiscing@atiaculis.edu','1-791-538-6248','706-7999 Ligula. Av.','RBY00XBH0YH');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (3297,'Shana Poole','non.enim.Mauris@pellentesquetellussem.edu','1-627-232-4186','P.O. Box 330, 2622 Magna Ave','PUD14SJV3DM');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (8937,'Amena Rich','sodales@nisiMaurisnulla.co.uk','1-388-117-7043','P.O. Box 723, 6026 Nunc St.','WOK65SFD7OD');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (4362,'Hedwig Harrington','cursus@antedictumcursus.net','1-474-742-8859','643-5627 Sed Rd.','AFC37HYU6QN');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (7359,'Joseph Bush','non.lacinia.at@nequepellentesque.ca','1-384-513-5276','3821 Sociis Road','JGR67QXF5RO');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (1737,'Kameko Bowen','sapien@lacinia.org','1-629-477-9387','3524 Nulla St.','JXV67OIF3TB');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (9367,'Arthur Moon','Integer@orci.edu','1-869-173-6764','783-3143 Semper St.','IKX99TAQ5JW');
--Members
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (4700,'Allistair Campbell','nulla@Vivamusnon.org','1-212-609-4352','Ap #780-8024 Enim. Ave','EGG22UIU9VY');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (2480,'Randall Mason','eu.tempor@Donecdignissimmagna.org','1-513-761-2749','9449 Dis Rd.','SOF31HOW7PN');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (6462,'Rebekah Johnson','magna@odioauctorvitae.co.uk','1-917-434-3970','P.O. Box 441, 8451 Morbi Rd.','DAO17HAW1VT');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (9167,'Madonna Wade','ullamcorper.Duis.cursus@viverraMaecenasiaculis.edu','1-373-141-0374','386-547 Ipsum Street','FQY20BXH2WA');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (3365,'Robin Mcguire','amet.risus@tellusAeneanegestas.ca','1-814-482-4901','582-4269 Convallis, Avenue','JDS35PAT6UO');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (3327,'Regina England','penatibus@ultriciesornareelit.com','1-348-999-9175','P.O. Box 268, 5132 Non, Ave','RHD03JQN1XL');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (1026,'Lance Rivas','nec.imperdiet.nec@sollicitudina.net','1-838-859-7985','494-3914 Mi, Av.','VFQ02BBK5CD');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (6802,'Shannon England','egestas@nec.edu','1-911-332-7603','9936 Donec Road','KNK31QSV6CB');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (1641,'Keegan Rasmussen','at.pretium@euismodacfermentum.com','1-645-570-0163','Ap #280-2761 Sem. Rd.','XKD27PGA1LO');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (6075,'Zoe Mason','Duis.mi@ornare.org','1-961-917-4984','248-7047 Malesuada Street','XPI91HFP8WQ');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (8184,'Libby Mclaughlin','ultrices.Vivamus@sodalesat.com','1-508-428-2540','148-7806 Auctor Av.','FPS06TVH9MR');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (6138,'Farrah Burns','vel@auctorquistristique.com','1-955-584-7211','Ap #554-7976 Amet Ave','TQT83EJW2TH');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (4156,'Baker Levine','litora@Fuscealiquam.ca','1-762-531-8779','P.O. Box 292, 3375 Luctus St.','PGT27YXR7CA');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (6195,'Lamar Mcintosh','at.iaculis.quis@Suspendisse.org','1-227-668-4097','Ap #101-6539 Felis St.','NTJ86TDT8BC');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (7291,'Emmanuel Reed','ornare.facilisis@natoquepenatibus.com','1-445-690-7108','240-7707 In Avenue','FCD61PVW3MY');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (3796,'Lamar Wood','molestie.Sed.id@tortorNunc.com','1-872-381-0336','Ap #400-4696 Eu Rd.','HHQ55VVH4HD');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (8675,'Donna Lowery','tincidunt@quisdiamluctus.co.uk','1-863-619-3746','P.O. Box 653, 7073 Ornare Street','YEF36TBR5EY');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (1789,'Gloria Graham','Ut.sagittis@ipsum.com','1-555-710-5142','843 Consectetuer Rd.','IOG29ZVF8HU');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (2593,'Rogan Lopez','amet.faucibus.ut@convallisligula.net','1-474-477-9684','P.O. Box 177, 7824 Nec Rd.','TIW37PDA0HO');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (8954,'Ulysses Koch','elementum.at@posuerecubilia.ca','1-828-203-6328','P.O. Box 250, 4928 At Av.','OGL85JLG9YB');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (4070,'Evangeline Poole','sodales@temporbibendumDonec.net','1-903-582-3764','P.O. Box 417, 2693 Cras Avenue','QBL76JNQ5IJ');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (7431,'Sylvester Navarro','turpis.egestas.Aliquam@mus.co.uk','1-247-130-7197','Ap #297-4708 Suscipit St.','RNX55ZVZ0AW');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (7772,'Courtney Jarvis','Fusce.mollis@ornareplaceratorci.org','1-420-820-4574','Ap #715-2457 Scelerisque, Avenue','OEQ62CEA9BE');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (4434,'Leo Johnston','Duis@tellusPhaselluselit.ca','1-166-503-0375','2080 Duis Av.','NPY06BCK8GU');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (8313,'Lydia Holden','interdum.Nunc.sollicitudin@Mauris.co.uk','1-658-924-3630','131-6287 Ante. Rd.','WXU26DET6TB');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (4219,'Vance Byers','Donec.egestas@temporerat.co.uk','1-136-748-7303','Ap #401-7468 Molestie Ave','LGI78TNJ4WF');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (5246,'Akeem Spencer','sit@porttitor.net','1-554-381-6024','P.O. Box 610, 9683 Nec St.','WIF26IFS5TZ');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (6346,'Dawn Figueroa','egestas.a.dui@semperauctorMauris.org','1-808-740-0514','P.O. Box 389, 463 Tempus Rd.','HOG70BFU4YD');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (9238,'Omar Craft','Aenean@nequevitae.net','1-276-752-8381','Ap #615-6307 Pharetra. Street','DJJ11ZGN2YE');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (7215,'Uma Flynn','enim.consequat@tinciduntnunc.net','1-805-561-4119','Ap #174-3296 Justo St.','JAR41QEA0LX');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (7615,'Lane Benson','Quisque.ac.libero@lobortis.net','1-722-704-4390','P.O. Box 710, 4148 Tempus Avenue','KBS18MXY7IR');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (5524,'Jenna Soto','Donec.fringilla@sedsapien.co.uk','1-668-884-0790','P.O. Box 790, 2951 Ipsum Rd.','WCX85XHV1ND');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (2845,'Pandora Yates','Suspendisse.tristique.neque@cursusinhendrerit.com','1-610-156-7968','P.O. Box 800, 9010 Vitae Road','AAX28CRS0RS');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (6127,'Micah Woodward','Aliquam@vitaediamProin.ca','1-204-649-4811','Ap #405-163 Ut Av.','ESX98OBX9XB');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (5860,'Kelsie Kim','euismod@ultriciessemmagna.co.uk','1-184-796-1851','Ap #529-3525 Cras Road','OYI67QWW1PT');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (7807,'Alan Vang','lacus.pede@nonenimMauris.co.uk','1-182-362-8703','P.O. Box 236, 6395 Vel Rd.','TJP98QXJ5FW');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (4883,'Mason Marshall','ac@nec.net','1-606-881-6064','512-1958 Non Ave','IGI69AHZ0HC');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (1029,'Ciaran Mcfarland','adipiscing.Mauris@blanditNamnulla.ca','1-862-504-0905','7872 Consequat Rd.','VBW29JEV6TN');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (3816,'Fredericka Blankenship','consectetuer.adipiscing@semconsequatnec.com','1-964-155-7258','P.O. Box 672, 4632 Aliquam, Avenue','IQN53VCD7EK');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (2820,'Martin Morgan','Donec@amet.com','1-493-191-2648','Ap #983-3665 Vivamus St.','KFC94VWV4CV');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (3318,'Melvin Suarez','neque@semperegestas.org','1-667-232-4817','Ap #905-5318 Nullam St.','YEO51ZGQ1AX');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (2618,'Tatum Evans','eu.nibh.vulputate@interdumliberodui.ca','1-882-392-4514','Ap #996-7818 Ipsum Road','IMT51VYT0NK');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (1,'Wesley Ferguson','pwesferguson@gmail.com','7788296407','79 E 64th Ave','definitelyReal');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (2,'Princess Lafayette','lafayette.princess@gmail.com','7781234567',NULL,'extremelySecure');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (3,'Jvalana Caryl Shankar','jvalana.shankar152@gmail.com','6042346780',NULL,'noProblemsHere');
INSERT INTO Users (ID,Name,Email,PhoneNumber,Address,Password) VALUES (4,'Sheila Wang','sheila.jy.wang@gmail.com','7784501523',NULL,'Whatcouldgowrong');

INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (1155,'Clerk',30000,'S0Y 3C4');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (1937,'Clerk',30000,'S0Y 3C4');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (6640,'Clerk',30000,'S0Y 3C4');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (1620,'Clerk',30000,'V5M 5X7');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (2818,'Clerk',30000,'V5M 5X7');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (1289,'Clerk',30000,'V5M 5X7');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (3505,'Clerk',30000,'V5M 5X7');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (3518,'Clerk',30000,'V5M 5X7');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (8599,'Clerk',35000,'K7S 3V2');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (1327,'Clerk',35000,'K7S 3V2');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (4542,'Clerk',35000,'K7S 3V2');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (5806,'Clerk',35000,'K7S 3V2');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (7052,'Clerk',35000,'K0B 4M5');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (1034,'Clerk',40000,'K0B 4M5');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (5579,'Clerk',40000,'K0B 4M5');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (2949,'Clerk',40000,'C8V 1M9');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (2319,'Clerk',40000,'C8V 1M9');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (9828,'Clerk',40000,'C8V 1M9');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (8084,'IT',65000,'S0Y 3C4');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (1708,'IT',70000,'V5M 5X7');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (9800,'IT',58000,'K7S 3V2');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (5172,'IT',63200,'K0B 4M5');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (6834,'IT',68500,'C8V 1M9');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (3428,'Custodian',46890,'S0Y 3C4');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (6569,'Custodian',43890,'S0Y 3C4');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (4660,'Custodian',45935,'V5M 5X7');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (6349,'Custodian',47890,'K7S 3V2');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (4097,'Custodian',55600,'K0B 4M5');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (4905,'Custodian',57800,'C8V 1M9');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (3297,'Director',68000,'S0Y 3C4');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (8937,'Director',72000,'V5M 5X7');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (4362,'Director',73500,'K7S 3V2');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (7359,'Director',76400,'K0B 4M5');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (1737,'Director',62500,'C8V 1M9');
INSERT INTO Employee_WorksAt (ID,Position,Salary,PostalCode) VALUES (9367,'Director',65500,'C8V 1M9');

INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (4700,4,'1679051918099');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (2480,-2,'1626020755299');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (6462,5,'1670020943499');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (9167,2,'1649080155799');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (3365,-5,'1668062428499');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (3327,4,'1630032463899');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (1026,-3,'1607022929499');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (6802,4,'1645080412499');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (1641,-4,'1602012098699');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (6075,-1,'1637120364199');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (8184,-2,'1636060853499');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (6138,4,'1647061730599');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (4156,-4,'1687062259999');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (6195,3,'1647032268799');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (7291,-2,'1618120715999');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (3796,5,'1667111234399');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (8675,-4,'1698112533899');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (1789,-4,'1612121234899');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (2593,-2,'1650021436599');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (8954,0,'1606052235599');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (4070,-5,'1627102551999');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (7431,-3,'1618111904599');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (7772,-5,'1642032474199');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (4434,-4,'1690111336599');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (8313,1,'1611111508199');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (4219,5,'1667022843399');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (5246,0,'1677091508699');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (6346,-4,'1649092154999');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (9238,0,'1609110951099');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (7215,-1,'1632020604699');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (7615,-2,'1609063026799');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (5524,-2,'1615051551499');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (2845,0,'1683053098399');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (6127,-1,'1662120326899');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (5860,-4,'1680011069499');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (7807,5,'1674052945599');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (4883,2,'1626110757999');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (1029,-2,'1632040116799');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (3816,4,'1630031713099');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (2820,4,'1695053077499');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (3318,5,'1670051721699');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (2618,0,'1648052250499');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (1,0,'57845930284');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (2,0,'54839045897');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (3,0,'48390184374');
INSERT INTO Member (ID,Balance,CreditCardNumber) VALUES (4,0,'23901984374');



--Books
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (52624,'Fiction','Vel Arcu',87,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (84112,'Fiction','Curses',57,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (95698,'Fiction','Chicken Soup',86,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (17430,'Fiction','Integers',67,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (61750,'Fiction','Inside the Red Border',35,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (29086,'Fiction','Dolphin Tales,',43,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (31621,'Fiction','Pride and Prejudice',98,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (16306,'Fiction','Little Women',45,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (47209,'Fiction','Tom Sawyer',56,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (35358,'Fiction','Huckleberry Finn',76,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (53913,'Fiction','Vitae',86,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (19297,'Fiction','War',57,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (75772,'Fiction','Heritage',89,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (97251,'Fiction','Dulce',45,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (48182,'Fiction','Harry Potter',76,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (15211,'Fiction','Angels and Demons',86,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (11444,'Fiction','Monopoly',87,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (41696,'Fiction','Animal Stories',46,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (59423,'Fiction','Assassins Creed',98,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (31357,'Fiction','Mario Party',34,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (93503,'Fiction','Little House on the Prairies',21,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (42128,'Fiction','Night',24,14);
--Audiobooks
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (65474,'Reference','Encyclopedia of Music',60,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (85186,'Reference','Total War',85,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (31192,'Reference','Wildlife',67,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (19111,'Reference','Biochemistry',87,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (99218,'Reference','Emergency Room',96,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (24720,'Reference','The Cell',35,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (62466,'Mystery','Murdoch Mysteries',75,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (85100,'Mystery','Sherlock Holmes',23,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (75671,'Mystery','Who Did It',35,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (25271,'Mystery','Not Sure',56,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (96897,'Mystery','What is Wrong',43,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (95344,'Mystery','Questions',29,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (62461,'Mystery','What Will Happen',75,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (26532,'Mystery','Suspense',87,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (29026,'Horror','Fear',86,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (77627,'Horror','Terrifying',57,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (67345,'Horror','Ghostbusters',54,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (35449,'Horror','Casper The Friendly Ghost',65,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (57058,'Adventure','Journey to the Centre of the Earth',77,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (81085,'Adventure','The Mummy',34,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (21390,'Adventure','Treehouse',24,14);
--Movies
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (22699,'Adventure','Adventure Time',54,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (21436,'Adventure','National Treasure',65,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (64251,'Fiction','Bonjour',32,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (62476,'Fiction','Tim Hortons',34,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (42255,'Fiction','McDonalds',76,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (72575,'Fiction','Finding Dory',75,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (15703,'Fiction','Finding Nemo',80,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (81437,'Fiction','Meet the Robinsons',76,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (28719,'Fiction','Incredibles',88,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (28684,'Fiction','Pocahontas',98,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (52861,'Fiction','Mulan',86,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (44268,'Fiction','Spongebob',56,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (51067,'Fiction','The Lion King',94,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (57342,'Fiction','The Little Mermaid',76,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (63299,'Fiction','Cinderella',78,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (87380,'Reference','National Geographic',51,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (56989,'Reference','Animal Planet',75,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (27717,'Reference','TLC',72,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (35080,'Reference','NBC',87,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (95517,'Reference','CTV', 53, 14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (17929,'Reference','Fox',42,14);
INSERT INTO Item (ItemID,Genre,Title,UserScore,LendingPeriod) VALUES (1,'Test','Test',42,2);



--Books
--INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (1,1,0,'S0Y 3C4','2018-06-02 00:00:00',3);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (52624,1,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (84112,1,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (95698,1,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (17430,1,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (61750,1,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (61750,2,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (61750,3,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (29086,1,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (31621,1,1,'K0B 4M5',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (16306,1,1,'K0B 4M5',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (47209,1,1,'C8V 1M9',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (35358,1,1,'C8V 1M9',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (53913,1,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (19297,1,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (75772,1,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (75772,2,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (75772,3,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (75772,4,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (75772,5,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (97251,1,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (48182,1,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (15211,1,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (15211,2,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (11444,1,1,'K0B 4M5',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (41696,1,1,'K0B 4M5',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (59423,1,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (31357,1,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (93503,1,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (42128,1,1,'V5M 5X7',NULL,NULL);
--Audiobooks
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (65474,1,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (85186,1,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (31192,1,1,'K0B 4M5',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (19111,1,1,'K0B 4M5',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (99218,1,1,'C8V 1M9',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (24720,1,1,'C8V 1M9',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (62466,1,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (62466,2,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (62466,3,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (62466,4,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (62466,5,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (62466,6,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (85100,1,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (75671,1,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (25271,1,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (96897,1,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (95344,1,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (62461,1,1,'K0B 4M5',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (26532,1,1,'K0B 4M5',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (29026,1,1,'C8V 1M9',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (77627,1,1,'C8V 1M9',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (77627,2,1,'C8V 1M9',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (77627,3,1,'C8V 1M9',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (67345,1,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (35449,1,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (57058,1,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (57058,2,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (81085,1,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (21390,1,1,'K7S 3V2',NULL,NULL);
--Movies
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (22699,1,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (21436,1,1,'K0B 4M5',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (64251,1,1,'K0B 4M5',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (62476,1,1,'C8V 1M9',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (42255,1,1,'C8V 1M9',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (72575,1,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (15703,1,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (81437,1,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (28719,1,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (28684,1,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (52861,1,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (44268,1,1,'K0B 4M5',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (51067,1,1,'K0B 4M5',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (57342,1,1,'C8V 1M9',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (63299,1,1,'C8V 1M9',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (87380,1,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (56989,1,1,'S0Y 3C4',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (27717,1,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (27717,2,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (35080,1,1,'V5M 5X7',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (95517,1,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (95517,2,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (95517,3,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (95517,4,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (17929,1,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (17929,2,1,'K7S 3V2',NULL,NULL);
INSERT INTO Status (ItemID, CopyNumber, Available, PostalCode, DueDate, ID) VALUES (17929,3,1,'K7S 3V2',NULL,NULL);



INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Mara Hopper','1944-12-30','Australia');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Noble Le','1896-04-12','Australia');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Tad Warner','1997-07-29','United Kingdom');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Lilah Glass','1818-01-10','Australia');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Salvador Wall','1884-07-26','United Kingdom');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Connor Rodriguez','1832-11-07','Canada');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Cassady Delacruz','1859-04-03','Australia');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Dustin Mueller','1998-04-09','Australia');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Yvonne Ross','1940-04-27','New Zealand');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Dara Craft','1961-08-29','Canada');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Drew Puckett','1888-08-31','United Kingdom');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Richard Serrano','1938-04-22','Canada');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Rachel Cline','1981-10-06','United Kingdom');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Lance Montgomery','1864-04-29','New Zealand');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Yuri Juarez','1927-02-25','Canada');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Elvis Peck','1827-12-28','United States');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Kevin Michael','1884-05-25','Canada');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Madeline Klein','1937-08-14','United States');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Ira Newman','1821-12-09','Canada');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Walker Gilliam','1882-09-14','Canada');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Drew Adams','1972-08-07','United States');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Beverly Ellison','1850-03-20','Canada');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Meredith Bradshaw','1957-08-25','New Zealand');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Mona Sears','1942-01-13','Australia');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Kermit Anthony','1993-03-13','Canada');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Jamal Kinney','1857-08-09','New Zealand');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Kevin Meyers','1868-07-22','New Zealand');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Jerome Bradley','1935-11-18','New Zealand');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Branden Walls','1958-09-14','New Zealand');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Germaine Merritt','1924-11-06','United Kingdom');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Zena Gill','1839-07-07','United Kingdom');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Arden Stanton','1834-08-22','United Kingdom');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Brady Soto','1972-04-07','United Kingdom');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Brenda Williamson','1822-10-24','United Kingdom');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Chantale Landry','1911-08-02','Canada');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Alexis Mcdaniel','1886-04-16','United Kingdom');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Dustin Hoover','1887-06-05','New Zealand');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Kiona Sweeney','1991-07-05','United Kingdom');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Rose Noble','1858-07-22','New Zealand');
INSERT INTO Person (FullName,Birthdate,Nationality) VALUES ('Holly Callahan','1949-06-19','United Kingdom');



INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (52624,155,'A Company','Noble Le','1896-04-12');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (84112,410,'Lacus Aliquam Rutrum Consulting','Noble Le','1896-04-12');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (95698,442,'Sollicitudin Adipiscing Ligula Foundation','Noble Le','1896-04-12');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (17430,537,'Pharetra Incorporated','Lilah Glass','1818-01-10');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (61750,453,'Dictum LLC','Lilah Glass','1818-01-10');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (29086,1141,'Vel Faucibus Id Consulting','Cassady Delacruz','1859-04-03');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (31621,1185,'Ipsum Nunc Company','Connor Rodriguez','1832-11-07');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (16306,381,'Enim LLP','Arden Stanton','1834-08-22');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (47209,584,'Eu Tellus Eu Foundation','Zena Gill','1839-07-07');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (35358,1359,'Donec Nibh Foundation','Jerome Bradley','1935-11-18');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (53913,791,'Malesuada Fames Limited','Jerome Bradley','1935-11-18');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (19297,1416,'Sem Pellentesque Ut Limited','Chantale Landry','1911-08-02');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (75772,1051,'Libero Proin Sed Ltd','Chantale Landry','1911-08-02');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (97251,479,'Dapibus Ligula Corporation','Chantale Landry','1911-08-02');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (48182,1414,'Egestas Company','Alexis Mcdaniel','1886-04-16');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (15211,308,'Justo Nec Ante Corporation','Alexis Mcdaniel','1886-04-16');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (11444,1407,'Eu Inc.','Beverly Ellison','1850-03-20');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (41696,1132,'Vel Corp.','Walker Gilliam','1882-09-14');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (59423,1281,'Nec Diam Company','Ira Newman','1821-12-09');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (31357,248,'Tellus Ltd','Jamal Kinney','1857-08-09');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (93503,485,'Suspendisse Eleifend Cras Industries','Jamal Kinney','1857-08-09');
INSERT INTO BookInfo (ItemID,PageCount,Publisher,FullName,Birthdate) VALUES (42128,505,'Felis Purus Limited','Kevin Michael','1884-05-25');



INSERT INTO BookID (ItemID, CopyNumber) VALUES (52624,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (84112,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (95698,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (17430,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (61750,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (61750,2);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (61750,3);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (29086,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (31621,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (16306,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (47209,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (35358,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (53913,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (19297,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (75772,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (75772,2);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (75772,3);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (75772,4);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (75772,5);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (97251,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (48182,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (15211,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (15211,2);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (11444,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (41696,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (59423,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (31357,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (93503,1);
INSERT INTO BookID (ItemID, CopyNumber) VALUES (42128,1);



INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (65474,359,'Cain Carroll','Ac Fermentum Vel Corporation','Meredith Bradshaw','1957-08-25');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (85186,613,'Hedley Donaldson','Lacus Limited','Meredith Bradshaw','1957-08-25');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (31192,389,'Zahir Dickerson','Nulla Facilisi Sed Company','Meredith Bradshaw','1957-08-25');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (19111,295,'Kyra Nolan','Euismod In Dolor Corp.','Meredith Bradshaw','1957-08-25');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (99218,229,'Tyrone Rojas','Iaculis Odio Nam Associates','Madeline Klein','1937-08-14');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (24720,327,'Morgan Little','Scelerisque Neque PC','Madeline Klein','1937-08-14');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (62466,189,'Jacob Cohen','Pede Sagittis Augue Corporation','Madeline Klein','1937-08-14');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (85100,590,'Lucian Tran','Aliquam Enim Foundation','Madeline Klein','1937-08-14');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (75671,605,'Bryar Vincent','Vitae Dolor Incorporated','Yvonne Ross','1940-04-27');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (25271,544,'Indigo Brown','Vivamus Associates','Yvonne Ross','1940-04-27');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (96897,404,'Harrison Cook','Ultrices Sit LLC','Yvonne Ross','1940-04-27');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (95344,457,'Ann Dorsey','Auctor Non Feugiat Foundation','Yvonne Ross','1940-04-27');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (62461,532,'Judah Stephenson','A Institute','Kermit Anthony','1993-03-13');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (26532,306,'Kalia Vance','Ligula Elit Pretium Foundation','Kermit Anthony','1993-03-13');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (29026,149,'Freya Wade','Fringilla Cursus Purus Corporation','Kermit Anthony','1993-03-13');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (77627,360,'Raymond Marshall','Non Corp.','Kermit Anthony','1993-03-13');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (67345,410,'Stacey Wynn','Odio Limited','Holly Callahan','1949-06-19');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (35449,427,'Owen Craft','Duis Corporation','Holly Callahan','1949-06-19');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (57058,165,'Liberty Fulton','Phasellus Elit Pede LLC','Holly Callahan','1949-06-19');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (81085,661,'Declan Bishop','Metus LLC','Holly Callahan','1949-06-19');
INSERT INTO AudioBookInfo (ItemID,Duration,Narrator,Publisher,FullName,Birthdate) VALUES (21390,587,'Cade Mitchell','Nulla LLP','Holly Callahan','1949-06-19');



INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (65474,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (85186,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (31192,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (19111,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (99218,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (24720,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (62466,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (62466,2);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (62466,3);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (62466,4);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (62466,5);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (62466,6);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (85100,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (75671,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (25271,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (96897,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (95344,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (62461,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (26532,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (29026,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (77627,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (77627,2);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (77627,3);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (67345,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (35449,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (57058,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (57058,2);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (81085,1);
INSERT INTO AudioBookID (ItemID, CopyNumber) VALUES (21390,1);



INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (22699,'G',123,'Mara Hopper','1944-12-30');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (21436,'G',154,'Mara Hopper','1944-12-30');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (64251,'G',142,'Mara Hopper','1944-12-30');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (62476,'G',162,'Mara Hopper','1944-12-30');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (42255,'G',145,'Yuri Juarez','1927-02-25');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (72575,'G',96,'Yuri Juarez','1927-02-25');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (15703,'PG',150,'Yuri Juarez','1927-02-25');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (81437,'PG',113,'Yuri Juarez','1927-02-25');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (28719,'PG',83,'Yuri Juarez','1927-02-25');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (28684,'PG',154,'Yuri Juarez','1927-02-25');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (52861,'PG',125,'Yuri Juarez','1927-02-25');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (44268,'PG',76,'Rachel Cline','1981-10-06');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (51067,'PG',89,'Rachel Cline','1981-10-06');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (57342,'R',80,'Rachel Cline','1981-10-06');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (63299,'R',82,'Brady Soto','1972-04-07');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (87380,'R',90,'Brady Soto','1972-04-07');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (56989,'R',45,'Brady Soto','1972-04-07');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (27717,'R',130,'Kiona Sweeney','1991-07-05');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (35080,'G',78,'Holly Callahan','1949-06-19');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (95517,'G',94,'Holly Callahan','1949-06-19');
INSERT INTO MovieInfo (ItemID, Rating, Duration, FullName, Birthdate) VALUES (17929,'G',68,'Holly Callahan','1949-06-19');



INSERT INTO MovieID (ItemID, CopyNumber) VALUES (22699,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (21436,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (64251,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (62476,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (42255,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (72575,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (15703,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (81437,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (28719,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (28684,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (52861,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (44268,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (51067,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (57342,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (63299,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (87380,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (56989,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (27717,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (27717,2);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (35080,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (95517,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (95517,2);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (95517,3);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (95517,4);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (17929,1);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (17929,2);
INSERT INTO MovieID (ItemID, CopyNumber) VALUES (17929,3);