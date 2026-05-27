--1.List all the customers serviced.
SELECT DISTINCT CUSTOMER_NEW.CNAME FROM 
CUSTOMER_NEW
JOIN SER_DET
ON CUSTOMER_NEW.CID = SER_DET.CID;

--1. Using Subquerry
SELECT CNAME
FROM CUSTOMER_NEW 
WHERE CID IN ( SELECT CID FROM SER_DET);

SELECT C.CNAME
FROM CUSTOMER_NEW C
WHERE EXISTS( SELECT CID FROM SER_DET WHERE SER_DET.CID = C.CID);
----------------------------------------------------------

--2.Customers who are not serviced.
select CUSTOMER_NEW.CNAME from 
CUSTOMER_NEW
left join SER_DET
on CUSTOMER_NEW.CID = SER_DET.CID
where SER_DET.CID is null;

--2. Using Subquerry
select CNAME
from CUSTOMER_NEW 
where CID not in (select CID from SER_DET);
--------------------------------------------------------------

--3. Employees who have not received the commission.
SELECT DISTINCT E.ENAME FROM Employee E
JOIN SER_DET S
ON E.EID = S.EID
WHERE S.COMM = 0;

--3. USING SUBQUERRY
SELECT ENAME
FROM EMPLOYEE
WHERE EID IN (SELECT EID FROM SER_DET WHERE COMM = 0);
----------------------------------------------------------------------

4. Name the employee who have maximum Commission.
SELECT DISTINCT E.ENAME, S.COMM FROM Employee E
JOIN SER_DET S
ON E.EID = S.EID
WHERE S.COMM > 0
ORDER BY S.COMM DESC;

--4. USING SUBQUERRY
SELECT ENAME
FROM EMPLOYEE
WHERE EID IN (SELECT EID FROM SER_DET WHERE COMM > 0 );
-----------------------------------------------------------------------------

5.Show employee name and minimum commission amount received by an employee.
SELECT DISTINCT E.ENAME, S.COMM
FROM EMPLOYEE E
JOIN SER_DET S
ON E.EID = S.EID
WHERE S.COMM > 0
ORDER BY S.COMM;
--
--5. USING SUBQUERRY
SELECT * 
FROM (SELECT DISTINCT E.ENAME, S.COMM
FROM EMPLOYEE E
JOIN SER_DET S
ON E.EID = S.EID
WHERE S.COMM > 0
ORDER BY S.COMM);
---------------------------------------------------------------

6 Display the Middle record from any table.
SELECT * FROM
CUSTOMER_NEW
WHERE CID = 1005;
----------------------------------------------------------------
COMMIT;

--7 Display last 4 records of any table.
SELECT * FROM CUSTOMER_NEW
WHERE ROWNUM <= 4
ORDER BY CID DESC;

--USING SUBQUERRY
SELECT * FROM 
(SELECT * FROM CUSTOMER_NEW
ORDER BY CID DESC)
WHERE ROWNUM <= 4;
--------------------------------------------------------------

--8 Count the number of records without count function from any table.
SELECT MAX(TOTAL_RECORDS) FROM(
SELECT ROW_NUMBER() OVER(ORDER BY CID) AS TOTAL_RECORDS FROM CUSTOMER_NEW)
CUSTOMER_NEW;

--BY USING MAX FUNCTION
SELECT MAX(ROWNUM) AS TOTAL_RECORDS FROM CUSTOMER_NEW;

--BY USING 1
SELECT SUM(1) AS TOTAL_RECORDS FROM CUSTOMER_NEW;

COMMIT;
--------------------------------------------------------------------

--9 Delete duplicate records from "Ser_det" table on cid.(note Please rollback after execution).
--BY USING MIN ROWID
DELETE FROM SER_DET
WHERE ROWID NOT IN
(SELECT MIN(ROWID) FROM SER_DET GROUP BY CID);

SELECT * FROM SER_DET;
ROLLBACK;

--BY USING ROWNUMBER() & ROWID
DELETE FROM SER_DET
WHERE ROWID IN
(SELECT ROWID FROM
(SELECT ROWID, ROW_NUMBER() OVER(PARTITION BY CID ORDER BY ROWID ) 
AS RN FROM SER_DET)
WHERE RN > 1);

ROLLBACK;
-----------------------------------------------------------------------

--10.Show the name of Customer who have paid maximum amount 
--USING JOIN
SELECT C.CNAME, MAX(S.TOTAL) MAXIMUN_AMT
FROM CUSTOMER_NEW  C
JOIN SER_DET  S
ON C.CID = S.CID
GROUP BY C.CNAME
ORDER BY MAXIMUN_AMT DESC;

--USING SUBQUERRY
SELECT CNAME FROM CUSTOMER_NEW WHERE CID IN (
SELECT CID FROM SER_DET WHERE TOTAL IN ( SELECT MAX(TOTAL) FROM SER_DET));
---------------------------------------------------------------------------

--11 Display Employees who are not currently working.
--USING WHERE CLAUSE AND NOT NULL
SELECT ENAME
FROM EMPLOYEE
WHERE EDOL IS NOT NULL;

--USING COLUMN TO COLUMN COMPARISON
SELECT ENAME
FROM EMPLOYEE
WHERE EDOL = EDOL
----------------------------------------------------------------------

--12 How many customers serviced their two wheelers.
SELECT C.CNAME
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
WHERE S.TYP_VEH = 'TWO WHEELER';

--USING SUBQUERRY
SELECT CNAME 
FROM CUSTOMER_NEW
WHERE CID IN (SELECT CID FROM SER_DET WHERE TYP_VEH = 'TWO WHEELER');
-------------------------------------------------------------------------

--13 List the Purchased Items which are used for Customer Service with Unit of that Item.
--USING SUBQUERRY
SELECT SPNAME AS PURCHASED_ITEMS, SPUNIT AS UNIT_ITEAMS
FROM SPARE_PARTS
WHERE SPID IN (SELECT SPID FROM SER_DET)

--USING JOIN
SELECT DISTINCT S.SPNAME AS PURCHASED_ITEMS, S.SPUNIT AS UNIT_ITEAMS
FROM SPARE_PARTS S
JOIN SER_DET A
ON S.SPID = A.SPID;

--USING EXISTS
SELECT SPNAME AS PURCHASED_ITEMS, SPUNIT AS UNIT_ITEAMS
FROM SPARE_PARTS
WHERE EXISTS (SELECT SPID FROM SER_DET S WHERE S.SPID = SPARE_PARTS.SPID);
----------------------------------------------------------------------------

--14 Customers who have Colored their vehicles.
SELECT C.CNAME
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
WHERE TYP_SER = 'COLOR';

--USING SUBQUERRY
SELECT CNAME FROM CUSTOMER_NEW
WHERE CID IN (SELECT CID FROM SER_DET WHERE TYP_SER = 'COLOR')

--USING INTERSECT
SELECT CNAME FROM 
CUSTOMER_NEW WHERE CID IN (
SELECT CID FROM CUSTOMER_NEW 
INTERSECT
SELECT CID FROM SER_DET WHERE TYP_SER = 'COLOR')
-------------------------------------------------------------------------

--.15 Find the annual income of each employee inclusive of Commission
SELECT DISTINCT E.ENAME, (E.ESAL*12) + S.COMM AS ANNUAL_INC FROM EMPLOYEE E
LEFT JOIN SER_DET S
ON E.EID = S.EID;

--USING SUBQUERRY
SELECT DISTINCT * FROM
(SELECT E.ENAME, (E.ESAL*12) + S.COMM AS ANNUAL_INC FROM EMPLOYEE E
LEFT JOIN SER_DET S
ON E.EID = S.EID)
-------------------------------------------------------------------------

--Q.16 Vendor Names who provides the engine oil.
--USING MULTIPLE JOINS
SELECT V.VNAME AS VENDORS_NAME FROM VENDORS V
JOIN PURCHASE P
ON V.VID = P.VID
JOIN SPARE_PARTS S
ON S.SPID = P.SPID
WHERE SPNAME LIKE '%ENGINE OIL%';

--USING SUBQUERRY
SELECT * FROM(
SELECT V.VNAME AS VENDORS_NAME FROM VENDORS V
JOIN PURCHASE P
ON V.VID = P.VID
JOIN SPARE_PARTS S
ON S.SPID = P.SPID
WHERE SPNAME LIKE '%ENGINE OIL%');
------------------------------------------------------------------

--17 Total Cost to purchase the Color and name the color purchased.
--USING LEFT JOIN
SELECT S.SPNAME, SUM(P.TOTAL)
FROM SPARE_PARTS S
LEFT JOIN PURCHASE P
ON S.SPID = P.SPID
WHERE S.SPNAME LIKE '%COLOUR%'
GROUP BY S.SPNAME;

--USING SUBQUERRY
SELECT * FROM(SELECT S.SPNAME, SUM(P.TOTAL)
FROM SPARE_PARTS S
LEFT JOIN PURCHASE P
ON S.SPID = P.SPID
WHERE S.SPNAME LIKE '%COLOUR%'
GROUP BY S.SPNAME);
-----------------------------------------------------------------------

--18 Purchased Items which are not used in "Ser_det".
SELECT S.SPID, S.SPNAME
FROM SPARE_PARTS S
LEFT JOIN SER_DET K
ON S.SPID = K.SPID
WHERE S.SPID NOT IN ( SELECT SPID FROM SER_DET);

--USING NOT EXISTS
SELECT S.SPID, S.SPNAME
FROM SPARE_PARTS S
WHERE NOT EXISTS 
(SELECT SPID FROM SER_DET K WHERE K.SPID = S.SPID);
--------------------------------------------------------------------------------

--19 Spare Parts Not Purchased but existing in Sparepart
--USING NOT IN COMMAND
SELECT SPID, SPNAME
FROM SPARE_PARTS
WHERE SPID NOT IN (SELECT SPID FROM PURCHASE);

--USING NOT EXISTS
SELECT SPID, SPNAME
FROM SPARE_PARTS 
WHERE NOT EXISTS 
( SELECT SPID FROM PURCHASE P WHERE P.SPID = SPARE_PARTS.SPID);

--USING JOIN & IS NULL
SELECT S.SPID, S.SPNAME
FROM SPARE_PARTS S
LEFT JOIN PURCHASE P
ON S.SPID = P.SPID
WHERE P.SPID IS NULL;

COMMIT;
-------------------------------------------------------------------------

--20 Calculate the Profit/Loss of the Firm. consider one month salary of each employee for Calculation.
--USING SUBQUERRIES
SELECT 
(SELECT SUM(TOTAL) FROM PURCHASE) -
(SELECT SUM(ESAL) FROM EMPLOYEE) 
AS PROFIT
FROM DUAL;

--USING CONDITION CASES
SELECT 
CASE
    WHEN
    (SELECT SUM(TOTAL) FROM PURCHASE) -
    (SELECT SUM(ESAL) FROM EMPLOYEE) > 0
    THEN 'PROFIT'
ELSE 'LOSS'
END AS STATUS
FROM DUAL;

--USING CONDITION CASES AND THERE PROFIT LOSS VALUE
SELECT 
(SELECT SUM(TOTAL) FROM PURCHASE) -
(SELECT SUM(ESAL) FROM EMPLOYEE) 
AS PROFIT_LOSS_VALUE,
CASE
    WHEN
    (SELECT SUM(TOTAL) FROM PURCHASE) -
    (SELECT SUM(ESAL) FROM EMPLOYEE) > 0
    THEN 'PROFIT'
ELSE 'LOSS'
END AS STATUS
FROM DUAL;
---------------------------------------------------------------------------

--21 Specify the names of customers who have serviced their vehicles more than one time.
--USING JOIN
SELECT C.CNAME
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
WHERE S.QTY > 1;

--USING SUBQUERRY
SELECT C.CNAME
FROM CUSTOMER_NEW C
WHERE C.CID IN (SELECT CID FROM SER_DET WHERE QTY > 1);
-----------------------------------------------------------------------

--.22 List the Items purchased from vendors locationwise.
--USING 2 JOINS
SELECT V.VNAME, V.VADD AS V_LOCATION, S.SPNAME AS S_ITEMS
FROM VENDORS V
JOIN PURCHASE P
ON V.VID = P.VID
JOIN SPARE_PARTS S
ON P.SPID = S.SPID;

--USING SUBQUERRY
SELECT * FROM (
SELECT V.VNAME, V.VADD AS V_LOCATION, S.SPNAME AS V_ITEMS
FROM VENDORS V
JOIN PURCHASE P
ON V.VID = P.VID
JOIN SPARE_PARTS S
ON P.SPID = S.SPID);
----------------------------------------------------------------------------

--23 Display count of two wheeler and four wheeler from ser_details
--USING SUM
SELECT 
SUM(CASE WHEN TYP_VEH LIKE '%TWO%' THEN 1 END) AS TWO_WHEELER,
SUM(CASE WHEN TYP_VEH LIKE '%FOUR%' THEN 1 END) AS FOUR_WHEELER
FROM SER_DET;

--USING COUNT
SELECT 
COUNT(CASE WHEN TYP_VEH LIKE '%TWO%' THEN 1 END) AS TWO_WHEELER,
COUNT(CASE WHEN TYP_VEH LIKE '%FOUR%' THEN 1 END) AS FOUR_WHEELER
FROM SER_DET;

--USING GROUP BY
SELECT TYP_VEH, COUNT (*) AS VEHICLE_TYPE
FROM SER_DET
GROUP BY TYP_VEH;
---------------------------------------------------------------------------------

--24 Display name of customers who paid highest SPGST and for which item 
--USING JOIN
SELECT C.CNAME, S.SP_G
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
ORDER BY S.SP_G DESC;

--USING DENSE RANK()
SELECT * FROM
(SELECT C.CNAME, S.SP_G, DENSE_RANK() OVER(ORDER BY  S.SP_G DESC) RANK
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID);

--USING MAX FUNCTION
SELECT C.CNAME, MAX(S.SP_G)
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
GROUP BY C.CNAME
ORDER BY MAX(S.SP_G) DESC;
---------------------------------------------------------------------------

--25 Display vendors name who have charged highest SPGST rate  for which item
--USING JOIN
SELECT V.VNAME, P.SPGST, S.SPNAME AS ITEM
FROM VENDORS V
JOIN PURCHASE P
ON V.VID = P.VID
JOIN SPARE_PARTS S
ON P.SPID = S.SPID
ORDER BY P.SPGST DESC;

--USING WINDOW FUNCTION DENSE RANK
SELECT V.VNAME, P.SPGST, S.SPNAME AS ITEM, DENSE_RANK() OVER(ORDER BY P.SPGST DESC )RANK
FROM VENDORS V
JOIN PURCHASE P
ON V.VID = P.VID
JOIN SPARE_PARTS S
ON P.SPID = S.SPID;
----------------------------------------------------------------------------------

--26 list name of item and employee name who have received item 
--USING JOIN
SELECT E.ENAME, S.SPNAME AS ITEM
FROM EMPLOYEE E
JOIN PURCHASE P
ON E.EID = P.RCV_EID
JOIN SPARE_PARTS S
ON P.SPID = S.SPID;

--USING SUBQUERRY
SELECT (
SELECT E.ENAME FROM EMPLOYEE E
WHERE E.EID = P.RCV_EID ) AS EMPLOYEE_NAME,
(
SELECT S.SPNAME FROM SPARE_PARTS S
WHERE S.SPID = P.SPID) AS ITEM_NAME
FROM PURCHASE P;

COMMIT;
----------------------------------------------------------------------------

--27.Display the Name and Vehicle Number of Customer who serviced his vehicle, 
--And Name the Item used for Service, And specify the purchase date of that 
--Item with his vendor and Item Unit and Location, And employee Name who serviced the vehicle. 
--for Vehicle NUMBER "MH-14PA335".'

SELECT 
       C.CNAME, 
       S.VEH_NO, 
       K.SPNAME, 
       P.PDATE, 
       V.VNAME, 
       K.SPUNIT, 
       V.VADD, 
       E.ENAME
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
JOIN SPARE_PARTS K
ON S.SPID = K.SPID
JOIN PURCHASE P
ON K.SPID = P.SPID
JOIN VENDORS V
ON P.VID = V.VID
JOIN EMPLOYEE E
ON S.EID = E.EID
WHERE S.VEH_NO = 'MH-14PA335';

--USING CORRELATED SUBQUERRY
SELECT 
(
    SELECT C.CNAME
    FROM CUSTOMER_NEW C
    WHERE C.CID = S.CID
) AS CUSTOMER_NAME,

S.VEH_NO AS VEHICLE_NUM,

(
    SELECT K.SPNAME
    FROM SPARE_PARTS K
    WHERE K.SPID = S.SPID
) AS ITEM_NAME,

(
    SELECT P.PDATE
    FROM PURCHASE P
    WHERE P.SPID = S.SPID
) AS PURCHASE_DATE,

(
    SELECT V.VNAME
    FROM VENDORS V
    WHERE V.VID =
    (
        SELECT P.VID
        FROM PURCHASE P
        WHERE P.SPID = S.SPID
    )
) AS VENDOR_NAME,

(
    SELECT K.SPUNIT
    FROM SPARE_PARTS K
    WHERE K.SPID = S.SPID
) AS ITEM_UNIT,

(
    SELECT V.VADD
    FROM VENDORS V
    WHERE V.VID =
    (
        SELECT P.VID
        FROM PURCHASE P
        WHERE P.SPID = S.SPID
    )
) AS VENDOR_ADD,

(
    SELECT E.ENAME
    FROM EMPLOYEE E
    WHERE E.EID = S.EID
) AS EMPLOYEE_NAME

FROM SER_DET S

WHERE S.VEH_NO = 'MH-14PA335';
-----------------------------------------------------------------------------

--28 who belong this vehicle  MH-14PA335" Display the customer name 
--USING SUBQUERRY
SELECT CNAME 
FROM CUSTOMER_NEW
WHERE CID IN (SELECT CID FROM SER_DET WHERE VEH_NO = 'MH-14PA335' );

--USING JOIN
SELECT C.CNAME
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
WHERE S.VEH_NO = 'MH-14PA335';

--USING CORRELATED SUBQUERRY
SELECT (
SELECT C.CNAME FROM CUSTOMER_NEW C
WHERE C.CID = S.CID) AS CUSTOMER_NAME
FROM SER_DET S
WHERE S.VEH_NO = 'MH-14PA335';
----------------------------------------------------------------------

--29 Display the name of customer who belongs to New York and when he /she service their  vehicle on which date    
--USING JOIN
SELECT C.CNAME, S.SER_DATE
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
WHERE C.CADD = 'NEW YORK';

--USING CORRELATED SUBQUERRY
SELECT C.CNAME, (
SELECT S.SER_DATE FROM SER_DET S
WHERE S.CID = C.CID) AS SERVICE_DATE
FROM CUSTOMER_NEW C
WHERE C.CADD = 'NEW YORK';
-------------------------------------------------------------------------

--30 from whom we have purchased items having maximum cost?
--USING JOIN & SUBQUERRY
SELECT V.VNAME, P.TOTAL
FROM VENDORS V
JOIN PURCHASE P
ON V.VID = P.VID
WHERE P.TOTAL =
( SELECT MAX(TOTAL)
  FROM PURCHASE );
  
--USING SUBQUERRY
SELECT VNAME 
FROM VENDORS
WHERE VID = (
SELECT VID FROM PURCHASE
WHERE TOTAL = (
SELECT MAX(TOTAL) FROM PURCHASE));

--USING DENSE RANK
SELECT VNAME
FROM (
    SELECT V.VNAME,
           DENSE_RANK() OVER (ORDER BY P.TOTAL DESC) RANK
    FROM VENDORS V
    JOIN PURCHASE P
    ON V.VID = P.VID
)
WHERE RANK = 1;

COMMIT;
---------------------------------------------------------------------------------------

--31.Display the names of employees who are not working as Mechanic and that employee done services  
--USING JOIN & NOT EQUAL TO
SELECT DISTINCT E.ENAME 
FROM EMPLOYEE E
JOIN SER_DET S
ON E.EID = S.EID
WHERE E.EJOB != 'MECHANIC';

--USING SUBQUERRY & EXISTS
SELECT E.ENAME
FROM EMPLOYEE E
WHERE E.EJOB != 'MECHANIC' AND EXISTS (
SELECT EID FROM SER_DET S WHERE S.EID = E.EID);
---------------------------------------------------------------------

--32 Display the various jobs along with total number of employees in each job. The output should
--contain only those jobs with more than two employees.
--USING GROUP BY & HAVING
SELECT EJOB, COUNT(*) AS TOTAL_EMPLOYEE
FROM EMPLOYEE
GROUP BY EJOB
HAVING COUNT(*) > 2;

--USING SUBQUERRY
SELECT * FROM (
SELECT EJOB, COUNT(*) AS TOTAL_EMPLOYEE
FROM EMPLOYEE
GROUP BY EJOB
HAVING COUNT(*) > 2);
----------------------------------------------------------------------------

--33 Display the details of employees who done service  and give them rank according to their no. of services .
--USING JOIN
SELECT E.ENAME , E.EJOB, E.EADD, E.ECONTACT, E.ESAL, COUNT(S.EID) AS TOTAL_SERVICES,
DENSE_RANK() OVER(ORDER BY COUNT(S.EID) DESC ) AS RANK
FROM EMPLOYEE E
JOIN SER_DET S
ON E.EID = S.EID
GROUP BY E.ENAME , E.EJOB, E.EADD, E.ECONTACT, E.ESAL;

COMMIT;
--------------------------------------------------------------------------------

--34 Display those employees who are working as Painter and fitter and 
--who provide service and total count of service done by fitter and painter 
--USING LEFT JOIN
SELECT E.ENAME,E.EJOB, COUNT(S.EID) AS TOTAL_SERVICES
FROM EMPLOYEE E
LEFT JOIN SER_DET S
ON E.EID = S.EID
WHERE E.EJOB IN ('PAINTER', 'FITTER')
GROUP BY E.ENAME, E.EJOB
ORDER BY TOTAL_SERVICES DESC;

--USING CORRELATED SUBQUERRY
SELECT E.ENAME, E.EJOB, (
SELECT COUNT(S.EID) FROM SER_DET S WHERE S.EID = E.EID ) AS TOTAL_SERVICES
FROM EMPLOYEE E
WHERE E.EJOB IN ('PAINTER', 'FITTER');
--------------------------------------------------------------------------------

--35 Display employee salary and as per highest  salary provide Grade to employee 
--USING CASE STATEMENTS
SELECT ENAME, ESAL,
CASE
    WHEN ESAL <= 1000 THEN 'LOW SALARY'
    WHEN ESAL <= 1500 THEN 'MEDIUM'
    WHEN ESAL >= 1500 THEN 'HIGH SALARY'
ELSE 'NO SALARY'
END AS STATUS
FROM EMPLOYEE;

--USING DENSE RANK
SELECT ENAME, ESAL,
DENSE_RANK() OVER(ORDER BY ESAL DESC NULLS LAST) AS GRADE
FROM EMPLOYEE;
----------------------------------------------------------------------------

--36 display the 4th record of emp table without using group by and rowid
SELECT * FROM 
EMPLOYEE
WHERE EID = 3004;

--USING ROWNUM & SUBQUERRY
SELECT * FROM (
SELECT E.*, ROWNUM AS RN
FROM EMPLOYEE E) 
WHERE RN = 4;
----------------------------------------------------------------------------

--37 Provide a commission 100 to employees who are not earning any commission.
--USING JOIN
SELECT E.ENAME, S.COMM+100 AS COMMISION
FROM EMPLOYEE E
JOIN SER_DET S
ON E.EID = S.EID
WHERE S.COMM = 0;

--USING CORRELATED SUBQUERRY
SELECT (
SELECT E.ENAME FROM EMPLOYEE E WHERE E.EID = S.EID ) AS EMPLOYEES,
(
CASE WHEN S.COMM = 0 THEN S.COMM+100 ELSE S.COMM END) AS COMMISION
FROM SER_DET S;


--USING JOIN & CASE STATEMENTS
SELECT E.ENAME,
CASE 
    WHEN S.COMM = 0 THEN S.COMM+100 ELSE S.COMM 
    END AS COMMISION
FROM EMPLOYEE E
JOIN SER_DET S
ON E.EID = S.EID;
------------------------------------------------------------------------------

--38 write a query that totals no. of services  for each day and place the results
--in descending order
SELECT SER_DATE, COUNT(*) AS TOTAL_SERVICES
FROM SER_DET 
GROUP BY SER_DATE
ORDER BY TOTAL_SERVICES DESC;

--USING SUBQUERRY
SELECT * FROM (
SELECT SER_DATE, COUNT(*) AS TOTAL_SERVICES
FROM SER_DET 
GROUP BY SER_DATE
ORDER BY TOTAL_SERVICES DESC);
---------------------------------------------------------------------------

--39 Display the service details of those customer who belong from same city 
SELECT 
     C.CID,
     C.CNAME,
     C.CADD,
     S.SID,
     S.SER_DATE,
     S.SP_AMT
FROM SER_DET S
JOIN CUSTOMER_NEW C
ON C.CID = S.CID
WHERE C.CADD IN ( SELECT CADD
                  FROM CUSTOMER_NEW
                  GROUP BY CADD
                  HAVING COUNT(*)>1);

--USING EXISTS
SELECT 
     C.CID,
     C.CNAME,
     C.CADD,
     S.SID,
     S.SER_DATE,
     S.SP_AMT
FROM SER_DET S
JOIN CUSTOMER_NEW C
ON C.CID = S.CID
WHERE EXISTS (SELECT 1
              FROM CUSTOMER_NEW C2
              WHERE C2.CID != C.CID
              AND C2.CADD = C.CADD);

COMMIT;
---------------------------------------------------------------------------

--40 write a query join customers table to itself to find all pairs of
--customers service by a single employee
SELECT C1.CNAME AS CUSTOMER_1, C2.CNAME AS CUSTOMER_2, E.ENAME AS EMPLOYEE_NAME
FROM CUSTOMER_NEW C1

JOIN SER_DET S1
ON C1.CID = S1.CID

JOIN CUSTOMER_NEW C2
ON C1.CID < C2.CID

JOIN SER_DET S2
ON C2.CID = S2.CID

JOIN EMPLOYEE E
ON E.EID = S1.EID

WHERE S1.EID = S2.EID;
-----------------------------------------------------------------------------

--41.List each service number follow by name of the customer who
--made that service
--USING JOIN
SELECT S.SID AS SERVICE_NUM, C.CNAME AS CUSTOMER_NAME
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
ORDER BY S.SID ;

--USING SUBQUERRY
SELECT S.SID AS SERVICE_NUM,
( SELECT C.CNAME FROM CUSTOMER_NEW C WHERE C.CID = S.CID) AS CUSTOMER_NAME
FROM SER_DET S
ORDER BY S.SID;
----------------------------------------------------------------------------

--Q42 Write a query to get details of employee and provide rating on basis of 
--maximum services provide by employee  .Note (rating should be like A,B,C,D)
SELECT 
      E.EID, 
      E.ENAME, 
      E.EJOB, 
      E.EADD, 
      E.ESAL,
      COUNT(S.SID) AS SERVICES,
CASE 
    WHEN COUNT(S.SID) >=3 THEN 'A'
    WHEN COUNT(S.SID) >=2 THEN 'B'
    WHEN COUNT(S.SID) >=1 THEN 'C'
    ELSE 'D'
END AS RATING
FROM EMPLOYEE E
JOIN SER_DET S
ON E.EID = S.EID
GROUP BY E.EID, 
      E.ENAME, 
      E.EJOB, 
      E.EADD, 
      E.ESAL
ORDER BY SERVICES DESC;
------------------------------------------------------------------------------

--43 Write a query to get maximum service amount of each customer with their customer details ?
--USING JOIN
SELECT 
      C.CID,
      C.CNAME,
      C.CADD,
      C.C_CONTACT,
      SEX,
      MAX(SER_AMT) AS MAXIMUM_AMOUNT
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
GROUP BY C.CID,
      C.CNAME,
      C.CADD,
      C.C_CONTACT,
      SEX
ORDER BY MAXIMUM_AMOUNT DESC;

--USING SUBQUERRY
SELECT 
      C.CID,
      C.CNAME,
      C.CADD,
      C.C_CONTACT,
      SEX, 
( SELECT MAX(S.SER_AMT) FROM SER_DET S
WHERE S.CID = C.CID) AS MAXIMUM_AMOUNT
FROM CUSTOMER_NEW C
ORDER BY MAXIMUM_AMOUNT DESC NULLS LAST;
--------------------------------------------------------------------------------

44 Get the details of customers with his total no of services ?
--USING LEFT JOIN
SELECT C.CID,
       C.CNAME,
       C.CADD,
       C.C_CONTACT,
       SEX,
       COUNT(S.SID) AS TOTAL_SERVICES
FROM CUSTOMER_NEW C
LEFT JOIN SER_DET S
ON C.CID = S.CID
GROUP BY C.CID, C.CNAME, C.CADD, C.C_CONTACT, SEX
ORDER BY TOTAL_SERVICES DESC;

--USING SUBQUERRY
SELECT C.CID,
       C.CNAME,
       C.CADD,
       C.C_CONTACT,
       SEX,
( SELECT COUNT(S.SID) FROM SER_DET S WHERE S.CID = C.CID) AS TOTAL_SERVICES
FROM CUSTOMER_NEW C
ORDER BY TOTAL_SERVICES DESC;

COMMIT;
-----------------------------------------------------------------------------

--45 From which location sparpart purchased  with highest cost ?
--USING JOIN & MAX FUNCTION
SELECT S.SPNAME AS SPARE_PART_NAME, V.VADD AS LOCATION, MAX(P.TOTAL) AS HIGHEST_COST
FROM SPARE_PARTS S
JOIN PURCHASE P
ON S.SPID = P.SPID
JOIN VENDORS V
ON V.VID = P.VID
GROUP BY S.SPNAME, V.VADD
ORDER BY HIGHEST_COST DESC;

--USING SUBQUERRY
SELECT S.SPNAME,
( SELECT MAX(P.TOTAL) FROM PURCHASE P WHERE P.SPID = S.SPID) AS HIGHEST_COST,
( SELECT V.VADD FROM VENDORS V 
JOIN PURCHASE P
ON V.VID = P.VID WHERE P.SPID = S.SPID AND ROWNUM = 1 ) AS LOCATION
FROM SPARE_PARTS S
ORDER BY HIGHEST_COST;
---------------------------------------------------------------------------

--46 Get the details of employee with their service details who has salary is null
--USING JOIN
SELECT 
      E.EID, 
      E.ENAME, 
      E.EJOB, 
      E.EADD, 
      E.ESAL,
      S.SID,
      S.SER_DATE,
      S.SP_RATE
FROM EMPLOYEE E
JOIN SER_DET S
ON E.EID = S.EID
WHERE E.ESAL IS NULL;
      
--USING JOIN & IN & SUBQUERRY      
SELECT 
      E.EID, 
      E.ENAME, 
      E.EJOB, 
      E.EADD, 
      E.ESAL,
      S.SID,
      S.SER_DATE,
      S.SP_RATE
FROM EMPLOYEE E
JOIN SER_DET S
ON E.EID = S.EID
WHERE E.EID IN ( SELECT EID FROM EMPLOYEE WHERE ESAL IS NULL);
------------------------------------------------------------------------------      

--47 find the sum of purchase location wise 
--USING JOIN
SELECT V.VADD, SUM(P.TOTAL) AS PURCHASE_SUM
FROM VENDORS V
JOIN PURCHASE P
ON V.VID = P.VID
GROUP BY V.VADD
ORDER BY PURCHASE_SUM DESC;

--USING SUBQUERRY
SELECT V.VADD,
( SELECT SUM(P.TOTAL) FROM PURCHASE P
WHERE P.VID = V.VID) AS PURCHASE_SUM
FROM VENDORS V
ORDER BY PURCHASE_SUM DESC;
----------------------------------------------------------------------------

48 write a query sum of purchase amount in word location wise ?
--BY USING TRUNC
SELECT V.VADD AS LOCATION,
       SUM(P.TOTAL) AS TOTAL_AMOUNT,
       TO_CHAR(TO_DATE(TRUNC(SUM(P.TOTAL)),'J'),'JSP') AS AMOUNT_IN_WORDS
FROM PURCHASE P
JOIN VENDORS V
ON P.VID = V.VID
GROUP BY V.VADD
ORDER BY SUM(P.TOTAL) DESC;
------------------------------------------------------------------------------

--49 Has the customer who has spent the largest amount money has
--been give highest rating
--BY USING SUM () & MAX() FUNCTION & CASE
SELECT C.CID,
       C.CNAME,
       SUM(S.SER_AMT) AS TOTAL_SPENT,
       CASE
           WHEN SUM(S.SER_AMT) = (
                SELECT MAX(TOTAL_AMOUNT)
                FROM (SELECT SUM(SER_AMT) AS TOTAL_AMOUNT
                      FROM SER_DET
                      GROUP BY CID))
           THEN 'HIGHEST RATING'
           ELSE 'NORMAL RATING'
       END AS RATING
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
GROUP BY C.CID, C.CNAME
ORDER BY TOTAL_SPENT DESC;

--BY USING SUM () & RANK () & CASE FUNCTION
SELECT CID,
       CNAME,
       TOTAL_SPENT,
       CASE
           WHEN RANK = 1 THEN 'HIGHEST RATING'
           ELSE 'NORMAL RATING'
       END AS RATING
FROM (
    SELECT C.CID,
           C.CNAME,
           SUM(S.SER_AMT) AS TOTAL_SPENT,
           RANK() OVER (ORDER BY SUM(S.SER_AMT) DESC) RANK
    FROM CUSTOMER_NEW C
    JOIN SER_DET S
    ON C.CID = S.CID
    GROUP BY C.CID, C.CNAME );
--------------------------------------------------------------------------

--50 select the total amount in service for each customer for which
--the total is greater than the amount of the largest service amount in the table
SELECT C.CID, C.CNAME, SUM(S.SER_AMT) AS TOTAL_AMOUNT
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
GROUP BY C.CID, C.CNAME
HAVING SUM(S.SER_AMT) > (SELECT MAX(SER_AMT) 
                         FROM SER_DET);


--USING SUBQUERRY
SELECT * FROM (
SELECT C.CID, C.CNAME, SUM(S.SER_AMT) AS TOTAL_AMOUNT
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
GROUP BY C.CID, C.CNAME )
WHERE TOTAL_AMOUNT > ( SELECT MAX(SER_AMT) FROM SER_DET );
----------------------------------------------------------------------------

--51.List the customer name and sparepart name used for their vehicle and  vehicle type
SELECT K.SPID, C.CNAME AS CUSTOMER_NAME, S.SPNAME AS SPARE_PART_NAME, K.TYP_VEH
FROM CUSTOMER_NEW C
JOIN SER_DET K
ON C.CID = K.CID
JOIN SPARE_PARTS S
ON S.SPID = K.SPID;
-------------------------------------------------------------------------------

52 Write a query to get spname ,ename,cname quantity ,rate ,service amount
for record exist in service table 
--USING MULTIPLE JOINS
SELECT 
       S.SPNAME, 
       E.ENAME, 
       C.CNAME, 
       K.QTY, 
       K.SP_RATE, 
       K.SER_AMT
FROM CUSTOMER_NEW C
JOIN SER_DET K
ON C.CID = K.CID
JOIN SPARE_PARTS S
ON S.SPID = K.SPID
JOIN EMPLOYEE E
ON E.EID = K.EID;

--USING EXISTS
SELECT 
       S.SPNAME, 
       E.ENAME, 
       C.CNAME, 
       K.QTY, 
       K.SP_RATE, 
       K.SER_AMT
FROM CUSTOMER_NEW C
JOIN SER_DET K
ON C.CID = K.CID
JOIN SPARE_PARTS S
ON S.SPID = K.SPID
JOIN EMPLOYEE E
ON E.EID = K.EID
WHERE EXISTS ( SELECT SPID FROM SER_DET WHERE SER_DET.SPID = S.SPID);

--USING CORRELATED SUBQUERRY
SELECT (
SELECT S.SPNAME FROM SPARE_PARTS S
WHERE S.SPID = K.SPID) AS SPARE_PART_NAME,
(
SELECT E.ENAME FROM EMPLOYEE E
WHERE E.EID = K.EID) AS EMPLOYEE_NAME,
(
SELECT C.CNAME FROM CUSTOMER_NEW C
WHERE C.CID = K.CID) AS CUSTOMER_NAME,
K.QTY,
K.SP_RATE,
K.SER_AMT
FROM SER_DET K;
-------------------------------------------------------------------------------

53 specify the vehicles owners who’s tube damaged.
--USING JOIN
SELECT C.CNAME, S.TYP_SER
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
WHERE TYP_SER = 'TUBE DAMAGED'

--USING SUBQUERRY
SELECT C.CNAME, S.TYP_SER
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
WHERE C.CID IN (SELECT CID FROM SER_DET 
                WHERE TYP_SER = 'TUBE DAMAGED')

--USING EXISTS
SELECT C.CNAME, S.TYP_SER
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
WHERE EXISTS ( SELECT CID FROM SER_DET 
              WHERE SER_DET.CID = C.CID AND TYP_SER = 'TUBE DAMAGED');
------------------------------------------------------------------------------

54 Specify the details who have taken full service.
SELECT C.CID,
       C.CNAME,
       C.CADD,
       C.C_CONTACT,
       S.SID,
       S.TYP_SER
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
WHERE S.TYP_SER = 'FULL SERVICING';

--USING SUBQUERRY AND LIKE FUNCTION
SELECT C.CID,
       C.CNAME,
       C.CADD,
       C.C_CONTACT,
       S.SID,
       S.TYP_SER
FROM CUSTOMER_NEW C
JOIN SER_DET S
ON C.CID = S.CID
WHERE EXISTS ( SELECT CID FROM SER_DET 
               WHERE SER_DET.CID = C.CID AND TYP_SER LIKE '%FULL SERVICING%');
------------------------------------------------------------------------------------

--55 Select the employees who have not worked yet and left the job.
SELECT E.EID, E.ENAME, E.EJOB, E.EDOL
FROM EMPLOYEE E
WHERE E.EDOL IS NOT NULL
AND E.EID NOT IN ( SELECT EID FROM SER_DET);

--USING NOT EXIST AND SUBQUERRY
SELECT E.EID, E.ENAME, E.EJOB, E.EDOL
FROM EMPLOYEE E
WHERE NOT EXISTS ( SELECT EID FROM SER_DET 
                   WHERE SER_DET.EID = E.EID)
AND E.EDOL IS NOT NULL;

COMMIT;
---------------------------------------------------------------------------------

--56 Select employee who have worked first ever.
SELECT E.EID,
       E.ENAME,
       S.SER_DATE
FROM EMPLOYEE E
JOIN SER_DET S
ON E.EID = S.EID
WHERE S.SER_DATE = (SELECT MIN(SER_DATE)FROM SER_DET);

--USING ORDER BY & SUBQUERRY
SELECT * 
FROM (
SELECT E.EID,
       E.ENAME,
       S.SER_DATE
FROM EMPLOYEE E
JOIN SER_DET S
ON E.EID = S.EID
ORDER BY S.SER_DATE)

WHERE ROWNUM = 1 ;
--------------------------------------------------------------------------------

--57 Display all records falling in odd date
--USING MOD
SELECT *
FROM SER_DET
WHERE MOD(
    EXTRACT(DAY FROM TO_DATE(SER_DATE,'DD-MON-YY')),
2) = 1;

--USING MOD & OTHER FUNCTIONS;
SELECT *
FROM SER_DET
WHERE MOD(TO_NUMBER(TO_CHAR(TO_DATE(SER_DATE,'DD-MON-YY'),'DD')),2)=1;
-------------------------------------------------------------------------------

--58 Display all records falling in even date
--USING MOD
SELECT *
FROM SER_DET
WHERE MOD(
    EXTRACT(DAY FROM TO_DATE(SER_DATE,'DD-MON-YY')),
2) = 0;

--USING MOD & OTHER FUNCTIONS
SELECT *
FROM SER_DET
WHERE MOD(TO_NUMBER(TO_CHAR(TO_DATE(SER_DATE,'DD-MON-YY'),'DD')),2)=0;
----------------------------------------------------------------------------------

59 Display the vendors whose material is not yet used.
--USING NOT IN & JOIN & SUBQUERRY
SELECT V.VID,
       V.VNAME,
       V.VADD
FROM VENDORS V
WHERE V.VID NOT IN (
    SELECT DISTINCT P.VID
    FROM PURCHASE P
    JOIN SER_DET SD
    ON P.SPID = SD.SPID
);

--USING JOIN & NOT EXISTS
SELECT V.VID,
       V.VNAME,
       V.VADD
FROM VENDORS V
WHERE NOT EXISTS (
    SELECT VID
    FROM PURCHASE P
    JOIN SER_DET SD
    ON P.SPID = SD.SPID
    WHERE P.VID = V.VID
);
-----------------------------------------------------------------------------

60 Difference between purchase date and used date of spare part.
---BY USING MINUS (-)
SELECT P.PID,
       P.SPID,
       P.PDATE AS PURCHASE_DATE,
       S.SER_DATE AS USAGE_DATE,
       (
         TO_DATE(S.SER_DATE,'DD-MON-YY')
         -
         TO_DATE(P.PDATE,'DD-MON-YY')
       ) AS DAYS_DIFFERENCE
FROM PURCHASE P
JOIN SER_DET S
ON P.SPID = S.SPID
ORDER BY DAYS_DIFFERENCE;
-------------------------------------------------------------------------

COMMIT;

*********************************THANK YOU************************************













