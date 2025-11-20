# Repository Guidelines

This is a flake-driven Home Manager configuration repository.

## Project Structure & Module Organization
This flake-driven Home Manager repo centers on `flake.nix`, which wires nixpkgs channels, overlays, and two Darwin home configurations (`jrubin@vermithor`, `jrubin@tessarion`). Global options live in `home.nix`, while reusable feature modules sit under `modules/` (platform-specific subdirs such as `modules/aarch64-darwin` augment the shared `files.nix`, `packages.nix`, `programs.nix`, and `zsh.nix`). Dotfiles and ancillary assets referenced by modules live in `files/` (e.g., `files/zsh/`, `files/ssh/`). Custom derivations reside in `pkgs/`, and overlay logic is isolated in `overlays/` for clarity.

## Build, Test, and Development Commands

### Quick Reference
- **Build without applying**: `home-manager build`
- **Apply changes**: `home-manager switch`
- **Format code**: `nix fmt` (uses alejandra)
- **Check flake**: `nix flake check`

### Detailed Commands
- `nix flake show` — verify exported packages, overlays, and home configurations resolve correctly.
- `nix fmt` (aliased to alejandra) — auto-format all Nix expressions; run before committing.
- `home-manager build --flake .#jrubin@vermithor` — dry-run evaluation for a host without touching the live profile; swap host names as needed.
- `home-manager switch --flake .#jrubin@vermithor` — apply changes to the active environment after builds succeed.
- `nix flake check` — run flake-level evaluations to catch regression early, especially after modifying inputs, overlays, or pkgs.

## Revision Workflow
- Start the next `latest updates` revision from `main`, move `main` to it with `jj`, and keep the `latest updates` description for soon-to-ship work.
- Before the next push, rebase `latest updates` onto `main@origin` (the remote-tracking bookmark), move the `main` bookmark to that rebased revision, and only then push; after the push lands, respawn `latest updates` from `main`.
- After `main` is moved and pushed, immediately rebase any other local branches onto that pushed `main` revision (not the new temporary `latest updates`) so they stay aligned before you resume work on them.
- When I say "ready to push" (or similar), execute the full flow interactively: (1) ensure the current revision has an accurate `jj desc`, (2) rebase it onto `main@origin`, (3) move the `main` bookmark to the current revision with `jj bookmark set main -r @`, (4) push with `jj git push -r main`, (5) rebase other bookmarks onto the pushed `main`, (6) spawn new `latest updates` from `main`. Halt and ask for guidance if any step hits conflicts.

## Coding Style & Naming Conventions

### Key Conventions
- 2-space indentation, lowerCamelCase attributes
- Use jj for all version control (co-located with Git)
- Format all Nix files before committing
- Test builds on affected hosts before pushing

### Style Details
Use 2-space indentation, trailing commas, and lowerCamelCase attribute names consistent with the existing modules. Keep platform overrides in platform directories and shared logic in root-level modules. Format every Nix file with `nix fmt` and keep dotfiles POSIX-compliant unless clearly targeted (e.g., Zsh-specific snippets stay under `files/zsh/`).

## Testing Guidelines
Prefer `home-manager build --flake` for each touched host to ensure modules evaluate on all target systems. Run `nix flake check` before submitting to verify overlays, pkgs, and formatter outputs remain valid. When adding scripts within `files/`, include inline smoke tests or `--help` usage so reviewers can reason about behavior quickly.

## Commit & Push Guidelines
- Keep every `jj desc` to a single-line Conventional Commit scope (e.g., `feat(home): ...`) that reflects the full change set in the revision; add extra detail in the body only when needed.
- **Commit descriptions must comprehensively describe ALL changes in the diff** — review every modified file and summarize all changes, not just a subset. Use bullet points in the body to enumerate changes across multiple files or subsystems.
- Create, amend, and reorder commits with `jj` so the repository's preferred DVCS remains the source of truth before exporting to Git remotes.
- Include notes about affected hosts (`vermithor`, `tessarion`) in the commit description so later rebases stay obvious.
- **NEVER** add "🤖 Generated with Claude Code" or "Co-Authored-By: Claude" lines to commit messages.

## Security & Configuration Tips
Secret material such as GPG configs under `files/gnupg` should reference external key sources rather than embedding keys. Validate file permissions when touching SSH or GPG assets, and avoid committing machine-specific state or caches.
