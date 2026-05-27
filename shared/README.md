# Shared Assets

`shared/` is the future home for assets that are reused safely across multiple desktop packages.

Current policy:

- Do not force shared-asset moves if they would break existing package builds.
- Keep package install paths stable.
- Use these folders for gradual cleanup once package builds and publishing from `keskos-desktop` are stable.

Folders:

- `logos/`
- `icons/`
- `fonts/`
- `colors/`
- `style-tokens/`

Packages may eventually copy from `../../shared/...` during build, but that is intentionally not forced in the first consolidation pass.

