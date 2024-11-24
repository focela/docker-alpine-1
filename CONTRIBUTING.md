# Contributing

We'd love your help making focela/alpine the very best base image for building
reliable and efficient Docker containers!

If you'd like to propose improvements or new features for the Dockerfile,
please [open an issue][open-issue] describing your ideas — discussing changes
ahead of time makes pull request reviews much smoother. In your issue, pull
request, and all other communications, please remember to treat fellow
contributors with respect! We take our [code of conduct](CODE_OF_CONDUCT.md)
seriously.

Note that you'll need to sign [Focela's Contributor License Agreement][cla]
before we can accept any of your contributions to the Dockerfile. If necessary,
a bot will remind you to accept the CLA when you open your pull request.

## Setup

[Fork][fork], then clone the repository:

```bash
git clone git@github.com:your_github_username/alpine.git
cd alpine
git remote add upstream https://github.com/focela/alpine.git
git fetch upstream
```

Make sure that building the Dockerfile passes successfully by running the
following command:

```bash
docker build -t focela/alpine .
```

[fork]: https://github.com/focela/alpine/fork
[open-issue]: https://github.com/focela/alpine/issues/new
[cla]: https://cla-assistant.io/focela/alpine
