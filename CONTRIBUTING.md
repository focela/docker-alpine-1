# Contributing

We'd love your help making `focela/alpine` the very best custom Alpine-based
image with integrated utilities for monitoring, logging, and scheduling.
This project supports tools like Zabbix, Fluent Bit, and others to improve
container efficiency and reliability.

If you'd like to propose improvements or new features for the Dockerfile,
please [open an issue][open-issue] describing your ideas. Discussing changes
ahead of time makes pull request reviews much smoother. In your issue, pull
request, and all other communications, please treat fellow contributors with
respect! We take our [Code of Conduct](CODE_OF_CONDUCT.md) seriously.

Note: You must sign [Focela's Contributor License Agreement (CLA)][cla] before
we can accept any contributions. If necessary, a bot will remind you to accept
the CLA when you open your pull request.

## Setup

Follow these steps to set up your environment:

1. **Fork the repository:**
   Click the [fork][fork] button on the GitHub repository to create your copy.

2. **Clone your fork:**
   ```bash
   git clone git@github.com:your_github_username/alpine.git
   cd alpine
   ```

3. **Add the upstream repository:**
   ```bash
   git remote add upstream https://github.com/focela/alpine.git
   git fetch upstream
   ```

4. **Verify that the Dockerfile builds successfully:**
   ```bash
   docker build -t focela/alpine .
   ```

## Making Changes

Start by creating a new branch for your feature or fix:

```bash
# Ensure your local main branch is up to date
git checkout main
git fetch upstream
git rebase upstream/main

# Create a new branch for your changes
git checkout -b feature_name
```

### Making and Testing Changes

1. **Modify the Dockerfile:**
    - Make sure your changes align with the project's goals and coding style.

2. **Test your changes:**
    - Verify that the Dockerfile builds correctly:
      ```bash
      docker build -t focela/alpine .
      ```

3. **Push your changes:**
   ```bash
   git push origin feature_name
   ```

## Opening a Pull Request

1. **Submit your changes:**
   Use the GitHub UI to open a pull request for your branch. Provide a clear
   and concise description of your changes, referencing any relevant issues.

2. **Review process:**
    - Wait for the maintainers to review your pull request. We aim to respond
      within a few business days.
    - Maintain backward compatibility and address any feedback promptly.

3. **Approval and merge:**
   Once approved, your changes will be merged by a maintainer.

## Guidelines for Contributions

To improve the likelihood of your changes being accepted:

- Ensure the Dockerfile builds and runs successfully.
- Write a [clear and descriptive commit message][commit-message].
- Avoid introducing breaking changes unless absolutely necessary.

[fork]: https://github.com/focela/alpine/fork
[open-issue]: https://github.com/focela/alpine/issues/new
[cla]: https://cla-assistant.io/focela/alpine
[commit-message]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
