#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="/etc/kmonad"

ensure_config_dir() {
  sudo install -d "$CONFIG_DIR"
}

config_device_path() {
  local config_file="$1"
  grep -E '^[[:space:]]*input[[:space:]]*\(device-file' "$config_file" \
    | grep -v '^[[:space:]]*;;' \
    | head -n1 \
    | sed -E 's/.*"(.*)".*/\1/'
}

install_config() {
  local config_file="$1"
  local name="$(basename "$config_file" .kbd)"
  local target="$CONFIG_DIR/$name.kbd"
  local service="kmonad@$name.service"

  sudo install -m 644 "$config_file" "$target"

  local device_path
  device_path="$(config_device_path "$config_file")"

  if [[ -n "$device_path" && -e "$device_path" ]]; then
    sudo systemctl enable "$service"
    sudo systemctl restart "$service"
  else
    sudo systemctl disable --now "$service" >/dev/null 2>&1 || true
  fi
}

main() {
  ensure_config_dir

  shopt -s nullglob
  for config in *.kbd; do
    install_config "$config"
  done
}

main "$@"
