# DevOps Foundations Day 2

This is the repository for the LinkedIn Learning course `DevOps Foundations Day 2`. The full course is available from
[LinkedIn Learning][lil-course-url].

![course-name-alt-text][lil-thumbnail-url]

## Getting started

First, [create a fork](https://docs.github.com/en/pull-requests/how-tos/work-with-forks/fork-a-repo) of this repo in
your own GitHub account so you can commit & push changes.

Once you've done that, you can work on the fork using one of the two following options:

1. **Codespaces**. Codespaces gives you a virtual environment with an IDE (Visual Studio Code), a terminal, and all the
   tools you need already installed, so you can write and run code from your web browser, without having to install
   anything locally. To use codespaces:

    1. Click the green Code button in the top right of your fork of the repo.
    2. Select the Codespaces tab.
    3. Click the "Create codespace on main" button.

2. **Your own computer**. Alternatively, you can install and run everything from your own computer. Note that the
   scripts and commands in this course assume you’re on Linux or macOS; if you’re on Windows, you’ll need to use the
   [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install) or
   [Cygwin](https://cygwin.com/).

    1. `git clone` your fork of the repo into a folder on your computer.
    2. Go into that folder.
    3. [Install Mise](https://mise.jdx.dev/getting-started.html).
    4. Use Mise to install the tools for this course:

    ```shell
    cd .devcontainer
    mise trust .mise.toml
    mise install
    ```

## Lab solutions and branches

This course consists of a series of labs that build on each other.

* **Start in the `main` branch.** The code you start with in the first lab is in the `main` branch. Write all your
  code in this branch, and push it to your fork of the GitHub repo every time you complete a lab.

* **Use the `chapter-xx/lab-yy` branch to see what the code should look like at the _end_ of a lab.** To see what the
  code should look like at the _end_ of a lab (e.g., if you're stuck or to check your solution), take a look at
  the branch with the name `chapter-xx/lab-yy`, where `xx` is the 2-digit chapter number and `yy` is the 2-digit lab
  number. For example, to see what the code should like like at the end of lab 8 in Chapter 2, take a look at the
  branch `chapter-02/lab-08`.

* **Use the previous lab's branch to see what the code should look like at the _beginning_ of a lab.** To see what the
  code should look like at the _beginning_ of a lab (e.g., because you skipped a lab or your code is a bit different),
  take a look at the branch of the previous lab. The labs all build on each other, so the code at the end of the
  previous lab is the code you use at the start of the next lab. For example, to see what the code should like like at
  the beginning of lab 8 in Chapter 2, take a look at the branch `chapter-02/lab-05`.

* **See all the labs.** To see all the labs, you can do one of the following:

    * Open [the branches page](/branches/all) in your browser.
    * Run `git branch` in your terminal.

* **See what changed between labs.** If you want to see what changed between two labs, rather than just
  what the code looks like at the end of a lab, you can do one of the following:

    * [Use GitHub compare](/compare) in your browser. You can use the UI to select the branches to compare, or you can
      manually format the URL: e.g., use `/compare/<BRANCH_1>...<BRANCH_2>` to compare `BRANCH_1` to `BRANCH_2`. For
      example, to see the changes between lab 5 and lab 8 of Chapter 8, use the URL
      [/compare/chapter-02/lab-05...chapter-02/lab-08](/compare/chapter-02/lab-05...chapter-02/lab-08).

    * Run `git diff <BRANCH_1> <BRANCH_2>` in your terminal. For example, to see the changes between lab 5 and lab 8 of
      Chapter 8, run `git diff chapter-02/lab-05 chapter-02/lab-08`.

<!-- TODO: fill in these URLs -->

[lil-course-url]: https://www.linkedin.com/learning/
[lil-thumbnail-url]: https://media.licdn.com/dms/image/v2/D4E0DAQG0eDHsyOSqTA/learning-public-crop_675_1200/B4EZVdqqdwHUAY-/0/1741033220778?e=2147483647&v=beta&t=FxUDo6FA8W8CiFROwqfZKL_mzQhYx9loYLfjN-LNjgA

