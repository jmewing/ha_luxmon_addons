# lux-mon

Installs the [lux-mon](https://github.com/jmewing/ha_luxmon) Home Assistant integration.

> **Note:** Home Assistant Core will be restarted after installation so the integration is loaded. How long that takes depends entirely on your hardware and how many integrations you run - a minute or so on a fast machine, but it can take longer on a Raspberry Pi or a large configuration. Start the add-on at a convenient time and let the restart finish.

## Prerequisites

A running [lux-mon](https://github.com/jmewing/lux-mon) server (REST API on port 80) that this integration can reach over the network.

## Configuration

The add-on accepts optional connection defaults that are written to the
integration's config directory and used to pre-fill the Home Assistant config
flow. Leave them blank to enter the values manually instead.

| Option | Default | Description |
|--------|---------|-------------|
| `luxmon_host` | *(empty)* | lux-mon API hostname or IP address |
| `luxmon_port` | `80` | lux-mon API port |
| `luxmon_api_token` | *(empty)* | Optional API token (if lux-mon requires auth) |

## Usage

1. Install this add-on and click **Start**.
2. Home Assistant Core will be restarted after installation. Wait for it to come back online.
3. Go to **Settings → Devices & Services → Add integration** and search for **lux-mon**.
4. Enter your lux-mon API host and port (default port 80).

## Updates

To update the integration, upgrade this add-on to the new version and start it again. It will overwrite the previous installation and restart Core.

## Removing the integration

Uninstalling this add-on does **not** remove the integration. The add-on copies the integration into your configuration directory and then stops; those files stay behind, and Home Assistant keeps loading them. To remove it:

1. Remove the lux-mon integration under **Settings → Devices & Services**.
2. Stop and uninstall this add-on.
3. Delete the `custom_components/luxmon` folder from your Home Assistant configuration directory.
4. Restart Home Assistant Core.
