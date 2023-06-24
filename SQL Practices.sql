create database RK;
USE RK;
CREATE TABLE Employee(Emp_id INT,Ename VARCHAR(250),Location VARCHAR(250),Job VARCHAR(250),Salary INT);
INSERT INTO Employee(Emp_id,Ename,Location,Job,Salary) VALUES(101,'Rama krishna','Hyderabad','DB Admin',60000);
INSERT INTO Employee(Emp_id,Ename,Location,Job,Salary) VALUES(102,'Naveena','Borabanda','Accountant',75000);
INSERT INTO Employee(Emp_id,Ename,Location,Job,Salary) VALUES(103,'Shekar','Nizambad','Developer',50000);
INSERT INTO Employee(Emp_id,Ename,Location,Job,Salary) VALUES(104,'Yashwanth','Hyderabad','admin',60000);
INSERT INTO Employee(Emp_id,Ename,Location,Job,Salary) VALUES(105,'Rakesh','Mumbai','ios Developer',80000);
INSERT INTO Employee(Emp_id,Ename,Location,Job,Salary) VALUES(106,'Rin','Mysor','Network Engineer',90000);
INSERT INTO Employee(Emp_id,Ename,Location,Job,Salary) VALUES(107,'Radha','Hyderabad','Project Manager',85000);
SELECT * FROM Employee;
with cte as(
SELECT e.*,
SUM(Salary) OVER(PARTITION BY Job) as sum_salary,
AVG(Salary) OVER(PARTITION BY Job) as Avg_salary,
MAX(Salary) OVER(PARTITION BY Job ORDER BY Salary Desc) as Max_sal,
MIN(Salary) OVER(PARTITION BY Job ORDER BY Salary DESC)  as Min_sal,
COUNT(*) OVER() as count_all,
RANK() OVER(PARTITION BY Location ORDER BY Salary) as rn,
DENSE_RANK() OVER(PARTITION BY Location ORDER BY Salary) as dn,
LEAD(Salary,0,1) OVER(PARTITION BY Location) as Lead_salary,
LAG(Salary,0,1) OVER(PARTITION BY Location) as Lag_salary
FROM Employee e)
SELECT * FROM cte;

SELECT Ename,Location,Job,
FIRST_VALUE(Salary) OVER w  AS Fv,
LAST_VALUE(Salary) OVER w as Lv
FROM Employee
-- WHERE salary>50000
-- Alternative method
WINDOW  w as (PARTITION BY Job ORDER BY Salary DESC
RANGE BETWEEN UNBOUNDED PRECEDING AND 2 FOLLOWING);  
SELECT Ename,Location,Job,
FIRST_VALUE(Salary) OVER()  AS Fv,
LAST_VALUE(Salary) OVER(PARTITION BY Location ORDER BY Salary ASC
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING  ) as Lv
FROM Employee;
-- WHERE salary>50000
-- Alternative method      

-- second highest salary partion by location
-- Nth_value
SELECT *,
NTH_VALUE(Salary,2) OVER(PARTITION BY Location ORDER BY Salary DESC
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) as second_salary
FROM Employee;
-- Position of the salary using NTILE Function 
SELECT Ename,Job ,
CASE WHEN x.sal=1 THEN 'Highest salary' 
WHEN x.sal=2 THEN 'Mid salary' 
WHEN x.sal=3 THEN 'Lowest salary' END 'Position'
FROM(
SELECT *,
NTILE(3) OVER(ORDER BY Salary DESC) as Sal
FROM Employee) x;
-- cume_dist function  
SELECT Ename,Location ,Job,(CUM_DIST || '%') as cum_dist_per,
CASE WHEN X.Salary>5000 THEN 'Heigher' END 'Salary'FROM(
SELECT *,
CUME_DIST() OVER(ORDER BY Salary DESC) as CUM_DIST,
ROUND(CUME_DIST() OVER (ORDER BY Salary)*100,2) AS cum_DIST1
FROM Employee ) X
WHERE X.CUM_DIST<=95000;
-- Percent_rank  
SELECT Ename,Location,Job,Salary,pct FROM(
	SELECT *,
	PERCENT_RANK() OVER(ORDER BY Salary DESC) as pect,
	ROUND(PERCENT_RANK() OVER( ORDER BY Salary  DESC)*100,2) as pct
	FROM Employee) x
WHERE Location='Hyderabad';

select * from Employee





