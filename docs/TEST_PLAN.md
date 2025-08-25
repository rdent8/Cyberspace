# Cyberspace Test Plan

## Scope
Core flows of the NeoTokyo social app (JSP/Servlets, MySQL):
- Authentication (login/logout/register)
- Post creation ("DataPulse"), feed ("DarkStream")
- Like ("Voltage") and follow ("ShadowLink")

## Environment
- Browser: Chrome (desktop + mobile), Firefox
- Local: Tomcat (XAMPP) + MySQL `NeoTokyo`
- Test data: see `docs/TEST_DATA.sql`

## Test Cases (sample)
| ID | Area | Preconditions | Steps | Expected |
|----|------|---------------|-------|----------|
| TC-001 | Login | User exists | Go to /neon_gate.jsp, enter valid creds, submit | Redirect to /darkstream.jsp |
| TC-002 | Login (invalid) | User exists | Enter wrong password | Error query param `error=1` shown |
| TC-003 | Register | DB reachable | Submit new username/password | New user row, redirect to login |
| TC-010 | Create Post | Authenticated | Submit post text | Post appears at top of feed |
| TC-015 | Like/Unlike | Authenticated, post exists | Click like twice | Counter increments then decrements |
| TC-020 | Follow | Two users exist | Follow, refresh feed | Followed user's posts appear |
| TC-030 | Security | N/A | Refresh after logout | Session cleared, redirected to login |

Run the quick regression: `docs/REGRESSION_CHECKLIST.md`.
