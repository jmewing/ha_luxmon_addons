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

bashio::log.info "Done. Restarting Home Assistant Core..."
bashio::core.restart
