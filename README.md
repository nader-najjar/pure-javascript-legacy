# pure-javascript-legacy

JavaScript best practices.

&nbsp;

## 1. Local Development Machine Prerequisites

* Install Nix as per <https://nix.dev/install-nix>
  * Nix handles all other requirements so that developer machine setup is as minimal as possible
    * Further, it does not matter what version of Nix you have - it guarantees reproducibility
  * If, after an Apple update, nix is not found on PATH, follow <https://github.com/NixOS/nix/issues/7880> and add the snippet to `~/.zshrc` instead

&nbsp;

## 2. Tips

* Run `echo "alias ub='./universal-build'" >> ~/.zshrc` then `source ~/.zshrc` to make `ub` a quick alias for `./universal-build`
* Add the Nix snippet to your `~/.zshrc` so it is never wiped by system updates (snippet: <https://github.com/NixOS/nix/issues/7880>)

&nbsp;

## 3. Main Build Tasks

### `./universal-build build`

* Installs dependencies according to the pnpm lockfile
* Checks types, lint, dependency boundaries, and unused code/dependencies
* Compiles TypeScript code into JavaScript
* Runs unit tests with code coverage thresholds enforced
* Produces a self-contained runtime under `build/release/executable`, with compiled JavaScript and production dependencies; local builds do not construct an image

### `./universal-build clean`

* Removes temporary build outputs

&nbsp;

## 4. Workflows

### Handling NPM Dependencies

* NPM dependencies should never be manually edited. Always use one of these flows to add/remove/update
  * If manual edits cause drift with the lockfile, run `./universal-build install` to regenerate the lockfile (again, this command should never have to be executed - use the below instead)
* To add a dependency:
  * `devDependencies`: `./universal-build add -D <package-name>`
  * `dependencies`: `./universal-build add <package-name>`
* To remove a dependency:
  * `devDependencies`: `./universal-build remove -D <package-name>`
  * `dependencies`: `./universal-build remove <package-name>`
* To update a dependency:
  * `devDependencies`: `./universal-build add -D <package-name>@<version>`
  * `dependencies`: `./universal-build add <package-name>@<version>`
* To update all dependencies to latest compatible versions:
  * `./universal-build update --latest`

### Adding A Toolchain Dependency

1) Search <https://search.nixos.org/packages> for the package name
2) Add the appropriate package to the package list in the `flake.nix` file
3) If the dependency is in a different channel than the current `nixpkgs` version, run the workflow for "Updating Nix `nixpkgs` Version"

### Updating Nix `nixpkgs` Version

1) Modify the version of `inputs.nixpkgs.url` in the `flake.nix` file to the desired version, according to <https://status.nixos.org>
2) Run `./universal-build --update-nix-flake-lockfile` to update the `flake.lock` lockfile
3) Commit both files to version control

### Updating Node Version

* Follow the steps in the workflow "Adding A Toolchain Dependency", using `Node` as the package name
* Update references to the node version in `package.json`
* The `tsconfig.json` may need to be updated as well

### Updating PNPM Version

* Do not update PNPM with the usual notice banner and update command
* Follow the steps in the workflow "Adding A Toolchain Dependency", using `pnpm` as the package name

&nbsp;

## 5. Output

The Dockerfile runs `Main.js`.

&nbsp;

## 6. IDE Setup

### IntelliJ IDEA Ultimate

Follow the instructions here: <https://nader-najjar.notion.site/JetBrains-IDE-Setup-Usage-Guide-d9b0a2b78755822f9d03819f5f02feb2?source=copy_link>
    * Use the command `./universal-build --print-node-and-tsdk-paths-for-ide` to get the local nix installation of the node, pnpm, and TypeScript SDK paths specified in the flake

### Visual Studio Code

Follow the instructions here: <https://nader-najjar.notion.site/Visual-Studio-Code-Setup-Usage-Guide-f4e0a2b7875583be9293817d26459034?source=copy_link>
    * Use the command `./universal-build --print-node-and-tsdk-paths-for-ide` to get the local nix installation of the node/TypeScript version specified in the flake

&nbsp;

## 7. References

* [Build and OCI Image Packaging](https://app.notion.com/p/3f90a2b787558157a5c2cf7a9b7e92cc?pvs=204)

### Nix

* Installation: <https://nix.dev/install-nix>
* Nix Versions: <https://status.nixos.org>
* Nix Package Search: <https://search.nixos.org/packages>

## License

All rights reserved. See [LICENSE](LICENSE).
