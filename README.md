# Kickstarter-Project
To analyze trends in Kickstarter dataset with problem statements provided by mavenanalytics.io/data-playground.

    Must be executed in a PostgreSQL-friendly database environment. At least one Postgres-specific function was utilized.
    Replace the /directory/ placeholder in the COPY statements with the destination directory of this repo.

Companion analysis with visualizations to come in corresponding Substack article: https://dataalchemy.substack.com

Problem Statements with Brief Analysis:
--1. Which category has the highest success percentage? How many projects have been successful?
--Chiptune Music projects have had a 77.14% success rate. 27 out of 35 projects were successful.
--These results seem somewhat influenced by project subcategories with a low # of entries.
--HAVING clause added to exclude subcategories w/ <100 successful projects.
--When excluding subcategories w/ <100 successful projects, Anthology Comics takes the lead.
--Anthology Comics: 74.81% success rate, 303 out of 405 projects were successful.

--2. What project with a goal over $1,000 USD, had the biggest Goal Completion % (Pledged / Goal)? 
-----How much money was pledged?
--A Tabletop Game known as "Exploding Kittens" had the highest goal completion percentage with total backing being 87,825.72% of goal.
--A lot of these appear to be tabletop games. An analysis is in order to find average funding % of subcategories WHERE goal > 1000.
--It does appear that Tabletop Games do very well on Kickstarter with an avg completion pct of 218.87% out of projects with a goal of more than 1k.
--Letterpress and Chiptune could potentially be skewed due to low # projects > 1k.

--3. Can you identify any trends in project success rates over the years?
--Success percentage and avg goal completion pct seems to have gone up and stabilized. 
--Data viz will be needed for any final conclusions on this question.

--4. As an investor, what types of projects should you be looking at to guarantee future success?
-Looking for the safest categories as an investor, I brought down the secondary query I wrote for question 2.
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
