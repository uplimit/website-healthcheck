# Website Healthcheck Action

This actions checks your website if it's returning status code 200 and checks for specified text on the given page.

An example of website-healthcheck in a GitHub Action:

```yaml
name: "Check for website health and title text"

on: [push]

jobs:
  health_check_job:
    runs-on: ubuntu-latest
    name: Check for status 200 and title text "lokerse.dev"
    steps:
      - uses: actions/checkout@v2
      - id: test
        uses: uplimit/website-healthcheck@v4
        with:
          web-url: "https://uplimit.com"
          scan-for-text: "uplimit"
          maximum-retries: 10
          duration-between-retries: 5
```
