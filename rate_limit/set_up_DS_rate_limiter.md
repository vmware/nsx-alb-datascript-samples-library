# Setting up the DS Rate Limiter in the Application Profile

1. On the controller, go to **Templates**
2. Under the **Application** tab, select and edit your Application Profile 
   (or create a new one)
3. Select the **DDoS** tab
4. Under **Add Rate Limit**, select **Rate Limit all HTTP requests that map to any 
   custom string to all URLs of the Virtual Service.**
5. Enter the values for **Threshold** and **Time Period**. 
   For this particular use-case select **Action** as _Send HTTP Local Response_ and 
   **Status Code** as _429_. You do not need to upload a file.
6. Click **Save**
