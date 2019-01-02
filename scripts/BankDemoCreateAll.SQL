/****************************************************************************
*****************************************************************************
*
*  Copyright (C) Micro Focus 2018. All rights reserved.
*
*  This sample code is supplied for demonstration purposes only on an "as is" 
*  basis and is for *use at your own risk.
*
*****************************************************************************
****************************************************************************/

/* ------------------------------------------------- */
/* Bankdemo DB2 DDL adapted for Microsoft SQL Server */
/* ------------------------------------------------- */


IF EXISTS(SELECT * from SYS.DATABASES where NAME='BANKDEMO')
	DROP DATABASE BANKDEMO

go
CREATE DATABASE BANKDEMO

go

use BANKDEMO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Create a stored procedure that is used to demonstrate TSQL debugging 
*/
CREATE PROCEDURE [dbo].[CreateEmpDb]
	
AS
BEGIN

DROP TABLE [dbo].[employees]

CREATE TABLE [dbo].[employees](
	[employee_id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[full_name] [nvarchar](75) NULL,
	[gender] [nvarchar](6) NULL,
	[department] [nvarchar](25) NULL,
	[position] [nvarchar](50) NULL,
	[salary] [float] NULL,
 CONSTRAINT [PK_employees] PRIMARY KEY CLUSTERED 
(
	[employee_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

/* if you wish the mdf file to be located anywhere other than default, use the following block, and also uncomment the
ON BANKDEMOFGR on the create table operations*/

/*ALTER DATABASE BANKDEMO
ADD FILEGROUP BANKDEMOFGR

ALTER DATABASE BANKDEMO
ADD FILE
    (
         NAME = BANKDEMOF1,
         FILENAME='C:\Rex\Demos\BANKDEMO\BANKDEMO1.MDF',
         SIZE=2MB,
         MAXSIZE=UNLIMITED,
         FILEGROWTH=1MB )
TO FILEGROUP BANKDEMOFGR

go
*/

/* if doing this in the SQL Azure management portal, create your BANKDEMO database using the azure portal,
   then enter the database management portal for the BANKDEMO database, and then copy below this 
   comment to the end of file, and paste into a new query in the azure portal and then execute */
CREATE TABLE [dbo].[BNKCUST]

(
    BCS_PID                   CHAR(5) NOT NULL,
    BCS_NAME                  CHAR(25) NOT NULL,
    BCS_NAME_FF               CHAR(25) NOT NULL,
    BCS_SIN                   CHAR(9) NOT NULL DEFAULT ' ',
    BCS_ADDR1                 CHAR(25) NOT NULL DEFAULT ' ',
    BCS_ADDR2                 CHAR(25) NOT NULL DEFAULT ' ',
    BCS_STATE                 CHAR(2) NOT NULL DEFAULT ' ',
    BCS_COUNTRY               CHAR(6) NOT NULL DEFAULT ' ',
    BCS_POST_CODE             CHAR(6) NOT NULL DEFAULT ' ',
    BCS_TEL                   CHAR(12) NOT NULL DEFAULT ' ',
    BCS_EMAIL                 CHAR(30) NOT NULL DEFAULT ' ',
    BCS_SEND_MAIL             CHAR(1) NOT NULL DEFAULT ' ',
    BCS_SEND_EMAIL            CHAR(1) NOT NULL DEFAULT ' ',
    BCS_FILLER                CHAR(78) NOT NULL DEFAULT ' ',
    PRIMARY KEY (BCS_PID)
)
/*ON BANKDEMOFGR*/

CREATE UNIQUE INDEX BNKCUST_IDX1 ON [dbo].[BNKCUST]
(
     BCS_PID
)
/*ON BANKDEMOFGR*/


CREATE INDEX BNKCUST_IDX2 ON [dbo].[BNKCUST]
(
     BCS_NAME
)
/*ON BANKDEMOFGR*/


CREATE INDEX BNKCUST_IDX3 ON [dbo].[BNKCUST]
(
     BCS_NAME_FF
)
/*ON BANKDEMOFGR*/




CREATE TABLE [dbo].[BNKATYPE]
(
    BAT_TYPE                  CHAR(1) NOT NULL,
    BAT_DESC                  CHAR(15) NOT NULL,
    BAT_FILLER                CHAR(84) NOT NULL,
    PRIMARY KEY (BAT_TYPE)
)
/*ON BANKDEMOFGR*/
CREATE UNIQUE  INDEX BNKATYPE_IDX ON [dbo].[BNKATYPE]
(
     BAT_TYPE
)
/*ON BANKDEMOFGR*/
CREATE TABLE [dbo].[BNKACC]
(
    BAC_PID                   CHAR(5) NOT NULL,
    BAC_ACCNO                 CHAR(9) NOT NULL DEFAULT ' ',
    BAC_ACCTYPE               CHAR(1) NOT NULL DEFAULT ' ',
    BAC_BALANCE               DECIMAL(9,2) NOT NULL DEFAULT 0,
    BAC_LAST_STMT_DTE         CHAR(10) NOT NULL DEFAULT
    substring(convert(char (10),getdate(),21),1,10),
    BAC_LAST_STMT_BAL         DECIMAL(9,2) NOT NULL DEFAULT 0,
    BAC_FILLER                CHAR(65) NOT NULL DEFAULT ' ',
    BAC_ATM_ENABLED           CHAR(2) NOT NULL,
    BAC_ATM_DAY_LIMIT	      DECIMAL(3, 0) NOT NULL,
    BAC_ATM_DAY_DTE           DATE NOT NULL,
    BAC_ATM_DAY_AMT	          DECIMAL(3, 0) NOT NULL,
    BAC_RP1_DAY               CHAR(2) NOT NULL,
    BAC_RP1_AMOUNT            DECIMAL(7, 2) NOT NULL,
    BAC_RP1_PID               CHAR(5) NOT NULL,
    BAC_RP1_ACCNO             CHAR(9) NOT NULL,
    BAC_RP1_LAST_PAY          DATE NOT NULL,
    BAC_RP2_DAY               CHAR(2) NOT NULL,
    BAC_RP2_AMOUNT            DECIMAL(7, 2) NOT NULL,
    BAC_RP2_PID               CHAR(5) NOT NULL,
    BAC_RP2_ACCNO             CHAR(9) NOT NULL,
    BAC_RP2_LAST_PAY          DATE NOT NULL,
    BAC_RP3_DAY               CHAR(2) NOT NULL,
    BAC_RP3_AMOUNT            DECIMAL(7, 2) NOT NULL,
    BAC_RP3_PID               CHAR(5) NOT NULL,
    BAC_RP3_LAST_PAY          DATE NOT NULL,
    BAC_RP3_ACCNO             CHAR(9) NOT NULL,
    CONSTRAINT BAC_PRIM
    PRIMARY KEY (BAC_ACCNO),
    CONSTRAINT BAC_CUST
    FOREIGN KEY (BAC_PID)
            REFERENCES [dbo].[BNKCUST] (BCS_PID),
    CONSTRAINT BAC_TYPE
    FOREIGN KEY (BAC_ACCTYPE)
            REFERENCES [dbo].[BNKATYPE] (BAT_TYPE)

)
/*ON BANKDEMOFGR*/
CREATE UNIQUE  INDEX BNKACC_IDX1 ON [dbo].[BNKACC]
(
     BAC_ACCNO
)
/*ON BANKDEMOFGR*/


CREATE INDEX BNKACC_IDX2 ON [dbo].[BNKACC]
(
     BAC_PID
)
/*ON BANKDEMOFGR*/


CREATE TABLE [dbo].[BNKTXN]
(
    BTX_PID                   CHAR(5) NOT NULL,
    BTX_TYPE                  CHAR(1) NOT NULL,
    BTX_SUB_TYPE              CHAR(1) NOT NULL,
    BTX_ACCNO                 CHAR(9),
    BTX_TIMESTAMP             CHAR(26) NOT NULL
    DEFAULT REPLACE(REPLACE(CONVERT(CHAR(26),CURRENT_TIMESTAMP,121),' ','-') +
    RIGHT(CAST(RAND() as DECIMAL(4,3)),3),':','.'),
    BTX_TIMESTAMP_FF          CHAR(26) NOT NULL  DEFAULT ' ',
    BTX_AMOUNT                DECIMAL(9,2) NOT NULL DEFAULT 0,
    BTX_DATA_OLD              CHAR(150) NOT NULL DEFAULT ' ',
    BTX_DATA_NEW              CHAR(150) NOT NULL DEFAULT ' ',
    BTX_FILLER                CHAR(27) NOT NULL DEFAULT ' ',
    CONSTRAINT BTX_CUST
    FOREIGN KEY  (BTX_PID)
            REFERENCES [dbo].[BNKCUST] (BCS_PID),
    CONSTRAINT BTX_ACCT
    FOREIGN KEY  (BTX_ACCNO)
            REFERENCES [dbo].[BNKACC] (BAC_ACCNO)
)
/*ON BANKDEMOFGR*/

CREATE CLUSTERED INDEX BNKTXN_IDX1 ON [dbo].[BNKTXN]
(
     BTX_ACCNO
)
/*ON BANKDEMOFGR*/
CREATE TABLE [dbo].[TTEXT]
(
    TX_PAGE                CHAR(7) NOT NULL,
    TX_SUB_PAGE            CHAR(1) NOT NULL,
    TX_LINE                CHAR(2) NOT NULL,
    TX_TEXT                CHAR(75) NOT NULL
)
/*ON BANKDEMOFGR*/
CREATE clustered index TTEXT_IDX1 on [dbo].[TTEXT] ( TX_PAGE,TX_SUB_PAGE,TX_LINE)

CREATE TABLE [dbo].[BNKHELP]
(
    BHP_SCRN               CHAR(6) NOT NULL,
    BHP_LINE               CHAR(2) NOT NULL,
    BHP_TEXT               CHAR(75) NOT NULL
)
/*ON BANKDEMOFGR*/
CREATE UNIQUE CLUSTERED INDEX BNKHELP_IDX1 ON [dbo].[BNKHELP]
(
     BHP_SCRN,
     BHP_LINE
)


go

CREATE VIEW [dbo].VBNKDETS
   (VPID, 
    VNAME,
    VADDR1,
    VADDR2, 
    VSTATE,
    VCNTRY,
    VPSTCDE, 
    VACCNO, 
    VDESC, 
    VCURRBAL,
    VLASTSTMTDTE,
    VLASTSTMTBAL) AS 
  SELECT A.BCS_PID, 
         A.BCS_NAME, 
         A.BCS_ADDR1,
         A.BCS_ADDR2, 
         A.BCS_STATE,
         A.BCS_COUNTRY,
         A.BCS_POST_CODE, 
         B.BAC_ACCNO, 
         C.BAT_DESC, 
         B.BAC_BALANCE,
         B.BAC_LAST_STMT_DTE,
         B.BAC_LAST_STMT_BAL
  FROM [dbo].[BNKCUST] A, 
       [dbo].[BNKACC] B, 
       [dbo].[BNKATYPE] C
  WHERE (A.BCS_PID = B.BAC_PID) AND  
        (B.BAC_ACCTYPE = C.BAT_TYPE) 
go
/* Load data into the tables */

INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0001','FRED BLOGGS              ',' ','123456789','722 PARKLAND AVE         ','MISSISSAUGA              ','ON','CANADA','L5H3G8','800-555-1234',' ','N','N',' ')
   INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0002','LORETTA MODERN           ',' ',   '198463794',   '22 SILVER SPRINGS MEWS NW',   'CALGARY                  ',   'AB',   'CANADA',   'T3B3R3',   '800-555-3854',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0003','ELEANOR RIGBY            ',' ',   '493768396',   '5 FOLCROFT AVE           ',   'TORONTO                  ',   'ON',   'CANADA',   'M1N1K7',   '800-555-3857',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0004','DESMOND JONES            ',' ',   '329471287',   '675 OTTER CRES           ',   'PRINCE GEORGE            ',   'BC',   'CANADA',   'V2M5G8',   '800-555-1029',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0005','FELICITY ARKWRIGHT       ',' ',   '918746356',   '910 DES PINS RU          ',   'MASCOUCHE                ',   'QC',   'CANADA',   'J7L1J3',   '800-555-8275',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0006','JAMES TIBERIUS KIRK      ',' ',   '111222333',   '12057 PIERRE BLANCHET AV ',   'MONTREAL                 ',   'QC',   'CANADA',   'H1E3P3',   '800-555-1701',   ' ','N','N',' ')  
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0007','MARK THYME               ',' ',   '837567892',   '21 CARSON AVE            ',   'ST. JOHN"S               ',   'NF',   'CANADA',   'A1E1R9',   '800-555-4434',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0008','TIMOTHY HAYE             ',' ',   '910587636',   '300 WILLOW ST            ',   'NEWCASTLE                ',   'NB',   'CANADA',   'E1V2Z9',   '800-555-9910',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0009','HERR BARBER              ',' ',   '987654321',   '5900 ATLANTIC ST         ',   'HALIFAX                  ',   'NS',   'CANADA',   'B3H1H2',   '800-555-8745',   ' ','N','N',' ')
   
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0010','BARBARA ALLEN            ',' ',   '758643565',   '62 HAZLEWOOD CRES        ',   'BRANDON                  ',   'MB',   'CANADA',   'R7A2J9',   '800-555-9637',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0011','BEN DOONE                ',' ',   '843298706',   '140 LIVINGSTONE ST       ',   'YORKTON                  ',   'SK',   'CANADA',   'S3N3A8',   '800-555-9543',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0012','MOLLY MALONE             ',' ',   '987456875',   '730 NIGHTINGALE CRES     ',   'SUMMERSIDE               ',   'PE',   'CANADA',   'C1N4S8',   '800-555-1625',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0013','MARY Q. CONTRARY         ',' ',   '764638765',   '224 KIRKLAND PLACE       ',   'ROXBORO                  ',   'QC',   'CANADA',   'H9J2C7',   '800-555-3474',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0014','LUCY LOCKET              ',' ',   '999888777',   '657 OAK ST               ',   'COLLINGWOOD              ',   'ON',   'CANADA',   'L9Y2Z7',   '800-555-9988',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0015','KITTY FISHER             ',' ',   '778657766',   '401 CORONATION AVE       ',   'DUNCAN                   ',   'BC',   'CANADA',   'V9L2T4',   '888-555-7745',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0016','SIMON TEMPLAR            ',' ',   '792846734',   '796 PINEGROVE CRES       ',   'PEMBROKE                 ',   'ON',   'CANADA',   'K8A7E5',   '888-555-0192',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0017','BEN CASEY                ',' ',   '992887655',   '25 MIDDLE CAMP CRES      ',   'YELLOWKNIFE              ',   'NT',   'CANADA',   'X1A3C3',   '888-555-9946',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0018','QUENTIN JERGENS          ',' ',   '886775663',   '8 PINSENT DR             ',   'GRAND FALLS              ',   'NF',   'CANADA',   '2A22R6',   '888-555-3366',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0019','CHESTER FIELD            ',' ',   '118877645',   '242 OLIVER AVE           ',   'SELKIRK                  ',   'MB',   'CANADA',   'R1A1H5',   '888-555-7456',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0020','MICHELLE MABELLE         ',' ',   '775564355',   '190 QUEEN ST S           ',   'RENFREW                  ',   'ON',   'CANADA',   'K7V2B2',   '888-555-1653',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0021','CASEY JONES              ',' ',   '774553668',   '4 ERISKAY PLACE          ',   'ROTHESAY                 ',   'NB',   'CANADA',   'E2E3H5',   '877-555-7734',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0022','MARY JANE LUCAS          ',' ',   '798781594',   '125 SHAWGLEN RD SW       ',   'CALGARY                  ',   'AB',   'CANADA',   'T2Y1X6',   '877-555-3857',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0023','FLORENCE BLAND          ',' ',   '197630586',   '4491 SOUTH CRESCENT      ',   'PORT ALBERNI             ',   'BC',   'CANADA',   'V9Y1L8',   '877-555-1728',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0024','MICHAEL WATERHOLE        ',' ',   '876459273',   '21 BINSCARTH RD          ',   'TORONTO                  ',   'ON',   'CANADA',   'M4W1Y2',   '877-555-3927',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0025','ROBIN ZEGG               ',' ',   '640298644',   '37 ROCKWOOD ST           ',   'OTTAWA                   ',   'ON',   'CANADA',   'K1N8L8',   '877-555-2956',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0026','FRED BEAR                ',' ',   '294856372',   '27 HESS ST N             ',   'HAMILTON                 ',   'ON',   'CANADA',   'L8R2S5',   '877-555-0012',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0027','MAVIS HATTY              ',' ',   '847364821',   '17 FORT SACKVILLE RD     ',   'BEDFORD                  ',   'NS',   'CANADA',   'B4A2G6',   '877-555-7739',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0028','MALCOLM BEAMISH          ',' ',   '384508237',   'DES PINS RU              ',   'BELOEIL                  ',   'QC',   'CANADA',   'J3G3E9',   '877-555-9822',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0029','JOHN JACOB SCHMIDT       ',' ',   '592759291',   '29 GRAHAM AVE            ',   'ST ALBERT                ',   'AB',   'CANADA',   'T8N1T4',   '877-555-9337',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0030','ADAM FIRSTMAN            ',' ',   '887464820',   '189 SHORT ST             ',   'SIMCOE                   ',   'ON',   'CANADA',   'N3Y3E1',   '877-555-5592',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0031','JOHN SMITH               ',' ',   '337566986',   '52 FORREST ST            ',   'SYDNEY MINES             ',   'NS',   'CANADA',   'B1V2B5',   '877-555-8846',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0032','MARY ANN JONES           ',' ',   '773554266',   '1205 FIR ST              ',   'WHITEHORSE               ',   'YT',   'CANADA',   'Y1A4C3',   '877-555-9952',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0033','JAMES FRASER             ',' ',   '448669567',   '770 ELM RU E             ',   'FARNHAM                  ',   'QC',   'CANADA',   'J2N1E6',   '877-555-3385',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0034','GORDON MACKENZIE          ',' ',  '559843326',   '6775 EAGLES DR           ',   'VANCOUVER                ',   'BC',   'CANADA',   'V5E4C1',   '877-555-7777',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0035','SUSAN PATEL              ',' ',   '005438876',   '1302 REX ST              ',   'SARNIA                   ',   'ON',   'CANADA',   'N7V3N3',   '877-555-5566',   ' ','N','N',' ')
INSERT INTO [dbo].[BNKCUST] VALUES
  ('B0036','JAMES COLEBURN           ',' ',   '483948347',   '85 SPRUCE AVE            ',   'SHAWINIGAN               ',   'QC',   'CANADA',   'G9N1P9',   '877-555-8327',   ' ','N','N',' ')


INSERT INTO [dbo].[BNKATYPE] VALUES
('1','Savings        ',' ')

INSERT INTO [dbo].[BNKATYPE] VALUES
('2','Checking       ',' ')

INSERT INTO [dbo].[BNKATYPE] VALUES
('3','Investment     ',' ')

INSERT INTO [dbo].[BNKATYPE] VALUES
('4','Retirement     ',' ')

INSERT INTO [dbo].[BNKATYPE] VALUES
('5','Mortgage       ',' ')


INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0004', N'014289253', N'2', CAST(-79.40 AS Decimal(9, 2)), N'2000-10-20', CAST(-79.41 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0015', N'021501544', N'1', CAST(222.60 AS Decimal(9, 2)), N'2000-10-20', CAST(222.60 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0026', N'025399550', N'4', CAST(351.00 AS Decimal(9, 2)), N'2000-10-20', CAST(351.00 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0019', N'048424439', N'4', CAST(526.05 AS Decimal(9, 2)), N'2000-10-20', CAST(526.05 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0035', N'054228132', N'4', CAST(252.56 AS Decimal(9, 2)), N'2000-10-20', CAST(252.56 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0004', N'067606426', N'4', CAST(192.24 AS Decimal(9, 2)), N'2000-10-20', CAST(192.24 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0004', N'067606427', N'5', CAST(1453.97 AS Decimal(9, 2)), N'2000-10-20', CAST(1453974.00 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0028', N'090543026', N'4', CAST(682.08 AS Decimal(9, 2)), N'2000-10-20', CAST(682.08 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0011', N'097510533', N'4', CAST(292.50 AS Decimal(9, 2)), N'2000-10-20', CAST(292.50 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0026', N'103842702', N'2', CAST(2.98 AS Decimal(9, 2)), N'2000-10-20', CAST(2.98 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0008', N'126195094', N'3', CAST(423.60 AS Decimal(9, 2)), N'2000-10-20', CAST(423.60 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0029', N'143898379', N'4', CAST(697.60 AS Decimal(9, 2)), N'2000-10-20', CAST(697.60 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0021', N'148367063', N'3', CAST(397.94 AS Decimal(9, 2)), N'2000-10-20', CAST(397.94 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0034', N'154460444', N'2', CAST(271.44 AS Decimal(9, 2)), N'2000-10-20', CAST(271.44 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0019', N'159914519', N'2', CAST(336.87 AS Decimal(9, 2)), N'2000-10-20', CAST(336.87 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0023', N'178238731', N'1', CAST(432.39 AS Decimal(9, 2)), N'2000-10-20', CAST(432.39 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0029', N'213882639', N'5', CAST(121.41 AS Decimal(9, 2)), N'2000-10-20', CAST(121.41 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0034', N'228552724', N'4', CAST(79.92 AS Decimal(9, 2)), N'2000-10-20', CAST(79.92 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0016', N'250299477', N'3', CAST(148.50 AS Decimal(9, 2)), N'2000-10-20', CAST(148.50 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0025', N'255909083', N'4', CAST(1.68 AS Decimal(9, 2)), N'2000-10-20', CAST(1.68 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0018', N'273895979', N'4', CAST(158.20 AS Decimal(9, 2)), N'2000-10-20', CAST(158.20 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0003', N'280458951', N'5', CAST(372.24 AS Decimal(9, 2)), N'2000-10-20', CAST(372.24 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0021', N'287569396', N'1', CAST(246.01 AS Decimal(9, 2)), N'2000-10-20', CAST(246.01 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0025', N'289919943', N'1', CAST(277.30 AS Decimal(9, 2)), N'2000-10-20', CAST(277.30 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0031', N'302433706', N'3', CAST(134.20 AS Decimal(9, 2)), N'2000-10-20', CAST(134.20 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0018', N'310165991', N'1', CAST(497.76 AS Decimal(9, 2)), N'2000-10-20', CAST(497.76 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0004', N'310781989', N'3', CAST(795.52 AS Decimal(9, 2)), N'2000-10-20', CAST(795.53 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0009', N'315929853', N'1', CAST(126.16 AS Decimal(9, 2)), N'2000-10-20', CAST(126.16 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0025', N'323914645', N'2', CAST(66.57 AS Decimal(9, 2)), N'2000-10-20', CAST(66.57 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0015', N'334909021', N'3', CAST(115.92 AS Decimal(9, 2)), N'2000-10-20', CAST(115.92 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0004', N'338886041', N'1', CAST(91.14 AS Decimal(9, 2)), N'2000-10-20', CAST(91.14 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0029', N'374126010', N'3', CAST(809.55 AS Decimal(9, 2)), N'2000-10-20', CAST(809.55 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0036', N'388063602', N'5', CAST(399.33 AS Decimal(9, 2)), N'2000-10-20', CAST(399.33 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0035', N'389624103', N'5', CAST(858.78 AS Decimal(9, 2)), N'2000-10-20', CAST(858.78 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0005', N'394333383', N'1', CAST(45.24 AS Decimal(9, 2)), N'2000-10-20', CAST(45.24 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0010', N'403280080', N'1', CAST(491.64 AS Decimal(9, 2)), N'2000-10-20', CAST(491.64 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0023', N'412718856', N'3', CAST(474.00 AS Decimal(9, 2)), N'2000-10-20', CAST(474.00 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0006', N'417984029', N'1', CAST(122.64 AS Decimal(9, 2)), N'2000-10-20', CAST(122.64 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0029', N'420152459', N'2', CAST(196.70 AS Decimal(9, 2)), N'2000-10-20', CAST(196.70 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0015', N'440261495', N'4', CAST(127.50 AS Decimal(9, 2)), N'2000-10-20', CAST(127.50 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0036', N'443556119', N'2', CAST(430.05 AS Decimal(9, 2)), N'2000-10-20', CAST(430.05 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0035', N'446453890', N'1', CAST(216.64 AS Decimal(9, 2)), N'2000-10-20', CAST(216.64 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0001', N'450061494', N'1', CAST(540.12 AS Decimal(9, 2)), N'2000-10-20', CAST(750.12 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0019', N'452206167', N'3', CAST(248.16 AS Decimal(9, 2)), N'2000-10-20', CAST(248.16 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0020', N'458826510', N'2', CAST(111.15 AS Decimal(9, 2)), N'2000-10-20', CAST(111.15 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0028', N'459775790', N'5', CAST(92.95 AS Decimal(9, 2)), N'2000-10-20', CAST(92.95 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0025', N'472365347', N'3', CAST(390.57 AS Decimal(9, 2)), N'2000-10-20', CAST(390.57 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0014', N'482013421', N'1', CAST(19.25 AS Decimal(9, 2)), N'2000-10-20', CAST(19.25 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0024', N'485960434', N'2', CAST(176.12 AS Decimal(9, 2)), N'2000-10-20', CAST(176.12 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0009', N'492952258', N'5', CAST(69.86 AS Decimal(9, 2)), N'2000-10-20', CAST(69.86 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0028', N'494077239', N'3', CAST(0.00 AS Decimal(9, 2)), N'2000-10-20', CAST(0.00 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0008', N'504706312', N'5', CAST(415.35 AS Decimal(9, 2)), N'2000-10-20', CAST(415.35 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0026', N'507537831', N'5', CAST(120.80 AS Decimal(9, 2)), N'2000-10-20', CAST(120.80 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0017', N'509231712', N'1', CAST(317.40 AS Decimal(9, 2)), N'2000-10-20', CAST(317.40 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0016', N'516444498', N'2', CAST(757.38 AS Decimal(9, 2)), N'2000-10-20', CAST(757.38 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0020', N'532404349', N'1', CAST(15.34 AS Decimal(9, 2)), N'2000-10-20', CAST(15.34 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0018', N'535696493', N'2', CAST(436.01 AS Decimal(9, 2)), N'2000-10-20', CAST(436.01 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0001', N'541374829', N'3', CAST(3.60 AS Decimal(9, 2)), N'2000-10-20', CAST(3.61 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0035', N'564387410', N'2', CAST(222.64 AS Decimal(9, 2)), N'2000-10-20', CAST(222.64 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0024', N'575140550', N'3', CAST(255.78 AS Decimal(9, 2)), N'2000-10-20', CAST(255.78 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0021', N'580996260', N'4', CAST(433.16 AS Decimal(9, 2)), N'2000-10-20', CAST(433.16 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0034', N'582910260', N'5', CAST(592.02 AS Decimal(9, 2)), N'2000-10-20', CAST(592.02 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0006', N'612943325', N'2', CAST(558.62 AS Decimal(9, 2)), N'2000-10-20', CAST(558.62 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0009', N'613638770', N'3', CAST(51.87 AS Decimal(9, 2)), N'2000-10-20', CAST(51.87 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0023', N'614487822', N'2', CAST(318.82 AS Decimal(9, 2)), N'2000-10-20', CAST(318.82 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0033', N'620669186', N'5', CAST(30.60 AS Decimal(9, 2)), N'2000-10-20', CAST(30.60 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0032', N'624576817', N'4', CAST(322.05 AS Decimal(9, 2)), N'2000-10-20', CAST(322.05 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0017', N'632352126', N'2', CAST(609.74 AS Decimal(9, 2)), N'2000-10-20', CAST(609.74 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0033', N'658801552', N'1', CAST(41.70 AS Decimal(9, 2)), N'2000-10-20', CAST(41.70 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0009', N'669078553', N'2', CAST(726.84 AS Decimal(9, 2)), N'2000-10-20', CAST(726.84 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0018', N'672164551', N'3', CAST(497.17 AS Decimal(9, 2)), N'2000-10-20', CAST(497.17 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0007', N'684793285', N'2', CAST(121.25 AS Decimal(9, 2)), N'2000-10-20', CAST(121.25 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0019', N'691529946', N'5', CAST(50.38 AS Decimal(9, 2)), N'2000-10-20', CAST(50.38 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0008', N'698300146', N'2', CAST(160.65 AS Decimal(9, 2)), N'2000-10-20', CAST(160.65 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0007', N'704177665', N'1', CAST(532.40 AS Decimal(9, 2)), N'2000-10-20', CAST(532.40 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0033', N'722655363', N'2', CAST(91.20 AS Decimal(9, 2)), N'2000-10-20', CAST(91.20 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0007', N'725886910', N'5', CAST(39.60 AS Decimal(9, 2)), N'2000-10-20', CAST(39.60 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0022', N'728190635', N'5', CAST(152.49 AS Decimal(9, 2)), N'2000-10-20', CAST(152.49 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0003', N'731813282', N'2', CAST(432.96 AS Decimal(9, 2)), N'2000-10-20', CAST(432.96 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0017', N'734967143', N'3', CAST(373.20 AS Decimal(9, 2)), N'2000-10-20', CAST(373.20 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0001', N'737590226', N'2', CAST(-304.80 AS Decimal(9, 2)), N'2000-10-20', CAST(-514.80 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0010', N'740365828', N'3', CAST(545.01 AS Decimal(9, 2)), N'2000-10-20', CAST(545.01 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0016', N'742159458', N'4', CAST(52.60 AS Decimal(9, 2)), N'2000-10-20', CAST(52.60 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0024', N'766484266', N'1', CAST(419.75 AS Decimal(9, 2)), N'2000-10-20', CAST(419.75 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0030', N'766814914', N'5', CAST(216.36 AS Decimal(9, 2)), N'2000-10-20', CAST(216.36 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0030', N'821196059', N'3', CAST(75.99 AS Decimal(9, 2)), N'2000-10-20', CAST(75.99 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0017', N'824144721', N'5', CAST(49.40 AS Decimal(9, 2)), N'2000-10-20', CAST(49.40 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0013', N'833282554', N'4', CAST(28.06 AS Decimal(9, 2)), N'2000-10-20', CAST(28.06 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0011', N'836284456', N'2', CAST(1092.63 AS Decimal(9, 2)), N'2000-10-20', CAST(1092.63 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0024', N'876614916', N'4', CAST(58.90 AS Decimal(9, 2)), N'2000-10-20', CAST(58.90 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0012', N'889140501', N'5', CAST(190.30 AS Decimal(9, 2)), N'2000-10-20', CAST(190.30 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0020', N'911829818', N'5', CAST(0.00 AS Decimal(9, 2)), N'2000-10-20', CAST(0.00 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0023', N'915945638', N'5', CAST(223.44 AS Decimal(9, 2)), N'2000-10-20', CAST(223.44 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0028', N'916885997', N'2', CAST(942.33 AS Decimal(9, 2)), N'2000-10-20', CAST(942.33 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0008', N'917953926', N'1', CAST(174.41 AS Decimal(9, 2)), N'2000-10-20', CAST(174.41 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0028', N'930886725', N'1', CAST(72.54 AS Decimal(9, 2)), N'2000-10-20', CAST(72.54 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0007', N'931008548', N'3', CAST(115.20 AS Decimal(9, 2)), N'2000-10-20', CAST(115.20 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0027', N'938696955', N'3', CAST(215.73 AS Decimal(9, 2)), N'2000-10-20', CAST(215.73 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0029', N'946046572', N'1', CAST(185.85 AS Decimal(9, 2)), N'2000-10-20', CAST(185.85 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0002', N'962732474', N'1', CAST(67.68 AS Decimal(9, 2)), N'2000-10-20', CAST(67.69 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0007', N'988052896', N'4', CAST(185.00 AS Decimal(9, 2)), N'2000-10-20', CAST(185.00 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')
INSERT [dbo].[BNKACC] ([BAC_PID], [BAC_ACCNO], [BAC_ACCTYPE], [BAC_BALANCE], [BAC_LAST_STMT_DTE], [BAC_LAST_STMT_BAL], [BAC_FILLER], [BAC_ATM_ENABLED], [BAC_ATM_DAY_LIMIT], [BAC_ATM_DAY_DTE], [BAC_ATM_DAY_AMT], [BAC_RP1_DAY], [BAC_RP1_AMOUNT], [BAC_RP1_PID], [BAC_RP1_ACCNO], [BAC_RP1_LAST_PAY], [BAC_RP2_DAY], [BAC_RP2_AMOUNT], [BAC_RP2_PID], [BAC_RP2_ACCNO], [BAC_RP2_LAST_PAY], [BAC_RP3_DAY], [BAC_RP3_AMOUNT], [BAC_RP3_PID], [BAC_RP3_LAST_PAY], [BAC_RP3_ACCNO]) VALUES (N'B0035', N'990768568', N'3', CAST(52.06 AS Decimal(9, 2)), N'2000-10-20', CAST(52.06 AS Decimal(9, 2)), N'                                                                 ', N'  ', CAST(0 AS Decimal(3, 0)), CAST(0xF1320B00 AS Date), CAST(0 AS Decimal(3, 0)), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', N'         ', CAST(0xF1320B00 AS Date), N'  ', CAST(0.00 AS Decimal(7, 2)), N'     ', CAST(0xF1320B00 AS Date), N'         ')


INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0001','1','1','541374829','1999-12-25-01.01.01.000001','',0000001.00,'Christmas present 1      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0001','1','1','541374829','1999-12-25-01.01.02.000002','',0000002.00,'Christmas present 2      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0001','1','1','541374829','1999-12-25-01.01.03.000003','',0000003.00,'Christmas present 3      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0001','1','1','541374829','1999-12-25-01.01.04.000004','',0000004.00,'Christmas present 4      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0001','1','1','541374829','1999-12-25-01.01.05.000005','',0000005.00,'Christmas present 5      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0002','1','1','962732474','1999-12-25-02.03.01.000006','',0000001.00,'Christmas present 1      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0002','1','1','962732474','1999-12-25-02.03.02.000007','',0000002.00,'Christmas present 2      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0002','1','1','962732474','1999-12-25-02.03.03.000008','',0000003.00,'Christmas present 3      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0002','1','1','962732474','1999-12-25-02.03.04.000009','',0000004.00,'Christmas present 4      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0002','1','1','962732474','1999-12-25-02.03.05.000010','',0000005.00,'Christmas present 5      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0002','1','1','962732474','1999-12-25-02.03.06.000011','',0000006.00,'Christmas present 6      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0002','1','1','962732474','1999-12-25-02.03.07.000012','',0000007.00,'Christmas present 7      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0002','1','1','962732474','1999-12-25-02.03.08.000013','',0000008.00,'Christmas present 8      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0002','1','1','962732474','1999-12-25-02.03.09.000014','',0000009.00,'Christmas present 9      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0002','1','1','962732474','1999-12-25-02.03.10.000015','',0000010.00,'Christmas present 10     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.01.000016','',0000001.00,'Christmas present 1      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.02.000017','',0000002.00,'Christmas present 2      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.03.000018','',0000003.00,'Christmas present 3      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.04.000019','',0000004.00,'Christmas present 4      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.05.000020','',0000005.00,'Christmas present 5      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.06.000021','',0000006.00,'Christmas present 6      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.07.000022','',0000007.00,'Christmas present 7      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.08.000023','',0000008.00,'Christmas present 8      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.09.000024','',0000009.00,'Christmas present 9      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.10.000025','',0000010.00,'Christmas present 10     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.11.000026','',0000011.00,'Christmas present 11     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.12.000027','',0000012.00,'Christmas present 12     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.13.000028','',0000013.00,'Christmas present 13     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.14.000029','',0000014.00,'Christmas present 14     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.15.000030','',0000015.00,'Christmas present 15     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.16.000031','',0000016.00,'Christmas present 16     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.17.000032','',0000017.00,'Christmas present 17     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.18.000033','',0000018.00,'Christmas present 18     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.19.000034','',0000019.00,'Christmas present 19     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.20.000035','',0000020.00,'Christmas present 20     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.21.000036','',0000001.00,'Christmas present 21     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.22.000037','',0000002.00,'Christmas present 22     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.23.000038','',0000003.00,'Christmas present 23     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.24.000039','',0000004.00,'Christmas present 24     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.25.000040','',0000005.00,'Christmas present 25     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.26.000041','',0000006.00,'Christmas present 26     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.27.000042','',0000007.00,'Christmas present 27     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.28.000043','',0000008.00,'Christmas present 28     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.29.000044','',0000009.00,'Christmas present 29     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.30.000045','',0000010.00,'Christmas present 30     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.31.000046','',0000011.00,'Christmas present 31     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.32.000047','',0000012.00,'Christmas present 32     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.33.000048','',0000013.00,'Christmas present 33     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.34.000049','',0000014.00,'Christmas present 34     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.35.000050','',0000015.00,'Christmas present 35     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.36.000051','',0000016.00,'Christmas present 36     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.37.000052','',0000017.00,'Christmas present 37     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.38.000053','',0000018.00,'Christmas present 38     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.39.000054','',0000019.00,'Christmas present 39     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.40.000055','',0000020.00,'Christmas present 40     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.41.000056','',0000001.00,'Christmas present 41     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.42.000057','',0000002.00,'Christmas present 42     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.43.000058','',0000003.00,'Christmas present 43     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.44.000059','',0000004.00,'Christmas present 44     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','310781989','1999-12-25-04.04.45.000050','',0000005.00,'Christmas present 45     ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','067606426','1999-12-21-01.01.01.000051','',0000101.00,'Christmas present 1      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','067606426','1999-12-22-01.01.02.000052','',0000102.00,'Christmas present 2      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','067606426','1999-12-23-01.01.03.000053','',0000103.00,'Christmas present 3      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','067606426','1999-12-24-01.01.04.000054','',0000104.00,'Christmas present 4      ',' ',' ')
INSERT INTO [dbo].[BNKTXN] VALUES
  ('B0004','1','1','067606426','1999-12-25-01.01.05.000055','',0000105.00,'Christmas present 5      ',' ',' ')


INSERT INTO [dbo].[BNKHELP] VALUES ('BANK10','01',
'This is the help for screen BANK10.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK10','03',
'Your user id is used to identify you to the application and will determine ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK10','04',
'what you are allowed to do.                                                ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK10','06',
'Valid user ids are:                                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK10','07',
'  B0001 thru B0036, or GUEST (B0004 shows well, GUEST is limited)          ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK10','09',
'Valid password is any set of non-blank characters.                         ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK10','11',
'While on screen BANK10, you may use F2 to swap between a colour screen     ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK10','12',
'and mono-chrome (green on black).                                          ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK10','19',
'From here, use F3 to exit the application or F4 to return to screen BANK10 ')

INSERT INTO [dbo].[BNKHELP] VALUES ('BANK20','01',
'This is the help for screen BANK20.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK20','03',
'Depending on you personal sign-on staus, you may:                          ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK20','05',
'a) display a list of your accounts with their current balances.            ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK20','07',
'b) transfer funds between accounts.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK20','09',
'c) update your contact information, ie your address and phone number.      ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK20','11',
'd) request to cost of a loan                                               ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK20','13',
' OR                                                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK20','15',
'e) obtain additional information on our products and services              ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK20','19',
'From here, use F3 to exit the application or F4 to return to screen BANK20 ')

INSERT INTO [dbo].[BNKHELP] VALUES ('BANK30','01',
'This is the help for screen BANK30.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK30','03',
'You have requested a list of your accounts and their balances.             ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK30','05',
'Details shown are:                                                         ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK30','06',
'- the account number                                                       ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK30','07',
'- the type of account                                                      ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK30','08',
'- the current balance of that account                                      ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK30','09',
'- any service charge that will be applied.                                 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK30','10',
'  (based on the account"s current balance)                                 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK30','11',
'- the date of the last statement                                           ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK30','12',
'- indicator to show if transaction details are available                   ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK30','19',
'From here, use F3 to exit the application or F4 to return to screen BANK30 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK40','01',
'This is the help for screen BANK40.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK40','03',
'You have requested the transaction details for a selected account.         ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK40','05',
'Details shown are:                                                         ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK40','06',
'- the date the transaction was actioned                                    ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK40','07',
'- the time the transaction was actioned                                    ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK40','08',
'- the amount of the transaction                                            ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK40','09',
'- any description associated with the transaction                          ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK40','11',
'If there are more transactions than will fit on one screen then you will be')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK40','12',
'able to page through them using F7 and/or F8 as indicated.                 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK40','19',
'From here, use F3 to exit the application or F4 to return to screen BANK40 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK50','01',
'This is the help for screen BANK50.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK50','03',
'You wish to transfer funds between two of your accounts.                   ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK50','05',
'Please enter the amount you wish to transfer (a dollar && cent value).     ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK50','07',
'Next indicate the account you wish to transfer the funds from and to.      ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK50','19',
'From here, use F3 to exit the application or F4 to return to screen BANK50 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK60','01',
'This is the help for screen BANK60.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK60','03',
'You have selected to update your contact information.                      ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK60','05',
'To change the information, type over the existing information.             ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK60','06',
'If a line is no longer required, type spaces over the existing information.')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK60','07',
'Press <Enter> when you have finished. The revised information will be      ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK60','08',
'redisplayed and you will be asked to confirm that it is correct by pressing')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK60','09',
'PFK10. At that point, any other key will take you back to the existing     ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK60','10',
'information.                                                               ')
INSERT INTO [dbo].[BNKHELP] VALUES ('BANK60','19',
'From here, use F3 to exit the application or F4 to return to screen BANK60 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('DEMO10','01',
'This is the help for screen DEMO10.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('DEMO10','03',
'Please select one of the options shown on the menu and press enter         ')
INSERT INTO [dbo].[BNKHELP] VALUES ('DEMO10','10',
'While on screen DEMO10, you may use F2 to swap between a colour screen     ')
INSERT INTO [dbo].[BNKHELP] VALUES ('DEMO10','11',
'and mono-chrome (green on black).                                          ')
INSERT INTO [dbo].[BNKHELP] VALUES ('DEMO10','19',
'From here, use F3 to exit the application or F4 to return to screen DEMO10 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC01','01',
'This is the help for screen INSC01.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC01','03',
'Your user id is used to identify you to the application and will determine ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC01','04',
'what you are allowed to do.                                                ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC01','06',
'Valid user ids are:                                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC01','07',
'  00001 - 00030 (normal individuals)                                       ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC01','08',
'  00101 - 00106 (individuals who are also agents)                          ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC01','10',
'Valid password is any set of non-blank characters.                         ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC01','12',
'While on screen INSC01, you may use F2 to swap between a colour screen     ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC01','13',
'and mono-chrome (green on black).                                          ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC01','19',
'From here, use F3 to exit the application or F4 to return to screen INSC01 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC02','01',
'This is the help for screen INSC02.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC02','03',
'The user id you entered indicated that you are also an insurance agent.    ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC02','05',
'You have the choice of:                                                    ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC02','06',
'a) working as an agent. In this instance you will be given access to all   ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC02','07',
'   policies that are associated with your agency.                          ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC02','08',
' OR                                                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC02','09',
'b) working as an individual. In this instance you only have access to your ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC02','10',
'   own policies.                                                           ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC02','19',
'From here, use F3 to exit the application or F4 to return to screen INSC02 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC10','01',
'This is the help for screen INSC10.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC10','03',
'You have selected to work as an insurance agent.                           ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC10','05',
'You have four options:                                                     ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC10','06',
'a) to ask for a list of the policies associated with your agency and you wi')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC10','07',
'   be able to select cases from the list to work with                      ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC10','09',
'b) input the policy number directly (it will be checked to ensure that it d')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC10','10',
'   belong to your agency).                                                 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC10','12',
'c) to ask for a list of claims associated with your agency and you will    ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC10','13',
'   be able to select cases from the list to work with                      ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC10','15',
'd) input the claim number directly (it will be checked to ensure that it do')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC10','16',
'   belong to your agency).                                                 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC10','19',
'From here, use F3 to exit the application or F4 to return to screen INSC10 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC11','01',
'This is the help for screen INSC11.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC11','03',
'You have selected to work as an insurance agent and have requested a list  ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC11','04',
'of policies that are associated with your agency.                          ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC11','06',
'To select a policy, enter any non-blank character against it.              ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC11','08',
'If you press ENTER you will obtain the details of that policy.             ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC11','09',
'If there are any claims for the selected policy, pressing F10 will show the')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC11','11',
'If there are more policies than will fit on the screen, F8 will appear     ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC11','12',
'as an option at the bottom of the screen which will page you forward to the')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC11','13',
'next screen. Similarly, if you paged forward, F7 will appear as an option  ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC11','14',
'which will page you backwards to the previous screen.                      ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC11','19',
'From here, use F3 to exit the application or F4 to return to screen INSC11 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC12','01',
'This is the help for screen INSC12.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC12','03',
'You have selected to work as an insurance agent and have details of one of ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC12','04',
'policies that is associated with your agency.                              ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC12','06',
'The following details are shown:                                           ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC12','07',
'- the policy number and type of coverage                                   ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC12','08',
'- the name, address and telephone number of the insured                    ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC12','09',
'- the date the policy was issued                                           ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC12','10',
'- the renewal date of the policy                                           ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC12','11',
'- the annual premium                                                       ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC12','12',
'- the frequency and amounts by which premiums are due                      ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC12','19',
'From here, use F3 to exit the application or F4 to return to screen INSC12 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC20','01',
'This is the help for screen INSC20.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC20','03',
'You have selected to work as an individual policy holder.                  ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC20','05',
'You have two options:                                                      ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC20','06',
'a) to ask for a list of your policies and you will be able to select       ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC20','07',
'   which one you wish to see more details of                               ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC20','09',
'b) to ask for a list of your claims and you will be able to select         ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC20','10',
'   which one you wish to see more details of                               ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC20','19',
'From here, use F3 to exit the application or F4 to return to screen INSC20 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC21','01',
'This is the help for screen INSC21.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC21','03',
'You have a list of your insurance policies.                                ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC21','05',
'To select a policy, enter any non-blank character against it and press ente')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC21','06',
'If there are more entries than will fit on a screen then you will see F8 as')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC21','07',
'an option at the bottom of the screen. Similarly, if you paged forward,    ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC21','08',
'F7 will appear as an option which will page you backwards to the previous  ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC21','09',
'screen.                                                                    ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC21','19',
'From here, use F3 to exit the application or F4 to return to screen INSC21 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC22','01',
'This is the help for screen INSC22.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC22','03',
'You have selected to work with one of your insurance policies              ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC22','05',
'The following details are shown:                                           ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC22','06',
'- the policy number and type of coverage                                   ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC22','07',
'- the date the policy was issued                                           ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC22','08',
'- the renewal date of the policy (if any)                                  ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC22','09',
'- the maturity date of the policy                                          ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC22','10',
'- the term (duration) of the policy                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC22','11',
'- the annual premium                                                       ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC22','12',
'- the frequency and amounts by which premiums are due                      ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC22','19',
'From here, use F3 to exit the application or F4 to return to screen INSC22 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC30','01',
'This is the help for screen INSC30.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC30','03',
'You have selected to update an address.                                    ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC30','05',
'To change the information, type over the information under New Information.')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC30','06',
'If a line is no longer required, type spaces over the data already there.  ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC30','07',
'Press <Enter> when you have finished. The revised information will be      ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC30','08',
'redisplayed and you will be asked to confirm that it is correct by pressing')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC30','09',
'PFK10. At that point, any other key will take you back to the existing     ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC30','10',
'information.                                                               ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC30','19',
'From here, use F3 to exit the application or F4 to return to screen INSC30 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC40','01',
'This is the help for screen INSC40.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC40','03',
'You have a list of claims.                                                 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC40','05',
'To select a policy, enter any non-blank character against it and press ente')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC40','06',
'If there are more entries than will fit on a screen then you will see F8 as')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC40','07',
'as an option at the bottom of the screen. Similarly, if you paged forward, ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC40','08',
'F7 will appear as an option which will page you backwards to the previous  ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC40','09',
'screen.                                                                    ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC40','19',
'From here, use F3 to exit the application or F4 to return to screen INSC40 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC41','01',
'This is the help for screen INSC41.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC41','03',
'You have a list of claims.                                                 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC41','05',
'To select a policy a policy, enter any non-blank character against it and  ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC41','06',
'press enter. If there are more entries than will fit on a screen then you  ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC41','07',
'will see F8 as an option at the botom of the screen. Similarly, if you page')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC41','08',
'forward, F7 will appear as an option which will page you backwards to the  ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC41','09',
'previous screen.                                                           ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC41','19',
'From here, use F3 to exit the application or F4 to return to screen INSC41 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC42','01',
'This is the help for screen INSC42.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC42','03',
'Ultimately this screen (INSC42) will show details of a selected claim.     ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC42','05',
'Right now only the top part of the screen is populated as not all the      ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC42','06',
'necessary test data has been created.                                      ')
INSERT INTO [dbo].[BNKHELP] VALUES ('INSC42','19',
'From here, use F3 to exit the application or F4 to return to screen INSC42 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('PRDA10','01',
'This is the help for screen PRDA10.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('PRDA10','03',
'Please select one of the options shown on the menu and press enter         ')
INSERT INTO [dbo].[BNKHELP] VALUES ('PRDA10','10',
'While on screen PRDA10, you may use F2 to swap between a colour screen     ')
INSERT INTO [dbo].[BNKHELP] VALUES ('PRDA10','11',
'and mono-chrome (green on black).                                          ')
INSERT INTO [dbo].[BNKHELP] VALUES ('PRDA10','19',
'From here, use F3 to exit the application or F4 to return to screen PRDA10 ')
INSERT INTO [dbo].[BNKHELP] VALUES ('PRDA20','01',
'This is the help for screen PRDA20.                                        ')
INSERT INTO [dbo].[BNKHELP] VALUES ('PRDA20','03',
'Sorry. No further help is available.                                       ')
INSERT INTO [dbo].[BNKHELP] VALUES ('PRDA20','19',
'From here, use F3 to exit the application or F4 to return to screen PRDA20 ')



/* AUDIT NONE */
/* DATA CAPTURE NONE */
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','1','00',
'Mainframe Express                                                          ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','1','01',
'Maintain your current systems efficiently, and deliver new systems         ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','1','02',
'cost-effectively with Mainframe Express. It provides an intuitive          ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','1','03',
'workstation-based environment that includes state-of-the-art application   ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','1','04',
'development tools that can dramatically increase programmer                ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','1','05',
'productivity.                                                              ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','2','00',
'Mainframe Express for PL/I                                                 ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','2','01',
'Mainframe Express is the obvious development and testing platform          ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','2','02',
'choice for e-Business-enabling mainframe-based applications. It provides   ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','2','03',
'a consistent, high-performance platform for the development and testing    ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','2','04',
'of Internet-based, and client/server applications that assimilate          ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','2','05',
'mission-critical PL/I and emerging information technologies and transfer   ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','2','06',
'innovative business applications across the enterprise.                    ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','3','00',
'Revolve                                                                    ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','3','01',
'Automate legacy application management and analysis with Revolve. It       ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','3','02',
'reduces the cost and complexity of projects ranging from everyday bug      ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','3','03',
'fixes to large-scale system refurbishment through powerful code analysis   ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','3','04',
'and inventory features that automatically determine and locate an          ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','3','05',
'application"s source components.                                           ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','4','00',
'Mainframe Emulators                                                        ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','4','01',
'These powerful sub-systems provide full support for the mainframe          ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','4','02',
'environment from a single view on the Windows workstation. Mainframe       ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','4','03',
'Emulators support popular mainframe environments, including CICS,          ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','4','04',
'IMS, DB2 and Assembler programs, enabling complex integration testing      ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','4','05',
'right on the workstation.                                                  ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','5','00',
'Mainframe Testing                                                          ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','5','01',
'Test Suite is a comprehensive testing environment that brings workstation  ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','5','02',
'productivity to mainframe application development. It enables your         ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','5','03',
'programmers to perform multiple levels of application testing at their     ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','5','04',
'workstations, ensuring fast, accurate results as well as increased testing ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','5','05',
'confidence throughout your organization.                                   ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','6','00',
'Remote IMS                                                                 ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','6','01',
'Remote IMS provides direct access to mainframe databases from the          ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','6','02',
'workstation. Databases can be transparently read and updated directly      ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','6','03',
'from any workstation, and workstations running Remote IMS can              ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','6','04',
'combine mainframe, network and local databases in a test mode.             ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','7','00',
'Mainframe Connectivity                                                     ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','7','01',
'Micro Focus mainframe connectivity provides COBOL                          ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','7','02',
'developers the best of two worlds with Mainframe Access�, SQL              ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','7','03',
'Option� for DB2, IMS Option�, and CICS Option� - products that             ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','7','04',
'exploit the best features of workgroup and enterprise architectures.       ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','7','05',
'Mainframe source control systems, data, and processes are now              ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','7','06',
'accessible from Mainframe Express�, the industry"s leading                 ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','7','07',
'development environment. Flexible and intuitive graphic presentations for  ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','7','08',
'debugging and analyzing code are the complement to the traditional         ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDA20A','7','09',
'strengths of mainframe operations.                                         ')



INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','1','00',
'Net Express                                                                ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','1','01',
'Extend your enterprise to the Internet and client/server platforms with    ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','1','02',
'Net Express, an integrated development environment that protects your      ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','1','03',
'legacy investments and increases programmer productivity. Net Express      ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','1','04',
'dramaticaly recuces time-to-solution by allowing you to reuse existing     ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','1','05',
'business logic and data and easily extend it to new platforms such as      ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','1','06',
'UNIX, Windows and the Internet.                                            ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','2','00',
'Server Express�                                                            ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','2','01',
'Building Next Generation e-Business Applications. Micro Focus              ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','2','02',
'Server Express is the platform of choice for deploying e-Business          ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','2','03',
'and distributed applications. Server Express accelerates enterprise        ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','2','04',
'COBOL application performance to the next level providing the fastest      ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','2','05',
'ever Micro Focus COBOL� product for UNIX.                                  ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','3','00',
'Object COBOL Developer Suite for UNIX                                      ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','3','01',
'Develop and deploy client/server and standalone COBOL applications         ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','3','02',
'on all leading UNIX platforms with this integrated development             ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','3','03',
'environment. The Developer Suite generates high performing, scalable       ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','3','04',
'and portable business applications that can take advantage of popular      ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','3','05',
'databases and server resources including the Internet.                     ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','4','00',
'Application Server                                                         ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','4','01',
'Extend your applications and eliminate the need for additional             ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','4','02',
'programming with Application Server, a set of powerful run-time facilities ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','4','03',
'that enable COBOL applications to be portable across all leading UNIX      ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','4','04',
'platforms.                                                                 ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','5','00',
'AppMaster Builder                                                          ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','5','01',
'Developers can quickly build applications with AppMaster Builder,          ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','5','02',
'combining extensive application coverage with your data resources.         ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','5','03',
'AppMaster Builder generates reliable, high-performance, high-quality       ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','5','04',
'COBOL while managing integration between the application, clients,         ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','5','05',
'servers and the standard technology to make them work together.            ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','6','00',
'Distributed Computing Consulting Services                                  ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','6','01',
'Integrate your current systems with the best of new technologies and       ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','6','02',
'extend them to new platforms through our consulting services. Our          ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','6','03',
'expertise in complex and heterogeneous computing environments will         ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','6','04',
'maximize the cost and efficiency of your custom solution for blending      ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','6','05',
'disparate technologies such as UNIX, Windows NT, PCs,                      ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','6','06',
'Workstations, MVS and the Internet.                                        ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','7','00',
'Additional Enterprise Application Development Products                     ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','8','00',
'Revolve                                                                    ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','8','01',
'Automate legacy application management and analysis with Revolve. It       ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','8','02',
'reduces the cost and complexity of projects ranging from everyday bug      ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','8','03',
'fixes to large-scale system refurbishment through powerful code analysis   ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','8','04',
'and inventory features that automatically determine and locate an          ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','8','05',
'application"s source components.                                           ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','9','00',
'AppMaster Renovator                                                        ')

INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','9','01',
'This powerful client/server solution dramatically improves the process of  ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','9','02',
'maintaining existing COBOL systems, while facilitating the transition to   ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','9','03',
'client/server and object orientation. It allows you to reuse existing      ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','9','04',
'business logic within new client/server applications and to off-load       ')
INSERT INTO [dbo].[TTEXT] VALUES ('PRDB20A','9','05',
'maintenance of mission-critical applications to distributed platforms.     ')





