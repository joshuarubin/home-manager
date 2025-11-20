# Repository Guidelines

## Project Structure & Module Organization
This flake-driven Home Manager repo centers on `flake.nix`, which wires nixpkgs channels, overlays, and two Darwin home configurations (`jrubin@vermithor`, `jrubin@tessarion`). Global options live in `home.nix`, while reusable feature modules sit under `modules/` (platform-specific subdirs such as `modules/aarch64-darwin` augment the shared `files.nix`, `packages.nix`, `programs.nix`, and `zsh.nix`). Dotfiles and ancillary assets referenced by modules live in `files/` (e.g., `files/zsh/`, `files/ssh/`). Custom derivations reside in `pkgs/`, and overlay logic is isolated in `overlays/` for clarity.

## Build, Test, and Development Commands
- `nix flake show` — verify exported packages, overlays, and home configurations resolve correctly.
- `nix fmt` (aliased to alejandra) — auto-format all Nix expressions; run before committing.
- `home-manager build --flake .#jrubin@vermithor` — dry-run evaluation for a host without touching the live profile; swap host names as needed.
- `home-manager switch --flake .#jrubin@vermithor` — apply changes to the active environment after builds succeed.
- `nix flake check` — run flake-level evaluations to catch regression early, especially after modifying inputs, overlays, or pkgs.

## Revision Workflow
- After each `jj git push`, immediately create the next working revision from `main` (`jj new main -m "latest updates"`) and move the `main` bookmark to it (`jj bookmark move main`) so new work piles onto a clean head.
- Keep the description as `latest updates` while the scope is fluid; once the change set is well understood, replace it with a single-line Conventional Commit summary (e.g., `fix(home): repair darwin launchd paths`).
- When I say “ready to push,” do the full loop: ensure the current revision is rebased on the pushed `main`, set the final `jj desc`, move `main` to it, `jj git push`, then respawn the new `latest updates` revision from `main`. Halt and ask for guidance if any step hits conflicts.
- After `main` is moved and pushed, rebase any other local bookmarks onto that pushed `main` revision before resuming feature work so every branch shares the same base.

## Coding Style & Naming Conventions
Use 2-space indentation, trailing commas, and lowerCamelCase attribute names consistent with the existing modules. Keep platform overrides in platform directories and shared logic in root-level modules. Format every Nix file with `nix fmt` and keep dotfiles POSIX-compliant unless clearly targeted (e.g., Zsh-specific snippets stay under `files/zsh/`).

## Testing Guidelines
Prefer `home-manager build --flake` for each touched host to ensure modules evaluate on all target systems. Run `nix flake check` before submitting to verify overlays, pkgs, and formatter outputs remain valid. When adding scripts within `files/`, include inline smoke tests or `--help` usage so reviewers can reason about behavior quickly.

## Commit & Push Guidelines
All history flows through `jj` (co-located with Git). Iterate with `jj status`, `jj log -r ::@`, and `jj commit -m "…"` while the current `latest updates` revision accumulates work. When the revision is ready, ensure the `jj desc` matches the Conventional Commit one-liner you want synced (unless it stays `latest updates`), rebase onto clean `main`, move the `main` bookmark to that revision, and `jj git push` to publish to GitHub. Include notes about affected hosts (`vermithor`, `tessarion`) in the commit description so later rebases stay obvious. No PRs are used in this repo, but mirror the same detail in push descriptions or accompanying notes if changes require manual follow-up.

## Security & Configuration Tips
Secret material such as GPG configs under `files/gnupg` should reference external key sources rather than embedding keys. Validate file permissions when touching SSH or GPG assets, and avoid committing machine-specific state or caches.
