# Bin Builder

This is the infrastructure behind https://minio.toast.cafe/bin/index.html
In short, it's a set of scripts that allows building various projects (and their docs) in prepared environments, as well as upload them in a structured manner.
All of the outputs here should be fully statically linked, and compressed using upx (when advantageous and available).

## Quickstart

1. Configure the upload location (modify upload.sh's `base` variable to match your local config).
2. Get a functioning copy of the abyssos/abyss:latest image (see [its repo](https://github.com/abyss-os/docker) for more details).
3. Enter the `docker` directory and run `docker.sh` to build the containers. You may use podman as well (modify the script or use the stub).
4. Optionally, place a "upx" binary in the root git directory.
5. Run `./build.sh [NAMES...]` where NAMES is the list of projects to build (read `build.sh for more details`). (it also takes a "RUNNER" env var, which can be "docker", "podman" or "shell", defaulting to "docker" - "shell" is highly experimental and not recommended)
6. Run `./upload.sh [PATTERNS...]` where PATTERNS is the list of patterns whose matches should be uploaded.
7. Run `./docs.zsh` to build the manuals - this has to be uploaded manually (since it's just the one directory). (The command I use is: `mc cp -r ./manuals/ fafnir/bin`.)
8. Run `./tinfo.zsh` to build the terminfo files - this has to be uploaded manually, like the docs. (The command I use is: `mc cp -r ./terminfo/ fafnir/bin`.)
9. Run `./clean.sh` to clean the binaries and manuals. It can also take an optional set of arguments for directories to delete. It's just a `sudo rm` wrapper so don't worry about it too much.

## Contributing

In most cases, I don't really want it.
This is here for educational purposes and so people can host their own infrastructure.
You're better off hosting your own rather than asking me to add stuff.
Though you're free to suggest projects to be added, don't expect that to actually happen.
