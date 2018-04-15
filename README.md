# RMF model by R

This article(http://www.idatacamp.com/1196.html/) reminds me that when I  work at a starup comapny 5 years ago,  
I also used RMF model to analyze clients in order to choose a good customer for good quality.
Let me practice again.

- Recency – How recently did the customer purchase?
- Frequency – How often do they purchase?
- Monetary Value – How much do they spend?

## Steps
1. creating a customer’s order record including “customer ID(id)”, “spending” and “date” as a data frame
2. get R M F value(by customer)
3. merging R,M,F to create a new data frame 
4. Creating R,M,F levels and giving each values a weight to Calculate RMF score
5. ploting it
