--dataset and problem source: mavenanalytics.io/data-playground
--Search "Kickstarter" for dataset
--Further analysis of the following questions can be found at https://dataalchemy.substack.com/
CREATE TABLE kickstarter_projects (
    project_id numeric NOT NULL,
    project_name varchar NOT NULL,
    category varchar NOT NULL,
    subcategory varchar NOT NULL,
    country varchar NOT NULL,
    launched timestamp NOT NULL,
    deadline date NOT NULL,
    goal numeric NOT NULL,
    pledged numeric NOT NULL,
    backers numeric NOT NULL,
    project_status varchar NOT NULL)
    
COPY kickstarter_projects
FROM 'C:\directory\kickstarter_projects.csv' 
HEADER CSV DELIMITER ',';

SELECT * FROM kickstarter_projects;

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
--1. Which category has the highest success percentage? How many projects have been successful?

SELECT category, subcategory, count(subcategory) AS total_projects, 
       count(CASE WHEN project_status='Successful' THEN 1 END) AS total_successful,
       round(count(CASE WHEN project_status='Successful' THEN 1 END)/CAST(count(project_status)AS numeric)*100, 2)AS success_pct
FROM kickstarter_projects 
GROUP BY category, subcategory
ORDER BY success_pct DESC
LIMIT 25;
--Chiptune Music projects have had a 77.14% success rate. 27 out of 35 projects were successful.
--These results seem somewhat influenced by project subcategories with a low # of entries.
--HAVING clause added to exclude subcategories w/ <100 successful projects.

SELECT category, subcategory, count(subcategory) AS total_projects, 
       count(CASE WHEN project_status='Successful' THEN 1 END) AS total_successful,
       round(count(CASE WHEN project_status='Successful' THEN 1 END)/CAST(count(project_status)AS numeric)*100, 2)AS success_pct
FROM kickstarter_projects
GROUP BY category, subcategory
HAVING count(CASE WHEN project_status='Successful' THEN 1 END) >= 100
ORDER BY success_pct DESC
LIMIT 10;
--When excluding subcategories w/ <100 successful projects, Anthology Comics takes the lead.
--Anthology Comics: 74.81% success rate, 303 out of 405 projects were successful.
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--2. What project with a goal over $1,000 USD, had the biggest Goal Completion % (Pledged / Goal)? 
-----How much money was pledged?

SELECT round(pledged/goal*100, 2) AS goal_completion_pct,
    project_name, category, subcategory, country, CAST(launched AS date) AS launch_date, goal, pledged, backers, project_status
FROM kickstarter_projects
WHERE goal > 1000
ORDER BY pledged/goal DESC
LIMIT 10;
--A Tabletop Game known as "Exploding Kittens" had the highest goal completion percentage with total backing being 87,825.72% of goal.
--A lot of these appear to be tabletop games. An analysis is in order to find average funding % of subcategories WHERE goal > 1000.

SELECT round(avg(pledged)/avg(goal)*100, 2) AS avg_goal_completion_pct, category, subcategory, count(*)
FROM kickstarter_projects
WHERE goal > 1000
GROUP BY category, subcategory
ORDER BY avg(pledged)/avg(goal)*100 DESC
LIMIT 10;
--It does appear that Tabletop Games do very well on Kickstarter with an avg completion pct of 218.87% out of projects with a goal of more than 1k.
--Letterpress and Chiptune could potentially be skewed due to low # projects > 1k.
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--3. Can you identify any trends in project success rates over the years?

SELECT CONCAT(CAST(date_part('year', launched) AS varchar),' Q', CAST(date_part('quarter', launched) AS varchar)) AS quarter, 
       count(*) AS total_projects,
       round(count(CASE WHEN project_status='Successful' THEN 1 END)/CAST(count(project_status)AS numeric)*100, 2)AS success_pct,
       round(avg(pledged)/avg(goal)*100, 2) AS avg_goal_completion_pct
FROM kickstarter_projects
GROUP BY quarter
ORDER BY quarter
--Success percentage and avg goal completion pct seems to have gone up and stabilized. 
--Data viz will be needed for any final conclusions on this question.
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--4. As an investor, what types of projects should you be looking at to guarantee future success?

SELECT round(avg(pledged)/avg(goal)*100, 2) AS avg_goal_completion_pct, category, subcategory, count(*)
FROM kickstarter_projects
GROUP BY category, subcategory
HAVING avg(pledged)/avg(goal)*100 >= 100 AND count(*) >= 100
ORDER BY avg(pledged)/avg(goal)*100 DESC;

--Looking for the safest categories as an investor, I brought down the secondary query I wrote for question 2.
--This time, I got rid of the filter for projects > 1k goal to see what the avg goal completion is for all projects in the subcategory.
--I used a HAVING clause to find only project subcategories with a 100% or greater avg completion rate.
--I paired AND with the HAVING clause to also filter out any subcategory with less than 100 projects.
--This was done to filter out obscure subcategories that may have a handful of renowned projects skewing the average, which I pointed out earlier
-----as being a potential problem with Chiptune Music and Letterpresses.

--The following subcategories have been identified using this methodology as being the safest:
-----Tabletop Games - Games
-----Camera Equipment - Tech
-----Anthology - Comics
-----3D Printing - Tech
-----Typography - Design
-----DIY Electronics - Tech
-----Webcomics - Comics