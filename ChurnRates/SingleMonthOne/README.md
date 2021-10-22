<h1> Calculating Churn Rates in SQL</h1>
<br><br> How to calculate Churn Rates in SQL: In this example, we’ll calculate churn for the month of December 2016. <br><br>
Typically, there will be data in a subscriptions table available in the following format: 
<b>id</b> - the customer id<br> 
<b>subscription_start</b> - the subscribe date<br>
<b>subscription_end</b> - the cancel date
<br><br> 
<br> When customers have a NULL value for their subscription_end, that’s a good thing. It means they haven’t canceled! 
<br> <br>
<h3>How to calculate Churn Rates</h3> <img src="churncancel.png" alt="How to calculate churn rates picture" height="200" width="300"> 
<h3>Overall result for this example and Database Schema </h3> <img src="QueryResultsAndDB.JPG" alt="Query Results with Database Schema" height="300" width="500">
