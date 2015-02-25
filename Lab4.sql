USE INFO_340_LAB_4;

--1) Copy the entire contents of PRODUCT_VENDOR to a new table that matches your tblUWNetID in the database titled INFO_340_LAB_4.

--Leverage a WHILE loop to update Price under the following conditions:

--If the Product is < avg increase by 10%
--If Product is > avg do not change
--Stop updating immediately if the is a product price that exceeds $10,000

SELECT *
INTO tblRAKTOS
FROM GUITAR_SHOP.dbo.tblPRODUCT_VENDOR;

SELECT ProductVendorID
INTO tblRAKTOS_TMP
FROM tblRAKTOS;

DECLARE @exceeds10k BIT = 0;
DECLARE @ID INT;
DECLARE @avg DECIMAL = (SELECT AVG(Price) FROM tblRAKTOS);

WHILE (SELECT COUNT(*) FROM tblRAKTOS_TMP) > 0 AND @exceeds10k = 0 BEGIN
	SELECT TOP 1 @ID = ProductVendorID FROM tblRAKTOS_TMP;

	DECLARE @Price DECIMAL = (SELECT Price FROM tblRAKTOS WHERE ProductVendorID = @ID);

	IF @Price > 10000 BEGIN
		SET @exceeds10k = 1;
	END

	IF @Price < @avg BEGIN
		UPDATE tblRAKTOS
		SET Price = 1.1 * @Price
		WHERE ProductVendorID = @ID;
	END	

	DELETE FROM tblRAKTOS_TMP WHERE ProductVendorID = @ID;
END

DROP TABLE tblRAKTOS_TMP;

--2) Write a query to copy 60 rows of data from Customer_Build.tblCUSTOMER into a new table called tblUWNetID_Cust. Retrieve only rows that have a LastName beginning with 'G' and reside in Texas.
SELECT TOP 60 * 
INTO tblRAKTOS_CUST
FROM CUSTOMER_BUILD.dbo.tblCUSTOMER c
WHERE c.CustomerLname LIKE 'G%' AND c.CustomerState LIKE '%Texas%';

SELECT * FROM tblRAKTOS_CUST;

--3) Add the column DutyCharge (Numeric 6,2) to the table created in step 1 with a DEFAULT of $6.50
ALTER TABLE tblRAKTOS
ADD DutyCharge NUMERIC(6,2) NOT NULL 
DEFAULT 6.50;

SELECT * FROM tblRAKTOS;

--4) Write a check constraint on your new table that prevents a DutyCharge from being greater than $10 on products with a price greater than $1500.
ALTER TABLE tblRAKTOS_TMP
ADD CONSTRAINT RAKTOS_DutyChargeLimit
CHECK ((DutyCharge < 10 AND Price > 1500) OR (Price <= 1500));