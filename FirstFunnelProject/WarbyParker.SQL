 --Quiz funnel
 SELECT *
 FROM survey
 LIMIT 10;


/*
Users will “give up” at different points in the survey. Let’s analyze how many users move from Question 1 to Question 2, etc.

Create a quiz funnel using the GROUP BY command.

What is the number of responses for each question?
*/
SELECT question,
  COUNT(DISTINCT user_id)
FROM survey
GROUP BY 1;


/*
Using a spreadsheet program like Excel or Google Sheets, calculate the percentage of users who answer each question:

Which question(s) of the quiz have a lower completion rates?

What do you think is the reason?

***We divide the number of people completing each step by the number of people completing the previous step***

Question 1: "What are you looking for?"
Percent Completing this Question: 100% (500 user_id)
Why: First question is "What are you looking for" and the user cannot continue without answering, also its not a personal question like asking age, so there is a high completion rate.

Question 2: "What's your fit"
Percent Completing this Question: 95% (475 user_id)
475 for question 2 / 500 answers for question 1 = 0.95%
Why: A good amount of answers because its an important question for the customer to find their size in glasses.

Question 3: "Which shapes do you like?"
Percent Completing this Question: 80% (380/475)
Why: Perhaps some users are contact wearers or just do not want to share what shape they like when browsing as they are not unsure yet.

Question 4: "Which colors do you like?"
Percent Completing this Question: 95% (361/380)
Why: This is an easy question and engages the customer. Also, its important to help the user search for the color they want. However, we have a 95% completion rate because not every customer is going to care about color, or perhaps they are unsure yet.

Question 5: "When was your last eye exam?"
Percent Completing this Question: 74% (270/361)
Why: This question is more personal. Customers may not remember when their last eye exam, and as such will skip the question entirely, which is why this question has the lowest response rate.
*/


/*
Warby Parker’s purchase funnel is:

Take the Style Quiz → Home Try-On → Purchase the Perfect Pair of Glasses

During the Home Try-On stage, we will be conducting an A/B Test:

50% of the users will get 3 pairs to try on
50% of the users will get 5 pairs to try on
Let’s find out whether or not users who get more pairs to try on at home will be more likely to make a purchase.

The data will be distributed across three tables:

quiz
home_try_on
purchase
Examine the first five rows of each table

What are the column names?
*/
-- column names: user_id, style, fit, shape,color
SELECT *
FROM quiz
LIMIT 5;

--column names: user_id, number_of_pairs, address
SELECT * 
FROM home_try_on 
LIMIT 5;

--column names: user_id, product_id, style, model_name, color, price
SELECT *
FROM purchase 
LIMIT 5;

/*

We’d like to create a new table with the following layout:

user_id	  is_home_try_on	number_of_pairs	 is_purchase
4e8118dc	True	            3	             False
291f1cca	True	            5	             False
75122300	False	            NULL	         False

Each row will represent a single user from the browse table:

If the user has any entries in home_try_on, then is_home_try_on will be True.
number_of_pairs comes from home_try_on table
If the user has any entries in purchase, then is_purchase will be True.
Use a LEFT JOIN to combine the three tables, starting with the top of the funnel (quiz) and ending with the bottom of the funnel (purchase).

Select only the first 10 rows from this table (otherwise, the query will run really slowly).
*/

SELECT DISTINCT q.user_id,
      h.user_id IS NOT NULL AS 'is_home_try_on',
      h.number_of_pairs,
      p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h 
  ON q.user_id = h.user_id
LEFT JOIN purchase p
  ON p.user_id = q.user_id
LIMIT 10;


/*

Once we have the data in this format, we can analyze it in several ways:

We can calculate overall conversion rates by aggregating across all rows.
We can compare conversion from quiz→home_try_on and home_try_on→purchase.
We can calculate the difference in purchase rates between customers who had 3 number_of_pairs with ones who had 5.
And more!
We can also use the original tables to calculate things like:

The most common results of the style quiz.
The most common types of purchase made.
And more!

What are some actionable insights for Warby Parker?
*/
