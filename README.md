# lux-mon Add-ons

Home Assistant add-on repository for the [lux-mon](https://github.com/jmewing/ha_luxmon) integration.

This add-on installs the lux-mon Home Assistant integration into your
`custom_components/` directory and restarts Home Assistant Core so it loads. It
is the recommended way to install the integration on **Home Assistant OS** and
**Supervised** installs.

## What lux-mon does

[lux-mon](https://github.com/jmewing/lux-mon) is a local (no-cloud) monitor for
LuxPower-based inverters (EG4, LuxPower, and rebrands). The Home Assistant
integration connects to the lux-mon REST API and exposes:

- Live inverter sensors (SOC, voltage, current, power, energy, temperatures, etc.)
- Energy Dashboard sensors (`pv_energy_total`, `grid_import_energy_total`, etc.)
- Controllable settings as `number`, `select`, and `switch` entities (these write directly to inverter holding registers, not just runtime settings)
- Alert states as `binary_sensor` entities
- Quick charge actions via `button` entities
- Services: `luxmon.quick_charge_start`, `luxmon.quick_charge_stop`,
  `luxmon.set_setting`, and `luxmon.load_automation_rules`

## Prerequisites

- A running [lux-mon](https://github.com/jmewing/lux-mon) server (the REST API
  on port 80) that this integration can reach over the network.
- Home Assistant OS or a Supervised install (this add-on requires Supervisor).

## Installation

1. Open Home Assistant and go to **Settings → Add-ons → Add-on Store**.
2. Click the three-dot menu (⋮) in the top-right and choose **Repositories**.
3. Add the repository URL:

   ```
   https://github.com/jmewing/ha_luxmon_addons
   ```

4. Click **Add**, then close the dialog.
5. Find **lux-mon** in the add-on store and click it.
6. Click **Install**.
7. (Optional) Open the **Configuration** tab and set your lux-mon connection
   defaults — host, port, and API token. Leave them blank to enter them in the
   Home Assistant config flow instead.
8. Click **Start**.

The add-on downloads the matching `luxmon.zip` release, installs it into
`custom_components/luxmon`, and restarts Home Assistant Core. Wait for Home
Assistant to come back online (a minute or so, depending on your hardware).

## Connecting to lux-mon

After the add-on finishes and Home Assistant restarts:

1. Go to **Settings → Devices & services → Add integration**.
2. Search for **lux-mon**.
3. Enter your lux-mon API host and port (default port **80**).

If you set connection defaults in the add-on configuration, the form is
pre-filled with those values.

## Configuration

The integration needs only the lux-mon API host and port. After setup you can
adjust the polling interval, device ID, and inverter model from the integration
options.

## Updating

To update the integration, upgrade this add-on to the new version and start it
again. It overwrites the previous installation and restarts Core.

## Removing the integration

Uninstalling this add-on does **not** remove the integration. The add-on copies
the integration into your configuration directory and then stops; those files
stay behind, and Home Assistant keeps loading them. To remove it:

1. Remove the lux-mon integration under **Settings → Devices & services**.
2. Stop and uninstall this add-on.
3. Delete the `custom_components/luxmon` folder from your Home Assistant
   configuration directory.
4. Restart Home Assistant Core.

## How it works

The add-on downloads the matching `luxmon.zip` release from the
[ha_luxmon](https://github.com/jmewing/ha_luxmon) repository, unpacks it into
`custom_components/luxmon`, and restarts Home Assistant Core. The add-on and
integration versions are coupled — see [RELEASING.md](RELEASING.md).

## License

MIT
