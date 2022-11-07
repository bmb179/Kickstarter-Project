--QUESTION 1 VIZ
COPY (
SELECT category, subcategory, count(subcategory) AS total_projects, 
       count(CASE WHEN project_status='Successful' THEN 1 END) AS total_successful,
       round(count(CASE WHEN project_status='Successful' THEN 1 END)/CAST(count(project_status)AS numeric)*100, 2)AS success_pct
FROM kickstarter_projects 
GROUP BY category, subcategory
ORDER BY success_pct DESC
)
TO 'C:\directory\Ques1Kckstrtr.csv'

--QUESTION 2 VIZ
COPY (
SELECT round(pledged/goal*100, 2) AS goal_completion_pct,
    project_name, category, subcategory, country, CAST(launched AS date) AS launch_date, goal, pledged, backers, project_status
FROM kickstarter_projects
WHERE goal > 1000
ORDER BY pledged/goal DESC
LIMIT 10
)
TO 'C:\directory\Ques2aKckstrtr.csv'

COPY (
SELECT round(avg(pledged)/avg(goal)*100, 2) AS avg_goal_completion_pct, category, subcategory, count(*)
FROM kickstarter_projects
WHERE goal > 1000
GROUP BY category, subcategory
ORDER BY avg(pledged)/avg(goal)*100 DESC
)
TO 'C:\directory\Ques2bKckstrtr.csv'

--QUESTION 3 VIZ
COPY (
SELECT CONCAT(CAST(date_part('year', launched) AS varchar),' Q', CAST(date_part('quarter', launched) AS varchar)) AS quarter, 
       count(*) AS total_projects,
       round(count(CASE WHEN project_status='Successful' THEN 1 END)/CAST(count(project_status)AS numeric)*100, 2)AS success_pct,
       round(avg(pledged)/avg(goal)*100, 2) AS avg_goal_completion_pct
FROM kickstarter_projects
GROUP BY quarter
ORDER BY quarter
)
TO 'C:\directory\Ques3Kckstrtr.csv'

--QUESTION 4 VIZ
COPY (
SELECT round(avg(pledged)/avg(goal)*100, 2) AS avg_goal_completion_pct, category, subcategory, count(*)
FROM kickstarter_projects
GROUP BY category, subcategory
HAVING avg(pledged)/avg(goal)*100 >= 100 AND count(*) >= 100
ORDER BY avg(pledged)/avg(goal)*100 DESC
)
TO 'C:\directory\Ques4Kckstrtr.csv'