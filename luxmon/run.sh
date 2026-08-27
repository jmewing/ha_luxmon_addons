#!/usr/bin/with-contenv bashio
set -euo pipefail

VERSION=$(bashio::addon.version)
DEST=/homeassistant/custom_components/luxmon
ZIP=/tmp/luxmon.zip
STAGE=/tmp/luxmon

bashio::log.info "Installing lux-mon integration v${VERSION}..."

curl -fsSL \
    "https://github.com/jmewing/ha_luxmon/releases/download/v${VERSION}/luxmon.zip" \
    -o "${ZIP}"

rm -rf "${STAGE}"
unzip -q "${ZIP}" "custom_components/luxmon/*" -d "${STAGE}"

mkdir -p /homeassistant/custom_components
rm -rf "${DEST}"
cp -r "${STAGE}/custom_components/luxmon" "${DEST}"
rm -rf "${STAGE}" "${ZIP}"

# Persist optional connection defaults so the config flow can pre-fill them.
# The integration reads this file (if present) to seed host/port/token defaults.
HOST=$(bashio::config 'luxmon_host')
PORT=$(bashio::config 'luxmon_port')
TOKEN=$(bashio::config 'luxmon_api_token')

if [[ -n "${HOST}" || -n "${TOKEN}" ]]; then
    bashio::log.info "Writing lux-mon connection defaults to config directory..."
    cat > /homeassistant/custom_components/luxmon/.addon-defaults.json <<EOF
{
  "host": "${HOST}",
  "port": ${PORT},
  "api_token": "${TOKEN}"
}
EOF
else
    bashio::log.info "No connection defaults set; configure host/port in the Home Assistant config flow."
fi

bashio::log.info "Done. Restarting Home Assistant Core..."
bashio::core.restart
