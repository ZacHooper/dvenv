# Find all "venv" folders in directories below the current one and delete them
# 1. get the current directory
# 2. Traverse the directory tree and find all "venv" folders
# 3. Delete the "venv" folders

# Python 'os' module actually has a "walk" function that can be used to traverse the directory tree.
# However, we want to reimplement this in Mojo

# TODO: Handle sub folders. For what ever reason the minute you go down two layers it never seems to think that an item is a folder.
# TODO: Print the memory saved. Need to walk and stat all the files though to do that.

from pathlib import cwd, Path
from collections import DynamicVector
from python import Python


fn walk_tree(top: Path, inout venv_dirs: DynamicVector[Path]) raises:
    var ls = top.listdir()
    for x in ls:
        if x[].path == "venv":
            venv_dirs.append(top.joinpath(x[]))
            continue
        if x[] == top:
            # Can get stuck in a loop otherwise
            return
        if x[].is_dir():
            walk_tree(x[], venv_dirs)


fn fix_paths(base_dir: Path, venv_dirs: DynamicVector[Path]) -> DynamicVector[Path]:
    var full_paths = DynamicVector[Path]()
    for venv_dir in venv_dirs:
        var venv_path: String
        if base_dir not in venv_dir[].path:
            full_paths.append(base_dir.joinpath(venv_dir[]))
        else:
            full_paths.append(venv_dir[])
    return full_paths


fn main() raises:
    var base_dir = cwd()

    print("Looking for Venv directories in: " + str(base_dir))

    var ls = base_dir.listdir()

    var venv_dirs = DynamicVector[Path]()
    walk_tree(base_dir, venv_dirs)
    venv_dirs = fix_paths(base_dir, venv_dirs)

    if len(venv_dirs) == 0:
        print("No venv directories identified.")
        return

    print("The following venv directories have been identified to be deleted:")
    var memory_recovered: Int = 0
    for x in venv_dirs:
        print(x[].path)
        memory_recovered += x[].stat().st_blksize

    print(str(memory_recovered) + " bytes of memory to be returned. NOT YET ACCURATE")

    var builtins = Python.import_module("builtins")
    var input = builtins.input(
        "Are you sure you want to delete these directories? (y/N)"
    )

    while True:
        if str(input).lower() == "n":
            return
        elif str(input).lower() != "y":
            input = builtins.input("Please provide an input of 'y' or 'n': ")
        else:
            break

    var os = Python.import_module("os")
    var shutil = Python.import_module("shutil")

    for x in venv_dirs:
        var res = shutil.rmtree(x[].path)
        print("Deleted ", x[].path)
