# pure-javascript-legacy

> JavaScript best practices.

### 1. Prerequisites

---

- macOS or Linux on ARM64 or x86-64, as configured in `flake.nix`.
- Install [Nix](https://nix.dev/install-nix); it supplies Node and pnpm.

Run commands from the repository root. Install locked dependencies before individual tasks:

```sh
./universal-build install --frozen-lockfile
```

### 2. Build and Test

---

#### Everyday Commands

| Goal | Command |
| --- | --- |
| Compile only | `./universal-build run compile` |
| Unit tests with coverage | `./universal-build run test` |
| Type check | `./universal-build exec tsc -p tsconfig.json` |
| Lint | `./universal-build exec eslint --max-warnings 0 .` |
| All static checks | `./universal-build run check` |
| Assemble production package | `./universal-build run compile && ./universal-build run packageExecutable` |
| Full verification and packaging | `./universal-build build` |
| Remove build outputs and installed dependencies | `./universal-build clean` |

Tests run TypeScript directly and enforce 80% coverage. `check` includes types, lint, dependency boundaries, and unused code. `compile` deletes the previous compiled output and production package; `packageExecutable` requires compiled output and dependencies already in the pnpm store.

Run one test file, or one named test, without the whole-project coverage gate:

```sh
./universal-build run test src/test/samplebusinesslayer/Calculator.test.ts --coverage.enabled=false
./universal-build run test src/test/samplebusinesslayer/Calculator.test.ts -t 'throws on division by zero' --coverage.enabled=false
```

#### Outputs

- Compiled JavaScript: `build/compiled/`.
- Production package: `build/release/executable/`.
- JUnit: `build/test-results/junit.xml`.
- Coverage: `build/coverage/index.html` and `build/coverage/lcov.info`.

### 3. Development Workflows

---

#### Dependency Management

Use pnpm through the wrapper to update `package.json` and `pnpm-lock.yaml`; `-w` selects this workspace root:

```sh
./universal-build add -w <package>
./universal-build add -w -D <package>
./universal-build add -w -E <package>@<version>
./universal-build remove <package>
./universal-build update <package> --latest
```

- Refresh the lockfile: `./universal-build install --lockfile-only`.
- Trace a dependency/version conflict: `./universal-build why <package>`.
- Build and test; commit `package.json` and `pnpm-lock.yaml` together.

#### Toolchain Changes

- Node and pnpm: `chosenNode` and `chosenPnpm` in `flake.nix`. Review `@types/node` and TypeScript configuration when upgrading Node.
- Other CLI tools: the development shell's `packages` in `flake.nix`.
- Nix package set: change `inputs.nixpkgs.url`, then run `./universal-build --update-nix-flake-lockfile`. Commit `flake.nix` and `flake.lock`.

After toolchain changes, run the full build and refresh the IDE paths.

### 4. IDE Setup

---

After installing dependencies, print the pinned toolchain paths:

```sh
./universal-build --print-node-and-tsdk-paths-for-ide
```

- [IntelliJ IDEA Ultimate setup](https://app.notion.com/p/f4c0a2b7875583b79fa5015d58412fea): use the printed Node/pnpm paths for JavaScript Runtime and the TypeScript SDK path for TypeScript. Enable Automatic ESLint.
- [Visual Studio Code setup](https://app.notion.com/p/4fd0a2b787558204a6c001d0b034f698): set `js/ts.tsserver.node.path` and `js/ts.tsdk.path` to the printed Node and SDK paths; select **Use Workspace Version**.

### 5. Concepts

---

- [Nix flakes](https://nix.dev/concepts/flakes)
- [pnpm dependency management](https://pnpm.io/10.x/package_json)

### 6. Appendix

---

#### Dependency Declarations

| `package.json` field | pnpm add flag | Use |
| --- | --- | --- |
| `dependencies` | Default | Runtime dependencies |
| `devDependencies` | `-D` | Build, test, and editor tools |
| `optionalDependencies` | `-O` | Dependencies whose installation may fail |
| `peerDependencies` | `--save-peer` | Host-provided compatibility contract; also installs as a dev dependency |

`-E` saves an exact version instead of a range. See [pnpm add](https://pnpm.io/10.x/cli/add) for other dependency specifiers.

### License

---

All rights reserved. See [LICENSE](LICENSE).
