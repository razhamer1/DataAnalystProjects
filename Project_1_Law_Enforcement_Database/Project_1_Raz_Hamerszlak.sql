---------------------------------------
---------Project #1-Basic_SQL----------
---------------------------------------

---------------------------------------
------------Raz_Hamerszlak-------------
---------------------------------------
--USE MASTER;

--GO
-----------------------------------------
----CREATE DATABASE Data_Law_Enforce_db------
-----------------------------------------
CREATE DATABASE Data_Law_Enforce_db;

Go

USE Data_Law_Enforce_db;

GO

-----------------------------------------
------TABLE No.1 - Police_Data_Records --   טבלת תיקי משטרה - כלל המידע הנוגע לפרטים בתוך התיק
-----------------------------------------
CREATE TABLE Police_Data_Records
	(Record_ID INT, ---------------------                                                  מספר תיק
	 Open_Record_Date DATE NOT NULL, ----                                         תאריך פתיחת התיק  
	 Event_Record_Date DATE NOT NULL,----                           תאריך האירוע בו בוצעו העבירות             
	 Police_District VARCHAR(30) NOT NULL,--                                      מחוז המשטרה מרחב
	 Police_Station VARCHAR(25), --------                                               תחנת המשטרה                                          
	 State_ID INT NOT NULL, -------------                                  קוד מדינה לה התיק משויך
	 State_ID_Event INT NOT NULL, -------                       קוד מדינת האירוע בה בוצעו העבירות
	 State_Name_Event VARCHAR(20), ------                        שם מדינת האירוע בה בוצעו העבירות
	 City_ID_Event INT, -----------------                         קוד ערי האירוע בה בוצעו העבירות
	 Number_Of_Suspects INT, ------------                                          מספר חשודים בתיק
	 CONSTRAINT rec_id_pk PRIMARY KEY(Record_ID),
	 CONSTRAINT rec_Police_Station_ck CHECK (Police_Station LIKE '%#%PD'), -------  Station Name ends with Police Department
	 CONSTRAINT rec_State_ID_Event_uk UNIQUE (State_ID_Event) -------------------- כל קוד מדינת אירוע הוא ייחודי נשוא העבירות והמעורבים באירוע
	 );
GO

-----------------------------------------
--- Insert_Rows_Police_Data_Records -----
-----------------------------------------
INSERT INTO Police_Data_Records
VALUES  (1, '1993-05-21', '1990-10-13', 'South', 'Station_1#PPD', 12, 112, 'Arizona', 1121, 1),
		(2, '2002-06-30', '1997-08-04', 'West', 'Station_13#LVMPD', 14, 214, 'Nevada', 2142, 3),
		(3, '2004-03-05', '2002-12-25', 'East', 'Station_22#NYPD', 10, 310, 'New_York', 3103, 4),
		(4, '2005-11-22', '2001-05-11', 'South', 'Station_1#PPD', 12, 412, 'Arizona', 4412, 10),
		(5, '2014-02-23', '2012-07-12', 'South', NULL, 16, 516, 'Texas', 5516, NULL),
		(6, '2016-09-15', '2015-05-14', 'South', 'Station_555#SAPD', 16, 616, 'Texas', 6616, 1),
		(7, '2018-10-21', '2016-01-20', 'South', 'Station_555#SAPD', 16, 716, 'Texas', 7716, 2),
		(8, '2007-07-21', '2006-04-11', 'South', 'Station_443#HPD', 16, 816,'Texas', 8816, NULL),
		(9, '1984-05-17', '1974-11-20', 'Center', NULL, 18, 918, 'Colorado', 9918, 3),
		(10, '2013-06-03', '2010-04-02', 'East', 'Station_22#NYPD', 10, 1010, 'New_York', 101010, 1),
		(11, '2000-12-05', '1998-11-10', 'East', 'Station_22#NYPD', 10, 1110, 'New_York', 111011, 4),
		(12, '2001-12-31', '2001-09-11', 'East', 'Station_22#NYPD', 10, 1210, 'New_York', 121012, 15),
		(13, '2009-03-27', '2004-12-15', 'East', 'Station_879#BPD', 22, 1322, 'Maryland', 132213, 1),
		(14, '2013-04-14', '2012-11-10', 'Center', NULL, 18, 1418, 'Colorado', 141418, NULL),
		(15, '2017-08-16', '2016-08-11', 'Center', 'Station_95#CPD', 32, 1532, 'Illinois', 151532, 1),
		(16, '2015-10-29', '2012-11-03', 'Center', 'Station_95#CPD', 32, 1632, 'Illinois', 161632, 1),
		(17, '2008-09-09', '2006-07-12', 'North', 'Station_11#PPD', 45, 1745, 'Pennsylvania', 171745, 2),
		(18, '2015-06-11', '2013-02-16', 'North', 'Station_21#CPD', 47, 1847, 'Ohio', 181847, 1),
		(19, '2003-03-23', '2001-12-13', 'West', 'Station_13#SFPD', 13, 1913, 'California', 191913, 3),
		(20, '2018-06-15', '2005-08-13', 'West','Station_14#LAPD', 13, 2013, 'California', 202013, 2);
GO

-----------------------------------------
--- TABLE No.2 - Police_Data_Offences ---          טבלת עבירות - פרטי העבירות המפורטות עבור כל תיק
-----------------------------------------
CREATE TABLE Police_Data_Offences
	(Federal_Crime_ID INT, --------------                                    מספר פשיעה ברמה הפדרלית
	 Record_ID INT NOT NULL, ------------                                                     מספר תיק
	 Offence_ID_By_Law INT NOT NULL, ----                                   מספר סעיף עבירה לפי החוק
	 Offence_ID_Group INT NOT NULL, -----                                           מספר קבוצת עבירות
	 Offence_Group_Name VARCHAR(40), ----                                            שם קבוצת העבירות
	 Crime_Name VARCHAR(30), ------------                                                    שם העבירה
	 State_ID_Event INT NOT NULL, -------                         קוד מדינת האירוע בה בוצעו העבירות 
	 Prisoner_Inmate_ID INT, ------------                                                קוד עצור/אסיר
	 CONSTRAINT offe_Federal_Crime_id_pk PRIMARY KEY (Federal_Crime_ID),
	 CONSTRAINT offe_Record_ID_fk FOREIGN KEY (Record_ID) REFERENCES Police_Data_Records (Record_ID),
	 CONSTRAINT offe_Offence_Group_Name_ck CHECK (Offence_Group_Name LIKE '%=%'),
	 CONSTRAINT offe_State_ID_Event_fk FOREIGN KEY (State_ID_Event) REFERENCES Police_Data_Records (State_ID_Event)
	 );
 GO

 ----------------------------------------
 --- Insert_Rows_Police_Data_Offences ---
 ----------------------------------------
INSERT INTO Police_Data_Offences
VALUES  (1, 10, 1417, 1400, 'Instrumental=Offences', 'Theft', 1010, NULL),
		(2, 11, 1630, 1600, 'Violent=Offences', 'Robbery', 1110, 2111630),
		(3, 11, 1630, 1600, 'Violent=Offences', 'Robbery', 1110, 3111630),
		(4, 11, 1417, 1400, 'Instrumental=Offences', 'Theft', 1110, 4111417),
		(5, 11, 1640, 1600, 'Violent=Offences', 'Homicide', 1110, 5111640),
		(6, 12, 1815, 1800, 'Terrorism=Offences', 'Global_Terrorism', 1210, NULL),
		(7, 13, 1950, 1900, 'White_Collar=Offences', 'Fraud', 1322, 7131950),
		(8, 13, 1951, 1900, 'White_Collar=Offences', 'Forgery',  1322, 7131950),
		(9, 14, 1640, 1600, 'Violent=Offences', 'Homicide', 1418, NULL),
		(59, 14, 1750, 1700, 'Sexual=Offences', 'Rape', 1418, NULL),
		(10, 15, 1420, 1400, 'Instrumental=Offences', 'Theft_Vehicle', 1532, 10151420),
		(11, 15, 1410, 1400, 'Instrumental=Offences', 'Arson', 1532, 11151410),
		(12, 16, 1635, 1600, 'Violent=Offences', 'Attack',  1632, 12161640),
		(13, 17, 210, 200, 'Computer=Offences', 'Identity_Theft', 1745, 1314210),
		(14, 17, 1951, 1900, 'White_Collar=Offences', 'Forgery', 1745, 1314210),
		(15, 17, 210, 200, 'Computer=Offences', 'Identity_Theft', 1745, 1517210),
		(16, 17, 1951, 1900, 'White_Collar=Offences', 'Forgery', 1745, 1517210),
		(17, 18, 1680, 1600, 'Violent=Offences', 'Killing', 1847, NULL), ----זיכוי אותו חשוד בעבירה ספציפית זו
		(18, 18, 1635, 1600, 'Violent=Offences', 'Attack', 1847, 18181635),
		(19, 19, 1630, 1600, 'Violent=Offences', 'Robbery',1913, 19191630),
		(20, 19, 1635, 1600, 'Violent=Offences', 'Attack', 1913, 19191630),
		(21, 19, 1630, 1600, 'Violent=Offences', 'Robbery',1913, NULL), -----זיכוי אותו חשוד 2 בעבירה ספציפית זו
		(22, 19, 1417, 1400, 'Instrumental=Offences', 'Theft', 1913, 22191417),
		(23, 19, 210, 200, 'Computer=Offences', 'Identity_Theft', 1913, NULL), ------זיכוי אותו חשוד 3 בעבירה ספציפית זו
		(24, 20, 210, 200, 'Computer=Offences', 'Identity_Theft', 2013, 2420210),
		(25, 20, 1950, 1900, 'White_Collar=Offences', 'Fraud', 2013, 25201950),
		(26, 1, 1415, 1400, 'Instrumental=Offences', 'Violation_of_public_order', 112, 2611415),
		(27, 1, 1635, 1600, 'Violent=Offences', 'Attack', 112, 2611415),
		(28, 2, 1640, 1600, 'Violent=Offences', 'Homicide', 214, 2821640),
		(29, 2, 1750, 1700, 'Sexual=Offences', 'Rape', 214, 2821640),
		(30, 2, 1640, 1600, 'Violent=Offences', 'Homicide', 214, 3021640),
		(31, 2, 1750, 1700, 'Sexual=Offences', 'Rape', 214, 3021640),
		(32, 2, 1635, 1600, 'Violent=Offences', 'Attack', 214, NULL), -------זיכוי חשוד 3 בעבירה ספציפית זו
		(33, 3, 220, 200,  'Computer=Offences', 'Blackmail_and_threats', 310 ,333220),
		(34, 3, 210, 200, 'Computer=Offences', 'Identity_Theft', 310, 333220),
		(35, 3, 1950, 1900, 'White_Collar=Offences', 'Fraud', 310, 333220),
		(36, 3, 220, 200,  'Computer=Offences', 'Blackmail_and_threats', 310, 363220),
		(37, 3, 1950, 1900, 'White_Collar=Offences', 'Fraud', 310, 363220),
		(38, 3, 1950, 1900, 'White_Collar=Offences', 'Fraud', 310, 3831950),
		(39, 3, 1950, 1900, 'White_Collar=Offences', 'Fraud', 310, NULL), ------ זיכוי חשוד 4 בעבירה ספציפית זו
		(40, 4, 1815, 1800, 'Terrorism=Offences', 'Global_Terrorism', 412, NULL),
		(41, 5, 1640, 1600, 'Violent=Offences', 'Homicide', 516, NULL), --------- תיק שבו לא ידועים חשודים עבור מספר רב של עבירות
		(42, 5, 1750, 1700, 'Sexual=Offences', 'Rape', 516, NULL),
		(43, 5, 1810, 1600, 'Violent=Offences', 'Human_Traffic', 516, NULL),
		(44, 5, 8900, 8000, 'Drugs=Offences', 'Drug_Self_Use', 516, NULL),
		(45, 5, 1753, 1700, 'Sexual=Offences', 'Pimping', 516, NULL),
		(46, 6, 1630, 1600, 'Violent=Offences', 'Robbery', 616, 4661360),
		(47, 6, 1635, 1600, 'Violent=Offences', 'Attack', 616, 4661360),
		(48, 7, 1420, 1400, 'Instrumental=Offences', 'Theft_Vehicle', 716, 4871420),
		(49, 7, 1635, 1600, 'Violent=Offences', 'Attack', 716, 4871420),
		(50, 7, 1420, 1400, 'Instrumental=Offences', 'Theft_Vehicle', 716, 5071420),
		(51, 8, 1655, 1600, 'Violent=Offences', 'Kidnapping', 816, NULL), --------------------------------- לא ידוע מי החוטף/ים
		(52, 9, 1640, 1600, 'Violent=Offences', 'Homicide', 918, 5291640),
		(53, 9, 1655, 1600, 'Violent=Offences', 'Kidnapping', 918, 5291640),
		(54, 9, 1780, 1700, 'Sexual=Offences', 'Pedophilia', 918, 5291640),
		(55, 9, 1640, 1600, 'Violent=Offences', 'Homicide', 918, 5591640),
		(56, 9, 1655, 1600, 'Violent=Offences', 'Kidnapping', 918, 5591640),
		(57, 9, 1635, 1600, 'Violent=Offences', 'Attack', 918, 5791635),
		(58, 9, 1635, 1600, 'Violent=Offences', 'Attack', 918, 5891635);
GO

-----------------------------------------
--- TABLE No.3 - Police_Involved_Crime --                               טבלת מעורבים בכל תיק - פרטי חשוד/עבריין/קורבן
-----------------------------------------
CREATE TABLE Police_Involved_Crime
	(Involvment_ID INT, -----------------                                                מספר קוד מעורב באירוע העברייני
	 Record_ID INT NOT NULL, ------------                                                                         מספר תיק
	 Type_ID_Involvment INT NOT NULL, ---             מספר קוד מעורב - 10 -עבריין| 11 - קורבן| 13 - חשוד| 15 - טרוריסט
	 Type_Name_Involvment VARCHAR (20) NOT NULL,--                                                        שם סוג המעורבות
	 Prisoner_Inmate_ID INT, ------------                                                                   קוד עצור/אסיר
	 State_ID_Living INT NOT NULL, ------                                                         קוד מדינת מגורי המעורב
	 State_Name_Living VARCHAR(20), -----                                                           שם מדינת מגורי המעורב
	 Phone VARCHAR(30) NOT NULL, --------                                                                מספר טלפון המעורב
	 Employment_Type_ID INT, ------------                                                                קוד עיסוק המעורב
	 Employment_Type_Name VARCHAR(30), --                                                                  שם עיסוק המעורב
	 Income_per_month MONEY, ------------                                                           משכורת המעורב לפי חודש
	 Relate_Involved VARCHAR(30), -------                                                      קשר המעורב לאירוע העברייני
	 Past_Num_Events INT, ---------------                                             מספר אירועים בהם השתתף המעורב בעבר
	 CONSTRAINT Inv_Involvment_ID_pk PRIMARY KEY (Involvment_ID),
	 CONSTRAINT Inv_Record_ID_fk FOREIGN KEY (Record_ID) REFERENCES Police_Data_Records (Record_ID),
	 CONSTRAINT Inv_Phone_ck CHECK (Phone LIKE '%-%'),
	 );
GO

-----------------------------------------
 --- Insert_Rows_Police_Involved_Crime --
 ----------------------------------------
INSERT INTO Police_Involved_Crime
VALUES (1, 11, 10, 'Criminal', 2111630, 10, 'New_York', +10-4578963, 15, 'Shopkeeper', 6500, 'Offender', NULL),
	   (2, 11, 10, 'Criminal', 3111630, 10, 'New_York', +10-3684352, 52, 'Car_Mechanic', 5500, 'Offender', 1),
	   (3, 11, 10, 'Criminal', 4111417, 10, 'New_York', +10-3864354, 15, 'Shopkeeper', 7300, 'Offender', NULL),
	   (4, 11, 10, 'Criminal', 5111640, 10, 'New_York', +10-2539354, 30, 'Security_Guard', 5700,'Offender', 3),
	   (5, 11, 11, 'Victim', NULL, 10, 'New_York', +10-5566446, 45, 'Clinic_Secretary', 10869, 'Victim', NULL),
	   (6, 10, 11, 'Victim', NULL, 10, 'New_York', +10-9843453, 60, 'Teacher', 9800, 'Victim', NULL),
	   (7, 12, 15, 'Criminal_Terrorism', NULL, 95, 'Libya', +11-1111111, NULL, NULL, NULL, 'Terror_Orginization', NULL),
	   (8, 13, 10, 'Criminal', 7131950, 22, 'Maryland', +22-3684356, 90, 'Finance', 19200, 'Offender', NULL),
	   (9, 14, 11, 'Victim', NULL, 18, 'Colorado', +18-9632517, 48, 'Tour_Guide', 15300, 'Victim', NULL),
	   (10, 15, 10, 'Criminal', 10151420, 32, 'Illinois', +32-4542588, 68, 'Farmer', 6800, 'Offender', NULL),
	   (11, 15, 10, 'Criminal', 11151410, 32, 'Illinois', +32-4687584, 68, 'Farmer', 6900, 'Offender', 1),
	   (12, 15, 11, 'Victim', NULL, 32, 'Illinois', +32-9873358, 68, 'Farmer', 9874, 'Victim', NULL),
	   (13, 16, 10, 'Criminal', 12161640, 32, 'Illinois', +32-3126875, 49, 'Fitness_Guide', 11350, 'Offender', 2),
	   (14, 16, 11, 'Victim', NULL, 32, 'Illinois', +32-5687349, 43, 'Therapeutic_Guide', 22568, 'Victim', NULL),
	   (15, 17, 10, 'Criminal', 1314210, 45, 'Pennsylvania', +45-2543687, 65, 'IT_Team', 17654, 'Offender',NULL),
	   (16, 17, 10, 'Criminal', 1517210, 45, 'Pennsylvania', +45-6982543, 65, 'IT_Team', 15978, 'Offender',NULL),
	   (17, 17, 11, 'Victim', NULL, 45, 'Pennsylvania', +45-6983574, 75, 'DevOP', 38621, 'Victim', NULL),
	   (18, 18, 10, 'Criminal', NULL, 47, 'Ohio', +47-3657354, 18, 'Marketing', 17654, 'Suspect', 1),
	   (19, 18, 13, 'Criminal_S', 18181635, 47, 'Ohio', +47-6587753, 52, 'Car_Mechanic', 6500, 'Suspect', 1),
	   (20, 18, 11, 'Victim', NULL, 47, 'Ohio', +47-1268492, 90, 'Finance', 19200, 'Victim', NULL),
	   (21, 19, 10, 'Criminal', 19191630, 13, 'California', +13-3504356, 15, 'Shopkeeper', 7890, 'Offender', 1),
	   (22, 19, 13, 'Criminal_S', NULL, 13, 'California', +13-7025893, 18, 'Marketing', 11248, 'Suspect', NULL),
	   (23, 19, 10, 'Criminal', 22191417, 13, 'California', +13-3384398, 90, 'Finance', 17235, 'Offender', NULL),
	   (24, 19, 13, 'Criminal_S', NULL, 13, 'California', +13-1596873, 65, 'IT_Team', 16875, 'Suspect', NULL),
	   (25, 19, 11, 'Victim', NULL, 13, 'California', +13-3687192, 87, 'Bank_manager', 45986, 'Victim', NULL),
	   (26, 19, 11, 'Victim', NULL, 13, 'California', +13-3698766, 85, 'Bank_clerk', 22745, 'Victim', NULL),
	   (27, 20, 10, 'Criminal' ,2420210, 13, 'California', +13-2557423, 75, 'DevOP', 25469, 'Offender', NULL), 
	   (28, 20, 10, 'Criminal' ,25201950, 13, 'California', +13-3813913, 90, 'Finance', 18365, 'Offender', NULL),
	   (29, 20, 11, 'Victim', NULL, 13, 'California', +13-2937899, 85, 'Bank_clerk', 18452, 'Victim', NULL),
	   (30, 1, 10,  'Criminal', 2611415, 12, 'Arizona', +12-3684135, 15, 'Shopkeeper', 8962, 'Offender', 2),
	   (31, 1, 11,  'Victim', NULL, 12, 'Arizona', +12-6873436, 100, 'Police_Officer', 9467, 'Victim', NULL),
	   (32, 2, 10,  'Criminal', 2821640, 14, 'Nevada', +14-3543335, 68, 'Farmer', 5236, 'Offender', 2), 
	   (33, 2, 10,  'Criminal', 3021640, 14, 'Nevada', +14-2583698, 49, 'Fitness_Guide', 9865, 'Offender', 2), 
	   (34, 2, 13,  'Criminal_S', NULL, 14, 'Nevada', +14-3364587, 68, 'Farmer', 4216, 'Suspect' , NULL),
	   (35, 3, 10,  'Criminal', 333220, 10, 'New_York', +10-3874364, 75, 'DevOP', 25649,'Offender', NULL), 
	   (36, 3, 10,  'Criminal', 363220, 10, 'New_York', +10-1368743, 90, 'Finance', 17654, 'Offender', NULL), 
	   (37, 3, 10,  'Criminal', 3831950, 10, 'New_York', +10-983669, 18, 'Marketing', 13658, 'Offender',NULL), 
	   (38, 3, 13,  'Criminal_S', NULL, 10, 'New_York', +10-3984344, 90, 'Finance', 19324, 'Suspect', NULL),
	   (39, 3, 11,  'Victim', NULL, 10, 'New_York', +10-4368975, 81, 'Insurance_company_clerk', 12354, 'Victim', NULL),
	   (40, 4, 15,  'Criminal_Terrorism', NULL, 12, 'Arizona', +12-1111111, NULL, NULL, NULL, 'Terror_Orginization', NULL),
	   (41, 5, 11,  'Victim', NULL, 16, 'Texas', +16-2687165, NULL, NULL, NULL, 'Victim', NULL),
	   (42, 5, 11,  'Victim',  NULL, 16, 'Texas', +16-3174525, 60, 'Teacher',6789, 'Victim', NULL),
	   (43, 5, 11,  'Victim',  NULL, 16, 'Texas', +16-2364863, 15, 'Shopkeeper', 9782, 'Victim', NULL),
	   (44, 5, 11,  'Victim',  NULL, 16, 'Texas', +16-6974520, NULL, NULL, NULL, 'Victim', NULL),
	   (45, 6, 10,  'Criminal', 4661360, 16, 'Texas', +16-5612039, 52, 'Car_Mechanic', 9542, 'Offender', 1), 
	   (46, 6, 11,  'Victim',  NULL, 16, 'Texas', +16-4213335, 41, 'Waitress', 5321, 'Victim', NULL),
	   (47, 7, 10,  'Criminal', 4871420, 16, 'Texas', +16-2135194, 52, 'Car_Mechanic', 4879, 'Offender', 2), 
	   (48, 7, 10,  'Criminal', 5071420,  16, 'Texas', +16-321687, 53,  'Flight_Mechanic', 5879, 'Offender', 1), 
	   (49, 7, 11,  'Victim',  NULL, 16, 'Texas', +16-3876932, 68, 'Farmer', 9321, 'Victim', NULL),
	   (50, 8, 11,  'Victim',  NULL, 16, 'Texas', +16-4822105, NULL, NULL, NULL, 'Victim', NULL),
	   (51, 8, 11,  'Victim',  NULL, 16, 'Texas',  +16-4161819, NULL, NULL, NULL, 'Victim', NULL),
	   (52, 9, 10,  'Criminal', 5291640, 18, 'Colorado', +18-3841168, 18, 'Marketing', 10950, 'Offender', 2), 
	   (53, 9, 10,  'Criminal', 5791635, 18, 'Colorado', +18-4836541, 48, 'Tour_Guide', 10234, 'Offender', 1), 
	   (54, 9, 10,  'Criminal', 5891635, 18, 'Colorado', +18-4488763, 52, 'Car_Mechanic', 8654, 'Offender', 1), 
	   (55, 9, 11,  'Victim',  NULL, 18, 'Colorado', +18-8754318, NULL, NULL, NULL, 'Victim', NULL),
	   (56, 9, 11,  'Victim',  NULL, 18, 'Colorado', +18-1887351, NULL, NULL, NULL, 'Victim', NULL),
	   (57, 9, 11,  'Victim',  NULL, 18, 'Colorado', +18-3489513, NULL, NULL, NULL, 'Victim', NULL);
	   GO

-----------------------------------------------
---TABLE No.4 - Police_Correction_Prisonment---                                        טבלת פרטי עצורים/אסירים
-----------------------------------------------
CREATE TABLE Police_Correction_Prisonment
	(Prisoner_Inmate_ID INT, ------------------                                                    קוד עצור/אסיר
	 Entrance_Date DATE NOT NULL, -------------                                          תאריך כניסה למעצר/מאסר
	 Release_Date DATE, -----------------------                                          תאריך שחרור ממעצר/מאסר
	 Birth_Date_Prisoner DATE, ----------------                                          תאריך הולדת העצור/אסיר
	 Correction_Facility_ID INT NOT NULL, -----                                                   קוד מתקן כליאה
	 Security_Wing_Level_ID INT NOT NULL, -----                                               קוד רמת אבטחה באגף
	 Type_Prisoner_Inmate_ID INT NOT NULL, ----                                         קוד סוג אסיר - עצור/אסיר
	 Type_Prisoner_Inmate_Name VARCHAR (20) NOT NULL, --                                 שם סוג אסיר - עצור/אסיר
	 Security_Wing_Level VARCHAR (10) NOT NULL, --                                       שם האגף לפי רמות האבטחה
	 Treatment_Rehab_Program_Name VARCHAR(30), --                                                 שם תוכנית שיקום
	 Emp_Name_Prison VARCHAR(30), -------------                                       שם תעסוקת העצור/אסיר במאסר
	 Income_Prisoner_Per_Month MONEY, ---------                                       הכנסת האסיר במאסר לפי חודש
	 Expenses_Prisoner_Per_Month MONEY, -------                                      הוצאות האסיר במאסר לפי חודש
	 Min_Penalty_By_Law INT, ------------------          מספר חודשי מאסר מינימלי שניתן לקבל בגין העבירה החמורה
	 Max_Penalty_By_Law INT, ------------------        מספר חודשי המאסר המקסימלי שניתן לקבל בגין העבירה החמורה
	 CONSTRAINT Corr_Prisoner_Inmate_ID_pk PRIMARY KEY (Prisoner_Inmate_ID),
	 CONSTRAINT Corr_Min_Penalty_By_Law_ck CHECK (Min_Penalty_By_Law>=12) --- מינימום חודשי המאסר שהוגדרו עומד על 12 חודשים
	 );
GO

-----------------------------------------------
----Insert_Rows_Police_Correction_Prisonment -- 
-----------------------------------------------
INSERT INTO Police_Correction_Prisonment
VALUES  (2111630, '1994-05-03', '2004-11-20', '1974-08-12', 10327, 656, 1, 'Prisoner', 'B', NULL, 'Carpentry_workshop', 1230, 450, 24, 180),
		(3111630, '2003-03-12', '2007-10-11', '1980-05-26', 10327, 656, 1, 'Prisoner', 'B', NULL, 'Laundry', 732, 260, 24, 180),
		(4111417, '2001-06-19', '2001-07-02', '1982-04-20', 10327, 757, 1, 'Prisoner', 'C', NULL, 'Kitchen', 385, 236, 12, 36),
		(5111640, '2001-07-23', '2026-06-13', '1983-03-13', 10327, 666, 1, 'Prisoner', 'A', NULL, NULL, NULL, NULL, 240, 480),
		(7131950, '2010-02-18', '2022-03-30', '1988-09-05', 22497, 757, 1, 'Prisoner', 'C', NULL, 'Kitchen', 450, 365, 120, 240),
		(10151420,'2018-12-20', '2019-12-10', '1993-01-24', 32577, 777, 2, 'Un_Arrest','D', NULL, NULL, NULL, NULL, 12, NULL),
		(11151410,'2018-11-28', '2019-12-22', '1990-05-17', 32577, 777, 2, 'Un_Arrest','D', NULL, NULL, NULL, NULL, 13, NULL),
		(12161640,'2017-07-07', '2023-03-02', '1995-09-30', 32577, 666, 1, 'Prisoner', 'A', NULL, 'Laundry', 630, 224, 24, 240),
		(1314210, '2010-05-15', '2020-06-17', '1998-04-19', 45277, 757, 1, 'Prisoner', 'C', NULL, 'Carpentry_workshop', 1015, 452, 12, 120), 
		(1517210, '2010-07-13', '2015-08-12', '1997-03-11', 45277, 757, 1, 'Prisoner', 'C', NULL, 'Kitchen', 347, 230, 12, 120),
		(18181635,'2016-09-11', '2021-07-03', '1992-05-05', 47297, 777, 2, 'Un_Arrest','D', NULL, NULL, NULL, NULL, 24, NULL),
		(19191630,'2004-02-08', '2024-04-13', '1991-08-11', 13227, 656, 1, 'Prisoner', 'B', NULL, 'Laundry', 654, 321, 24, 240),
		(22191417,'2004-01-19', '2007-12-31', '1982-02-24', 13227, 757, 1, 'Prisoner', 'C', NULL, 'Kitchen', 443, 233, 12, 36),
		(2420210, '2019-06-30', '2026-02-26', '1996-08-07', 13227, 757, 1, 'Prisoner', 'C', NULL, 'Laundry', 785, 356, 12, 120),
		(25201950,'2020-03-12', '2028-01-14', '1997-03-15', 13227, 656, 1, 'Prisoner', 'B', NULL, 'Teacher', 1546, 435,12, 120),
		(2611415, '1995-11-22', '1998-09-09', '1972-06-12', 12397, 777, 2, 'Un_Arrest','D', NULL, NULL, NULL, NULL, 240, NULL),
		(2821640, '2001-12-19', '2031-10-03', '1971-07-11', 14357, 878, 1, 'Prisoner', 'E', 'Sexual_Treatment_Group', 'Laundry', 695, 423, 240, 480),
		(3021640, '2001-03-14', '2031-02-05', '1976-02-02', 14357, 878, 1, 'Prisoner', 'E', 'Sexual_Treatment_Group', 'Carpentry_workshop', 1200, 450, 240, 480),
		(333220,  '2005-11-12', '2025-10-10', '1985-01-16', 10327, 757, 1, 'Prisoner', 'C', NULL, 'Teacher', 1845, 756, 12, 120),
		(363220,  '2006-05-17', '2026-08-16', '1986-05-15', 10327, 757, 1, 'Prisoner', 'C', NULL, 'Teacher', 1324, 536, 12, 120),
		(3831950, '2005-10-15', '2010-09-18', '1985-06-23', 10327, 757, 1, 'Prisoner', 'C', NULL, 'Kitchen', 569, 354, 12, 120),
		(4661360, '2017-04-17', '2032-11-12', '1998-06-22', 16257, 656, 1, 'Prisoner', 'B', NULL, 'Kitchen', 423, 215, 24, 180),
		(4871420, '2019-12-20', '2021-10-11', '1998-11-08', 16257, 656, 1, 'Prisoner', 'B', NULL, 'Laundry', 674, 452, 24, 180),
		(5071420, '2019-11-11', '2020-05-11', '1996-10-01', 16257, 656, 1, 'Prisoner', 'C', NULL, 'Kitchen', 443, 235, 12, 36),
		(5291640, '1985-04-20', '2025-03-10', '1962-05-13', 18467, 878, 1, 'Prisoner', 'E', 'Sexual_Treatment_Group', NULL, NULL, NULL, 240, 480),
		(5791635, '1985-02-12', '2005-01-14', '1965-03-11', 18467, 878, 1, 'Prisoner', 'A', NULL, 'Laundry', 600, 255, 240, 480),
		(5891635, '1985-04-22', '1995-08-13', '1963-02-13', 18467, 878, 1, 'Prisoner', 'B', NULL, 'Kitchen', 425, 365, 120, 240);
GO

-----------------------------------------------
-----TABLE No.5 - Police_Prison_Details--------                                            טבלת מתקני כליאה ותקון - פרטי מוסדות כליאה
-----------------------------------------------
CREATE TABLE Police_Prison_Details
	(Correction_Facility_ID INT, --------------                                                                      קוד מספר מתקן כליאה
	 Correction_Facility_Name VARCHAR(30), ----                                                                             שם מתקן כליאה
	 Security_Level_Position VARCHAR (10) NOT NULL,--                                                              רמת אבטחת מוסד הכליאה 
	 Cell_Size FLOAT(2), ----------------------                                                         גודל מרחב מחיה לפי מטרים רבועים
	 Income_Correction_Per_Month MONEY NOT NULL,-----                           הכנסת הכלא רק מהנתח של שכר האסיר בעבודה בכלא לפי חודש
	 Expenses_Correction_Per_Month MONEY NOT NULL, --                                          הוצאות הכלא מתוך כלל הנתח של שכר האסירים 
	 CONSTRAINT Pris_Correction_Facility_ID_pk PRIMARY KEY (Correction_Facility_ID),
	 CONSTRAINT Pris_Cell_Size_ck CHECK (Cell_Size >=4.5)); -------------------------   תקן הבינלאומי עומד על כך שמרחב מחייה לא יפחת מ4.5 מטרים רבועים לאסיר
GO

----------------------------------------
----Insert_Rows_Police_Prison_Details --                                       
----------------------------------------
INSERT INTO Police_Prison_Details
VALUES  (10327, 'New_York_Prison', 'Medium', 4.5, 236000, 164322),
		(22497, 'Maryland_Prison', 'Medium', 4.8, 458651, 256031),
		(32577, 'Illinois_Prison', 'Medium', 4.7, 244985, 122356),
		(45277, 'Pennsylvania_Prison', 'Medium', 4.5, 364255, 123689),
		(47297, 'Ohio_Prison', 'Medium', 4.9, 269023, 168235),
		(13227, 'California_Prison', 'Maximum', 6, 597230, 423987),
		(12397, 'Arizona_Prison', 'Medium', 5.2, 368153, 198563),
		(14357, 'Nevada_Prison', 'Maximum', 4.9, 652301, 489621),
		(16257, 'Texas_Prison', 'Maximum', 4.5, 300245, 213465),
		(18467, 'Colorado', 'Maximum', 6.2, 642305, 438971),
		(10222, 'New_York_Prison', 'Maximum', 5.3, 439789, 320146), 
		(22888, 'Maryland_Prison', 'Maximum', 6.1, 765426, 531025),
		(32555, 'Illinois_Prison', 'Maximum', 4.6, 369210, 269214),
		(45777, 'Pennsylvania_Prison', 'Maximum', 4.8, 321658, 189620),
		(47222, 'Ohio_Prison', 'Maximum', 4.5, 468952, 306497),
		(13666, 'California_Prison', 'Medium', 6, 432056, 354621),
		(12333, 'Arizona_Prison', 'Maximum', 4.8, 432697, 305632),
		(14888, 'Nevada_Prison', 'Medium', 5.3, 369702, 232410),
		(16999, 'Texas_Prison', 'Medium', 4.7, 420367, 231547),
		(18333, 'Colorado', 'Maximum', 6.3, 563210, 430975);
GO

-------------------------------
---SELECT_ALL_FOR_ALL_TABLES---
-------------------------------
select *
from Police_Data_Records

select *
from Police_Data_Offences

select *
from Police_Involved_Crime

select *
from Police_Correction_Prisonment

select *
from Police_Prison_Details

----------------------------------------------------------------------
---ALTER_ADD_CONSTRAINT FK FOR TABLE#3 - Inv_Prisoner_Inmate_ID_fk1---
----------------------------------------------------------------------
ALTER TABLE Police_Involved_Crime
ADD CONSTRAINT Inv_Prisoner_Inmate_ID_fk1 FOREIGN KEY (Prisoner_Inmate_ID) REFERENCES Police_Correction_Prisonment (Prisoner_Inmate_ID); 
GO

--------------------------------------------------------------------------
---ALTER_ADD_CONSTRAINT FK FOR TABLE#4 - Corr_Correction_Facility_ID_fk---
--------------------------------------------------------------------------
ALTER TABLE Police_Correction_Prisonment
ADD CONSTRAINT Corr_Correction_Facility_ID_fk FOREIGN KEY (Correction_Facility_ID) REFERENCES Police_Prison_Details (Correction_Facility_ID);
GO