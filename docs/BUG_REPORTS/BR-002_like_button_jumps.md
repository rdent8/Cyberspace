# BR-002: Page jumps when liking a post

**Env:** Localhost, Chrome 117, Windows 10  
**Severity:** Minor (annoyance but doesn’t block core flow)

**Steps to Reproduce:**
1. Log in as valid user
2. Scroll down feed until multiple posts are visible
3. Click the "Voltage" (like) button on a post

**Expected Result:**  
Like count increments smoothly, page stays at same scroll position.

**Actual Result:**  
Page jumps upward unexpectedly after clicking, forcing the user to scroll back down.

**Evidence:**  
Observed repeatedly on local Tomcat deployment.

**Notes:**  
UI bug, likely due to refresh logic not preserving scroll position.
