# Cleanup Venvs

After a while we end up with a lot of virtual environments on the computer. This can eat up a lot of space on the computer. This script will remove all Python virtual environments from the computer that are older than 30 days.

This is also written in Mojo & a little Python (for now).

## Issues

- Sub-sub directories don't get recognised as a directory. See below the current (incorrect) behaviour.

    ```text
    .
    └── subfolder (is dir)
        └── sub-subfolder (isn't dir)
            └── venv (isn't dir)
    ```

- Using Python for user input and to delete the directories. This means the `MOJO_PYTHON_LIBRARY` environment variable needs to be set to ue the app.

## Todo

- Fix sub directory issue.
- Remove Python dependency.
- Count memory usage of venv folder so we can display how much memory is expected to be recouped.
