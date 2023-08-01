-- select * from hr 

-- select sum(Employee_Count) as employee_count from hr 
-- where education="high School"
-- where department="sales"
-- where education_field="medical"

-- select count(employee_count) from hr
-- where  attrition='yes' and Department='r&d' 
-- and Education_Field='medical' 

-- select round(((select count(attrition) from hr where attrition='yes'and Department='sales')/sum(employee_count))*100, 2) as rate from hr
-- where Department='sales'

-- select sum(employee_count)- (select count(attrition) from hr  where  attrition="yES" and gender='male') from hr where gender='male'

-- select round(avg(age),0) as avg_age from hr
-- select gender,count(attrition) from hr where attrition='YES' and education_field='marketing' group by gender order by gender desc

-- select department,count(attrition),
-- round((count(attrition) 
-- /(select count(attrition) from hr where attrition='yes' and gender='female'))*100,2) as pct
--  from hr
-- where attrition='yes' and gender ='female'
-- group by department

select age,sum(employee_count) from hr group by age order by age