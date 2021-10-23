-- We can do a churn rate from the subscription start (2016-12-01) to max (2017-03-30). So december, jan, feb, and march.

--Calculate the churn rate for each segment

--You’ll be calculating the churn rate for both segments (87 and 30) over the first 3 months of 2017 (you can’t calculate it for December, since there are no subscription_end values yet). To get started, create a temporary table of months.

WITH months AS
(
  SELECT 
    '2017-01-01' AS first_day,
    '2017-01-31' AS last_day
    UNION
  SELECT
    '2017-02-01' AS first_day,
    '2017-02-28' AS last_day
    UNION
  SELECT
     '2017-03-01' AS first_day,
     '2017-03-31' AS last_day
),
--Create a temporary table, cross_join, from subscriptions and your months. Be sure to SELECT every column.
cross_join AS 
(SELECT * 
FROM subscriptions
CROSS JOIN months
),


/*Create a temporary table, status, from the cross_join table you created. This table should contain: 
id selected from cross_join
month as an alias of first_day
is_active_87 created using a CASE WHEN to find any users from segment 87 who existed prior to the beginning of the month. This is 1 if true and 0 otherwise.
is_active_30 created using a CASE WHEN to find any users from segment 30 who existed prior to the beginning of the month. This is 1 if true and 0 otherwise*/

status AS
(
  SELECT id, first_day AS month,
  CASE 
    WHEN(subscription_start < first_day) 
    AND(subscription_end > first_day)
    OR(subscription_end IS NULL)
    AND (segment = 87)
      THEN 1
      ELSE 0
    END AS is_active_87,

  CASE 
    WHEN
      (subscription_start < first_day)
      AND(segment = 30)
      AND(subscription_end >= last_day)
      OR(subscription_end IS NULL)
        THEN 1 
        ELSE 0 
          END AS is_active_30,
  --Step 5 complete

    --Step 6: Add an is_canceled_87 and an is_canceled_30 column to the status temporary table. This should be 1 if the subscription is canceled during the month and 0 otherwise.
  CASE 
    WHEN
      (subscription_end BETWEEN first_day AND last_day) 
      AND (segment = 87)
      THEN 1
      ELSE 0
          END AS is_canceled_87,
CASE 
  WHEN(subscription_end BETWEEN first_day AND last_day) 
  AND (segment = 30)
      THEN 1
      ELSE 0
        END AS is_canceled_30
        FROM cross_join
),


/*Create a status_aggregate temporary table that is a SUM of the active and canceled subscriptions for each segment, for each month.

The resulting columns should be:

sum_active_87
sum_active_30
sum_canceled_87
sum_canceled_30*/

status_aggregate AS 
(
  SELECT 
  month,
  SUM(is_active_87) AS sum_active_87,
  SUM(is_active_30) AS sum_active_30,
  SUM(is_canceled_87) AS sum_canceled_87,
  SUM(is_canceled_30) AS sum_canceled_30
  FROM status
  GROUP BY month
)

--Step 8: Calculate the churn rates for the two segments over the three month period. Which segment has a lower churn rate?
SELECT 
month,
1.0 * sum_canceled_87 / sum_active_87 AS churn_87,
1.0 * sum_canceled_30 / sum_active_30 AS churn_30
FROM status_aggregate;

--Step 9: How would you modify this code to support a large number of segments?
/*
We could remove this logic "AND (segment = 87)" and do "are they active" or "are they canceled" by adding one column, could add a segment column, and group by segment just as grouping by month. Group by month and segment instead of needing to hard code things. Less hard coding the segment numbers could make life easier.
*/