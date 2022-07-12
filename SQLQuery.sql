--Combining the table

alter table dbo.superstore /* To make same no. of column */
drop column profit

Select * Into combinedTable
from
(
select *
from dbo.superstore_test
union
select *
from dbo.superstore_train
) as newTable

select *
from dbo.combinedTable
order by [Row ID]

--Cheking Postal code

select distinct LEN([Postal Code]) as noOfCharcters, COUNT([Postal Code]) as noOfPostcode
from dbo.combinedTable
group by Len([Postal Code])

--Converting decimal amount of sales to round of 2

select Sales, ROUND(Sales,2)
from dbo.combinedTable

update dbo.combinedTable
set Sales= Round(Sales,2)

--Create a new column sales_next to display the values of the row below a given row
select  [Order Date],Category, [sub-Category] , Sales, quantity,
LEAD(Sales,1) over (partition by Category,[sub-Category] order by [sub-Category],quantity) as sales_next
from dbo.combinedTable

--Create a new column sales_previous to display the values of the row above a given row.
select  [Order Date],Category, [sub-Category] , Sales, quantity,
LAG(Sales,1) over (partition by Category,[sub-Category] order by [sub-Category],quantity) as sales_Previous
from dbo.combinedTable

--Rank the database on sales in descending order

select *,
RANK() over(partition by Category order by Sales desc) as rnk
from dbo.combinedTable

--Use common SQL commands and aggregate functions to show the monthly and daily sales averages.

with monthly_avg_sales 
as
(
select [Order Date],FORMAT([Order Date],'yyy-MMM') as month,Sales
from dbo.combinedTable
)
select month, AVG(Sales) as monthlySales
from monthly_avg_sales
group by month
order by month


with daily_avg_Sales 
as
(
	select [Order Date],FORMAT([Order Date],'yyy-MMM-dd') as day,Sales
	from dbo.combinedTable
)
select day,AVG(Sales) as dailySales
from daily_avg_Sales
group by day
order by day

--Evaluate moving averages using the window functions.

select *,
AVG(Sales)over(Order by [Order date] rows between 29 preceding and current row ) as moving_average
from dbo.combinedTable



