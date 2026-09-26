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
| `<leader>dr` | Toggle REPL (evaluate expressions)       |
| `<leader>du` | Toggle debug UI                          |
| `<leader>dh` | This help (`:DebugHelp`)                 |

## TypeScript / JavaScript

`F5` in a `.ts`/`.tsx`/`.js`/`.jsx` buffer offers:

- **Next.js: server**: runs `next dev` under the debugger. Breakpoints in
  server components, route handlers and API routes.
- **Next.js: client**: opens Chrome at `localhost:3000`. Start `next dev`
  (or the server config) first. Breakpoints in client components.
- **Run package.json script**: prompts for a script (default `dev`) and runs
  it with pnpm/yarn/bun/npm, based on the nearest lockfile. Use for any server
  process; child processes (tsx, nodemon, ...) are followed automatically.
- **Launch file**: runs the current file with node. `.ts` works directly
  (Node >= 22.18 strips types; no enums/namespaces).
- **Attach to process**: pick a running node process started with `--inspect`,
  e.g. `NODE_OPTIONS=--inspect yarn start`.

### launch.json

`.vscode/launch.json` in the cwd is read automatically; its configurations
show up in the `F5` picker. `node`/`chrome` types, comments and trailing
commas are supported. `node-terminal` configs are not; use the
package.json script config instead.

## Rust

Handled by rustaceanvim with codelldb (installed via Mason).

- `F5` in a `.rs` buffer runs `:RustLsp debuggables`: lists the crate's
  binaries, tests and examples; the picked one is built, then launched.
  Needs rust-analyzer attached. `:RustLsp! debuggables` reruns the last one.
- `:RustLsp debug` debugs the target under the cursor (e.g. a single test).
- Use a debug build; release builds optimize away variables.

## Troubleshooting

- Breakpoint shows as rejected: source maps missing or code not loaded yet.
- `:DapSetLogLevel TRACE`, then `:DapShowLog` for adapter logs.
- `:Mason` to check `js-debug-adapter` and `codelldb` are installed.
