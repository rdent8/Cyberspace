# Regression Checklist (10-minute)

- [ ] Login valid/invalid routes correctly
- [ ] Session persists after navigation; logout clears session
- [ ] Create post works; empty post rejected
- [ ] Feed ordering is newest-first
- [ ] Like increments/decrements without double count
- [ ] Follow/unfollow updates feed
- [ ] 404/500 pages not exposed to user
- [ ] No stack traces visible in UI
- [ ] Basic XSS blocked in post body (`<script>` rendered harmless)
- [ ] CSS not broken on 375x812 and 1440x900
