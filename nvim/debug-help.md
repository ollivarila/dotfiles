# Debugging

Press `F5` in a source file to pick a debug configuration and start.
The debug UI opens automatically and closes when the session ends.

## Keys

| Key          | Action                                   |
| ------------ | ---------------------------------------- |
| `F5`         | Start / continue                         |
| `S-F5`       | Stop                                     |
| `C-S-F5`     | Restart                                  |
| `F9`         | Toggle breakpoint                        |
| `F10`        | Step over                                |
| `F11`        | Step into                                |
| `S-F11`      | Step out                                 |
| `<leader>dB` | Conditional breakpoint (e.g. `x > 10`)   |
| `<leader>da` | Rust: debug with program args            |
| `<leader>dr` | Toggle REPL (evaluate expressions)       |
| `<leader>du` | Toggle debug UI                          |
| `<leader>dh` | This help (`:DebugHelp`)                 |

## TypeScript / JavaScript

No built-in configurations; add them per project in `.vscode/launch.json`
(see below). Uses js-debug, installed with Mason.

### Attach to a running server

Start the server with the inspector, listening on port 9229:

    node --inspect src/server.ts       # Node >= 22.18 runs .ts directly
    tsx watch --inspect src/server.ts

Don't use `NODE_OPTIONS=--inspect yarn dev`: yarn itself is node, grabs the
port, and the server fails with "address already in use". Put `--inspect`
in the package.json script instead.

Then `F5` -> the attach config below. `S-F5` detaches, the server keeps running.

## Custom configurations (launch.json)

`.vscode/launch.json` in nvim's cwd is read on every `F5`; each entry shows
up in the picker. Standard JSON: comments are fine, trailing commas are not.

```json
{
  "configurations": [
    {
      "type": "node",
      "request": "attach",
      "name": "Attach to server",
      "port": 9229,
      "restart": true
    },
    {
      "type": "node",
      "request": "attach",
      "name": "Attach to process (pick)",
      "processId": "${command:pickProcess}"
    },
    {
      "type": "node",
      "request": "launch",
      "name": "Run server",
      "program": "${workspaceFolder}/src/server.ts",
      "cwd": "${workspaceFolder}",
      "args": ["--port", "3000"],
      "env": { "LOG_LEVEL": "debug" },
      "envFile": "${workspaceFolder}/.env"
    },
    {
      "type": "chrome",
      "request": "launch",
      "name": "Browser",
      "url": "http://localhost:3000",
      "webRoot": "${workspaceFolder}"
    }
  ]
}
```

- `type`: `node` (Node.js) or `chrome` (browser). Other types have no adapter.
- `request`: `launch` starts the program, `attach` connects to a running one.
- Always set `cwd` on `launch` configs, otherwise node may start in the wrong
  directory and nothing runs.
- CLI args: fixed with `"args": ["add", "-v"]`, or prompted each run via
  `"args": ["${input:args}"]` + a `promptString` input (arrives as ONE arg,
  so only for single values).
- `restart: true` reconnects when a watcher (tsx watch, nodemon) restarts.
- Variables: `${workspaceFolder}`, `${file}`, `${env:NAME}`,
  `${command:pickProcess}`, `${command:pickFile}`.
- Prompts: `"inputs"` with `promptString`/`pickString`, used as `${input:id}`.
- Not supported: `compounds`, `preLaunchTask`, `serverReadyAction`,
  `node-terminal` type.

Rust doesn't use launch.json; see below.

## Rust

Handled by rustaceanvim with codelldb (installed via Mason).

- `F5` in a `.rs` buffer runs `:RustLsp debuggables`: lists the crate's
  binaries, tests and examples; the picked one is built, then launched.
  Needs rust-analyzer attached. `:RustLsp! debuggables` reruns the last one.
- `:RustLsp debug` debugs the target under the cursor (e.g. a single test).
- CLI args: `<leader>da` prompts for them (shell-style quoting works:
  `add --name "hello world" -v`), then shows the target picker.
  `:RustLsp debuggables add -v` works too, but splits on every space,
  ignoring quotes. `:RustLsp! debuggables <args>` reruns the last target.
- Use a debug build; release builds optimize away variables.

- Attaching to an already running Rust process is blocked by the kernel
  (`ptrace_scope = 1`); launch it from nvim with `F5` instead.

## Environment variables

The debugged program inherits nvim's environment and runs with the project
root as cwd. So for projects using an env script, load it before nvim:

    source ./scripts/env.sh && nvim

Values are fixed for the nvim session; restart nvim to refresh them (e.g.
expired tokens). Other options:

- A `.env` file loaded by the app itself (e.g. `dotenvy::dotenv()` in Rust,
  `node --env-file=.env` in Node). Found because cwd is the project root.
- Node launch configs: `env` / `envFile` in launch.json (see above).

## Troubleshooting

- Breakpoint shows as rejected: source maps missing or code not loaded yet.
- `:DapSetLogLevel TRACE`, then `:DapShowLog` for adapter logs.
- `:Mason` to check `js-debug-adapter` and `codelldb` are installed.
