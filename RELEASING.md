# Releasing

The add-on version is **coupled** to the integration version in the
[ha_luxmon](https://github.com/jmewing/ha_luxmon) repository. The add-on's
`run.sh` downloads the integration release tagged with its own version:

```
https://github.com/jmewing/ha_luxmon/releases/download/v${VERSION}/luxmon.zip
```

## Cutting a release

1. Cut the integration release first (see `ha_luxmon/RELEASING.md`), which
   builds `luxmon.zip` and attaches it to a GitHub release tagged `vX.Y.Z`.
2. Bump the add-on version in `luxmon/config.yaml` to the same `X.Y.Z`.
3. Update `luxmon/CHANGELOG.md` with the release notes.
4. Commit and push this repo.

The add-on and integration must always share the same version, otherwise the
add-on will try to download a release that does not exist.

## Version coupling

| File | Version source |
| ---- | -------------- |
| `ha_luxmon/custom_components/luxmon/manifest.json` | integration version |
| `ha_luxmon_addons/luxmon/config.yaml` | add-on version (must match) |

Keep these in lockstep. The integration's `scripts/release.sh` can be extended
to bump the add-on version automatically (mirroring SolarAssistant's coupled
release flow).
