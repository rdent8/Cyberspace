# BR-003: SQL error when submitting empty post

**Env:** Localhost, Chrome 117, Windows 10  
**Severity:** Major (backend error exposed)

**Steps to Reproduce:**
1. Log in as valid user
2. Navigate to create post
3. Leave the text area blank and click submit

**Expected Result:**  
User sees validation error message like “Post cannot be empty.”

**Actual Result:**  
500 error page displayed, SQL exception visible in console logs.

**Evidence:**  
Screenshot shows server error with stack trace.

**Notes:**  
Should validate input client-side and server-side to block empty posts.
