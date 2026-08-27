# lux-mon Add-ons

Home Assistant add-on repository for the [lux-mon](https://github.com/jmewing/ha_luxmon) integration.

## Add-ons

- **lux-mon** — installs the lux-mon Home Assistant integration into `custom_components/` and restarts Home Assistant Core.

## Installation

Add this repository to your Home Assistant Supervisor:

1. Go to **Settings → Add-ons → Add-on Store**.
2. Click the three-dot menu (⋮) → **Repositories**.
3. Add `https://github.com/jmewing/ha_luxmon_addons`.
4. Find **lux-mon** in the store and install it.

## How it works

The add-on downloads the matching `luxmon.zip` release from the
[ha_luxmon](https://github.com/jmewing/ha_luxmon) repository, unpacks it into
`custom_components/luxmon`, and restarts Home Assistant Core so the integration
loads. The add-on and integration versions are coupled — see
[RELEASING.md](RELEASING.md).
