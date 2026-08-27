# Releasing

The add-on version is **coupled** to the integration version in the
[ha_luxmon](https://github.com/jmewing/ha_luxmon) repository. The add-on's
`run.sh` downloads the integration release tagged with its own version:

```
https://github.com/jmewing/ha_luxmon/releases/download/v${VERSION}/luxmon.zip
```

## Automatic release (default)

Both repos use GitHub Actions to auto-version on every push to `main`:

1. **`ha_luxmon`** — `.github/workflows/release.yml` bumps the version in
   `custom_components/luxmon/manifest.json` (Conventional Commits rules),
   commits, tags, builds `luxmon.zip`, and creates a GitHub release with the
   zip attached. It then fires a `repository_dispatch` event to this repo.
2. **`ha_luxmon_addons`** — `.github/workflows/release.yml` listens for that
   `integration-released` event (and also runs on push to `main`), fetches the
   latest `ha_luxmon` release tag, and bumps `luxmon/config.yaml` to match.

The add-on and integration always stay in lockstep automatically.

### Required secret

The `ha_luxmon` repo needs a **`ADDON_REPO_TOKEN`** secret (a GitHub PAT with
`repo` scope on `jmewing/ha_luxmon_addons`) so its release workflow can fire
the `repository_dispatch` event. Without it, the add-on will still sync on its
next push to `main`, but not immediately after an integration release.

## Manual release (fallback)

If you need to cut a release by hand:

1. Cut the integration release first (see `ha_luxmon/RELEASING.md`), which
   builds `luxmon.zip` and attaches it to a GitHub release tagged `vX.Y.Z`.
2. Bump the add-on version in `luxmon/config.yaml` to the same `X.Y.Z`:
   ```bash
   scripts/bump-version.sh --write
   ```
3. Update `luxmon/CHANGELOG.md` with the release notes.
4. Commit and push this repo.

## Version coupling

| File | Version source |
| ---- | -------------- |
| `ha_luxmon/custom_components/luxmon/manifest.json` | integration version |
| `ha_luxmon_addons/luxmon/config.yaml` | add-on version (must match) |

The add-on's `scripts/bump-version.sh` fetches the latest `ha_luxmon` release
tag and aligns `config.yaml` to it — it does **not** independently bump.
