# Requires: pip install selenium && chromedriver in PATH
from selenium import webdriver
from selenium.webdriver.common.by import By

d = webdriver.Chrome()
d.get("http://localhost:5080/Cyberspace")
d.find_element(By.NAME, "username").send_keys("tester")
d.find_element(By.NAME, "password").send_keys("password123")
d.find_element(By.CSS_SELECTOR, "button[type=submit]").click()
assert "darkstream" in d.current_url.lower()
d.quit()
