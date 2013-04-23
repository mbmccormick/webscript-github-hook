webscript-github-hook
=====================

Continuous deployment to Webscript from GitHub. This webhook will deploy your changes from GitHub to Webscript. Here's how to set it up:

1. Login to your Webscript account and find your API key from the Account Settings page.
2. Add a webhook to your repository with the URL `https://code.webscript.io/github?email=EMAIL_ADDRESS&key=API_KEY`.
3. When you push your changes to GitHub, the webhook will sync your changes to Webscript!

Currently, this webhook script will create a *.webscript.io subdomain with the same name as your repository. For example, if you push to `github.com/mbmccormick/foo` then your code will be deployed to `foo.webscript.io`.
