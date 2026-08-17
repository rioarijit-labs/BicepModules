# Contributing

## Adding or changing a module

1. Edit `modules/<module>/main.bicep`. Keep `metadata name`/`description`/`owner` current, and
   add a `@description(...)` to every parameter and output.
2. Update `modules/<module>/examples/main.bicep` so it still deploys cleanly with default
   parameter values (CI uses it for lint/build/what-if — it must not require external inputs).
3. Update `modules/<module>/README.md` (usage snippet, parameter table, output table).
4. Open a PR. `validate.yml` lints, builds, and what-ifs only the modules your PR touches.
5. After merge, tag a release for the module(s) you changed:

   ```bash
   git tag <module>/v<major>.<minor>.<patch>
   git push origin <module>/v<major>.<minor>.<patch>
   ```

   This triggers `publish.yml`, which publishes to
   `ghcr.io/rioarijit-labs/bicep/<module>:<version>`.

## Adding a new module

Create `modules/<new-module>/main.bicep`, `README.md`, and `examples/main.bicep` following the
existing modules as a template, then follow the steps above.

## Versioning

Semantic versioning per module, independent of other modules:

- **Patch**: bug fix, no interface change.
- **Minor**: new optional parameter or output, backward compatible.
- **Major**: removed/renamed parameter or output, changed required parameter, or any change
  that would break an existing consumer without modification.
