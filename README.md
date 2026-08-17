# Bicep Modules

Versioned Azure Bicep modules, published as OCI artifacts to [GitHub Container
Registry](https://github.com/orgs/rioarijit-labs/packages) and consumed from any repo via
Bicep's native `br:` registry reference.

## Modules

| Module | Description |
|---|---|
| [`vnet`](modules/vnet) | Virtual Network with configurable subnets. |
| [`nsg`](modules/nsg) | Network Security Group with configurable rules. |
| [`storage-account`](modules/storage-account) | Storage Account with secure defaults and optional containers. |
| [`ai-foundry`](modules/ai-foundry) | Azure AI Foundry account with optional model deployments. |

## Consuming a module

1. Log in to GHCR (needed even for public packages, since the Bicep OCI client authenticates
   via the Docker credential store):

   ```bash
   echo "$GITHUB_TOKEN" | docker login ghcr.io -u <github-username> --password-stdin
   ```

   `GITHUB_TOKEN` needs `read:packages` scope. In a GitHub Actions workflow in this org, the
   built-in `GITHUB_TOKEN` works.

2. Reference the module by its registry path and version tag:

   ```bicep
   module vnet 'br:ghcr.io/rioarijit-labs/bicep/vnet:1.0.0' = {
     name: 'vnet-deployment'
     params: {
       name: 'vnet-prod'
       addressPrefixes: ['10.0.0.0/16']
       subnets: [
         { name: 'snet-app', addressPrefix: '10.0.0.0/24' }
       ]
     }
   }
   ```

   Optionally, define a registry alias in the consuming repo's `bicepconfig.json`:

   ```json
   {
     "moduleAliases": {
       "br": {
         "labModules": {
           "registry": "ghcr.io",
           "modulePath": "rioarijit-labs/bicep"
         }
       }
     }
   }
   ```

   which shortens the reference to `module vnet 'br/labModules:vnet:1.0.0' = { ... }`.

## Repository layout

```
modules/
  <module-name>/
    main.bicep       # the module
    README.md        # usage, parameters, outputs
    examples/
      main.bicep      # runnable example, also used by CI for lint/build/what-if
```

## Versioning and release process

Each module is versioned and released independently via a git tag of the form
`<module>/vX.Y.Z`:

```bash
git tag vnet/v1.1.0
git push origin vnet/v1.1.0
```

Pushing the tag triggers [`.github/workflows/publish.yml`](.github/workflows/publish.yml),
which lints, builds, and publishes that module to
`ghcr.io/rioarijit-labs/bicep/<module>:<version>` (and updates a `:latest` alias). Follow
[SemVer](https://semver.org/): bump the major version on breaking parameter/output changes.

Every pull request that touches `modules/**` runs
[`.github/workflows/validate.yml`](.github/workflows/validate.yml), which lints and builds only
the changed modules, then runs `az deployment group what-if` against a sandbox resource group
via OIDC federated credentials (no stored secrets).

## One-time setup for this repo

- **GHCR package visibility**: GHCR packages default to private on first publish. After the
  first `publish.yml` run for a module, go to the package's settings under
  `github.com/orgs/rioarijit-labs/packages` and set visibility to **Public** if you want it
  consumable without authentication context beyond `docker login`.
- **OIDC for what-if validation**: create an Azure AD app registration with a federated
  credential scoped to this repo (`repo:rioarijit-labs/BicepModules:pull_request`), grant it
  `Reader` (or `Contributor`, if you want what-if to fully resolve) on a sandbox resource group,
  and set repo secrets `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID` plus the
  repo variable `SANDBOX_RESOURCE_GROUP`.
