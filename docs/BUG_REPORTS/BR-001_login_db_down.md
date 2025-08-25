# BR-001: Login shows error=2 when DB is down

**Env:** Local Tomcat, MySQL stopped  
**Severity:** Major  

**Steps:**
1. Stop MySQL service
2. Open /neon_gate.jsp, submit valid credentials

**Expected:** User-friendly error message about maintenance/unavailable  
**Actual:** Redirect to `neon_gate.jsp?error=2` with no explanation

**Evidence:** console stack trace in server logs

**Notes:** Add explicit user message and graceful fallback page.
