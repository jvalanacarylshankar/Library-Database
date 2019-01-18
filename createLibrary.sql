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

--ALTER VIEW Item_HeldAt_Borrows ADD CONSTRAINT fk_ihab_item FOREIGN KEY (ITEMID, CopyNumber) references Status(ITEMID, CopyNumber) ON DELETE CASCADE;
