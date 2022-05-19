CREATE TABLE Postcode(
	PKPostcode_Postcode 	Numeric(4,0) PRIMARY KEY 		NOT NULL Check(LENGTH(PKPostcode_Postcode::Text)=4),
	Postcode_City			Varchar(64)						NOT NULL		
);
CREATE TABLE Owner(
	PKOwner_CVR 			Numeric(8,0) PRIMARY KEY 		NOT NULL 	CHECK(LENGTH(PKOwner_CVR::Text) = 8),
	Owner_Email 			Varchar(128) 					NOT NULL	CHECK(Owner_Email LIKE '%_@_%.__%'),
	Owner_FName				Varchar(64)						NOT NULL,
	Owner_LName				Varchar(64)						NOT NULL,
	Owner_No				Integer							NOT NULL	CHECK(Owner_No >= 0),
	Owner_StreetName		Varchar(64)						NOT NULL,
	FKPostcode_Owner_Postcode Numeric(4,0)					NOT NULL REFERENCES Postcode    ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Phone(
	FKOwner_CVR 			Numeric(8,0)					REFERENCES Owner    ON DELETE CASCADE ON UPDATE CASCADE,
	Phone_Phone				Numeric(8,0)					NOT NULL	CHECK(LENGTH(Phone_Phone::Text) = 8)
);
CREATE TABLE Farm(
	PKFarm_PNumber_Id		Numeric(8,0) PRIMARY KEY		NOT NULL,
	Farm_Name				Varchar(64),
	Farm_No					Integer							NOT NULL 	CHECK(Farm_No>=0),
	Farm_StreetName			Varchar(64)						NOT NULL,
	FKPostcode				Numeric(4,0)					NOT NULL REFERENCES Postcode    ON DELETE CASCADE ON UPDATE CASCADE,
	FKOwner_CVR				Numeric(8,0)					NOT NULL REFERENCES Owner       ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE ChrNo(
	FKFarm_ChrNo_PNumber	Numeric(8,0)					NOT NULL REFERENCES Farm        ON DELETE CASCADE ON UPDATE CASCADE,
	ChrNo_ChrNo				Varchar(6)						NOT NULL 	CHECK(LENGTH(ChrNo_ChrNo)= 4 OR LENGTH(ChrNo_ChrNo)= 5 OR LENGTH(ChrNo_ChrNo)= 6  )
);
CREATE TABLE Stall(
	PKStall_No 				SERIAL	PRIMARY KEY,
	FKFarm_PNumber			Numeric(8,0)					NOT NULL REFERENCES Farm ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Box(
	PKBox_No				SERIAL PRIMARY KEY 				NOT NULL 	CHECK(PKBox_No >= 0),
	Box_Outdoor				Boolean							NOT NULL,
	Box_Type				Varchar(64)						NOT NULL CHECK(Box_Type in ('Big', 'Medium','Small')),
	FKStall					Integer							NOT NULL REFERENCES Stall   ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE SmartUnit(
	PKSmartUnit_SerialNumber Varchar(6) PRIMARY KEY NOT NULL 
	CHECK(LENGTH(PKSmartUnit_SerialNumber) = 6),
	SmartUnit_Macaddress Varchar(12),
	SmartUnit_Ipaddress Varchar(64) 
	CHECK(SmartUnit_Ipaddress LIKE '%.%.%.%'),
	SmartUnit_Type Varchar(64) NOT NULL
);

CREATE TABLE StallMonitor(
	FKStall_No Integer NOT NULL REFERENCES Stall(PKStall_No),
	FKSmartUnit_SerialNumber Varchar(6) NOT NULL REFERENCES SmartUnit(PKSmartUnit_SerialNumber)
);

CREATE TABLE State(
	PKState_Id SERIAL PRIMARY KEY NOT NULL,
	State_Severity Numeric(3,0) NOT NULL
);

CREATE TABLE Changes(
	Changes_Time timestamp NOT NULL,
	FKSmartUnit_SmartUnitSerialNumber Varchar(6) NOT NULL REFERENCES SmartUnit(PKSmartUnit_SerialNumber),
	FKState_Id Integer NOT NULL REFERENCES State(PKState_Id)
);

CREATE TABLE BoxMonitor(
	BoxMonitor_Value integer NOT NULL,
	BoxMonitor_Time timestamp NOT NULL,

	FKBox_BoxNo Integer NOT NULL REFERENCES Box(PKBox_No),
	FKSmartUnit_UnitSerialNumber Varchar(6) NOT NULL REFERENCES SmartUnit(PKSmartUnit_SerialNumber)
);

CREATE TABLE Animal(
	PKAnimal_EarMarkId SERIAL PRIMARY KEY NOT NULL,
	Animal_EarMarkChrNo Varchar(6) CHECK(LENGTH(Animal_EarMarkChrNo) = 5 OR LENGTH(Animal_EarMarkChrNo) = 6),
	Animal_Sex CHAR(1) NOT NULL CHECK(Animal_Sex in ('F', 'M')),
	Animal_Birth Date,
	Animal_Death BOOLEAN NOT NULL CHECK(Animal_Birth < CURRENT_DATE),
	Animal_EarmarkColor Varchar(16) NOT NULL CHECK(Animal_EarmarkColor in ('Red', 'Yellow','White')),
	Animal_Type Numeric(2,0) NOT NULL CHECK(Animal_Type in (12, 13, 15)),

	FKAnimal_Produce Integer REFERENCES Animal(PKAnimal_EarMarkId)
);

CREATE TABLE AnimalLivesInBox(
	AnimalLivesInBox_MoveInTime timestamp ,
	AnimalLivesInBox_MoveOutTime timestamp ,

	FKAnimal_EarMark Integer NOT NULL REFERENCES Animal(PKAnimal_EarMarkId),
	FKBox_No Integer NOT NULL REFERENCES Box(PKBox_No)
);






