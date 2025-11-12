# Repository Guidelines

## Project Structure & Module Organization
This flake-driven Home Manager repo centers on `flake.nix`, which wires nixpkgs channels, overlays, and two Darwin home configurations (`jrubin@vermithor`, `jrubin@tessarion`). Global options live in `home.nix`, while reusable feature modules sit under `modules/` (platform-specific subdirs such as `modules/aarch64-darwin` augment the shared `files.nix`, `packages.nix`, `programs.nix`, and `zsh.nix`). Dotfiles and ancillary assets referenced by modules live in `files/` (e.g., `files/zsh/`, `files/ssh/`). Custom derivations reside in `pkgs/`, and overlay logic is isolated in `overlays/` for clarity.

## Build, Test, and Development Commands
- `nix flake show` — verify exported packages, overlays, and home configurations resolve correctly.
- `nix fmt` (aliased to alejandra) — auto-format all Nix expressions; run before committing.
- `home-manager build --flake .#jrubin@vermithor` — dry-run evaluation for a host without touching the live profile; swap host names as needed.
- `home-manager switch --flake .#jrubin@vermithor` — apply changes to the active environment after builds succeed.
- `nix flake check` — run flake-level evaluations to catch regression early, especially after modifying inputs, overlays, or pkgs.

## Coding Style & Naming Conventions
Use 2-space indentation, trailing commas, and lowerCamelCase attribute names consistent with the existing modules. Keep platform overrides in platform directories and shared logic in root-level modules. Format every Nix file with `nix fmt` and keep dotfiles POSIX-compliant unless clearly targeted (e.g., Zsh-specific snippets stay under `files/zsh/`).

## Testing Guidelines
Prefer `home-manager build --flake` for each touched host to ensure modules evaluate on all target systems. Run `nix flake check` before submitting to verify overlays, pkgs, and formatter outputs remain valid. When adding scripts within `files/`, include inline smoke tests or `--help` usage so reviewers can reason about behavior quickly.

## Commit & Push Guidelines
All history flows through `jj` (co-located with Git). After you push, create a fresh revision off `main` (`jj new main`) to collect upcoming changes, then move the `main` bookmark to that revision with `jj bookmark move main -r @` and set the description to `latest updates` (or a more specific summary once scope is clear). Iterate with `jj status`, `jj log -r ::@`, and `jj commit -m "…"` while that revision accumulates work; when ready, `jj git push` publishes the bookmark to GitHub. Include notes about affected hosts (`vermithor`, `tessarion`) in the commit description so later rebases stay obvious. No PRs are used in this repo, but mirror the same detail in push descriptions or accompanying notes if changes require manual follow-up.

## Security & Configuration Tips
Secret material such as GPG configs under `files/gnupg` should reference external key sources rather than embedding keys. Validate file permissions when touching SSH or GPG assets, and avoid committing machine-specific state or caches.
