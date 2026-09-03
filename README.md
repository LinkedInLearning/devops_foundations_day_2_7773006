# DevOps Foundations Day 2

This is the repository for the LinkedIn Learning course `DevOps Foundations Day 2`. The full course is available from
[LinkedIn Learning][lil-course-url].

![course-name-alt-text][lil-thumbnail-url]

## Getting started

For all labs in this course, you can choose from one of the two following options:

1. **Codespaces**. Codespaces gives you a virtual environment with an IDE (Visual Studio Code), a terminal, and all the
   tools you need already installed, so you can write and run code from your web browser, without having to install
   anything locally. To use codespaces:

    1. Click the green Code button in the top right of the repo.
    2. Select the Codespaces tab.
    3. Click the "Create codespace on main" button.

2. **Your own computer**. Alternatively, you can install and run everything from your own computer. Note that the
   scripts and commands in this course assume you’re on Linux or macOS; if you’re on Windows, you’ll need to use the
   [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install) or
   [Cygwin](https://cygwin.com/).

    1. `git clone` this repo into a folder on your computer.
    2. Go into that folder.
    3. [Install Mise](https://mise.jdx.dev/getting-started.html).
    4. Use Mise to install the tools for this course:

    ```shell
    cd .devcontainer
    mise trust .mise.toml
    mise install
    ```

## Folder structure

The code to use at the start of a lab will be in a folder named `chapter-xx/lab-yy/begin`. The “official” solution for
what the code should look like at the end of a lab will be in a folder named `chapter-xx/lab-yy/end`.

For example, for the lab in chapter 1, section 2:

- `chapter-01/lab-02/begin`: Do all your coding in this folder.
- `chapter-01/lab-02/end`: The "official" solution in case you get stuck or want to compare your code.

<!-- TODO: fill in these URLs -->

[lil-course-url]: https://www.linkedin.com/learning/
[lil-thumbnail-url]: https://media.licdn.com/dms/image/v2/D4E0DAQG0eDHsyOSqTA/learning-public-crop_675_1200/B4EZVdqqdwHUAY-/0/1741033220778?e=2147483647&v=beta&t=FxUDo6FA8W8CiFROwqfZKL_mzQhYx9loYLfjN-LNjgA

