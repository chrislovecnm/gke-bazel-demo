# Developing the Bazel / K8s demo

## Helpful Scripts

`scripts/local_vs_remote.sh` will remove the deployed applications, run `make create` locally, remove the apps again, and then run `make create` with RBE enabled. See the README for notes on RBE.

You can also do a `make destroy_apps` to just destroy the apps that have been deployed to your cluster, without tearing down the cluster.

## Alpha RBE Support

**RBE on GCP is in Alpha, so do not use in production.**

From the official [Bazel Remote Build Execution docs](https://blog.bazel.build/2018/10/05/remote-build-execution.html):

```
By default, Bazel executes builds and tests on your local machine. Remote execution of a Bazel build allows you to distribute build and test actions across multiple machines, such as a datacenter.

Remote execution provides the following benefits:

* Faster build and test execution through scaling of nodes available for parallel actions
* A consistent execution environment for a development team
* Reuse of build outputs across a development team
```

Google Cloud Platform has [RBE support in alpha](https://blog.bazel.build/2018/10/05/remote-build-execution.html). If you'd like to run this demo with GCP RBE support, you will need to do a few things:

1. Fill out [this form](https://docs.google.com/forms/d/e/1FAIpQLScBai-iQ2tn7RcGcsz3Twjr4yDOeHowrb6-3v5qlgS69GcxbA/viewform) to get alpha access.
2. When you're onboarded to the alpha program, you'll be asked to give project ids to the team so they can whitelist your project as able to use RBE.
3. You may want to re-authenticate to ensure your alpha access is configured locally with `gcloud auth application-default login`.
3. Run the `make create` step of this demo with an RBE flag, like this: `RBE=true make create`.

Troubleshooting:
* If you want to verify your alpha access and RBE authentication are correct, the RBE documentation has instructions for building an example application. Follow those instructions to verify your setup.
* If you're getting errors when running `gcloud` alpha commands in `scripts/create.sh`, make sure to update all gcloud components: `gcloud components update`.
* If you're not the owner of the project you're using, you'll likely need to add some IAM roles to your account to enable the RBE API & create worker pools.

## Linting the Project

You can run the linter simply with `make lint`, however you'll need to install some dependencies first:

* [Flake8](http://flake8.pycqa.org/en/latest/) is used to lint python source files, so you'll need to install it via `python -m pip install flake8 --user`
* [checkstyle](http://checkstyle.sourceforge.net/) is used to reformat & lint Java source files. Download https://github.com/checkstyle/checkstyle/releases/download/checkstyle-8.15/checkstyle-8.15-all.jar and update the path (defaults to `~/Downloads`) to the executable in `test/make.sh` on line 84, in the `check_java` function.
* [shellcheck](https://www.shellcheck.net/) is used to check your shell scripts.
* [python3](https://www.python.org/downloads/) is required to run the Google OSS header verification script.
