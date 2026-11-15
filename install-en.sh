#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${GW_INSTALLER_BASE:-https://gewumind.com/downloads}"
VERSION_DEFAULT="2.3.0"

say() { printf '\n%s\n' "$*"; }
fail() { printf '\nError: %s\n' "$*" >&2; exit 1; }

if [[ "${EUID}" -ne 0 ]]; then
  fail "Installing the system service requires root. Run: sudo bash install-en.sh"
fi

case "$(uname -s)" in
  Linux)  OS="linux" ;;
  Darwin) OS="darwin" ;;
  *) fail "This script supports Linux and macOS only. On Windows use gw-installer-windows-amd64.exe" ;;
esac

case "$(uname -m)" in
  x86_64|amd64)  ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) fail "Unsupported CPU architecture: $(uname -m)" ;;
esac

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT
BIN="$TMPDIR/gw-installer"
URL="$BASE_URL/gw-installer-$OS-$ARCH"

say "GewuMind Boot installer"
say "Platform: $OS / $ARCH"
say "Downloading installer: $URL"

if command -v curl >/dev/null 2>&1; then
  curl -fL --retry 3 --connect-timeout 20 -o "$BIN" "$URL"
elif command -v wget >/dev/null 2>&1; then
  wget -O "$BIN" "$URL"
else
  fail "curl or wget is required"
fi
chmod +x "$BIN"

run_online() {
  say "Starting interactive CLI install. The installer will ask for version, language, database and install directory."
  "$BIN" install
}

run_gui() {
  say "Starting the local graphical installer."
  "$BIN" gui
}

run_local() {
  local version lang app db host port name user
  read -r -p "Version [$VERSION_DEFAULT]: " version
  version="${version:-$VERSION_DEFAULT}"
  read -r -p "Language [zh/en, default zh]: " lang
  lang="${lang:-zh}"
  read -r -p "Local application package (required, e.g. ./gewumind-boot-app-2.3.0-zh-min.tar.gz): " app
  [[ -n "$app" ]] || fail "A local application package is required"
  [[ -f "$app" ]] || fail "Application package not found: $app"
  read -r -p "Local database package (optional if included in the app package): " db
  if [[ -n "$db" && ! -f "$db" ]]; then
    fail "Database package not found: $db"
  fi
  read -r -p "Database host [127.0.0.1]: " host
  host="${host:-127.0.0.1}"
  read -r -p "Database port [3306]: " port
  port="${port:-3306}"
  read -r -p "Database name [gewumind-boot]: " name
  name="${name:-gewumind-boot}"
  read -r -p "Database user [root]: " user
  user="${user:-root}"

  local args=(install --version "$version" --lang "$lang" --source auto
    --db-host "$host" --db-port "$port" --db-name "$name" --db-user "$user")
  [[ -n "$db" ]] && args+=(--db-package "$db")
  args+=(--app-package "$app")
  say "Installing version $version in language $lang"
  "$BIN" "${args[@]}"
}

run_check() {
  local host port name user
  read -r -p "Database host [127.0.0.1]: " host; host="${host:-127.0.0.1}"
  read -r -p "Database port [3306]: " port; port="${port:-3306}"
  read -r -p "Database name [gewumind-boot]: " name; name="${name:-gewumind-boot}"
  read -r -p "Database user [root]: " user; user="${user:-root}"
  "$BIN" check --check-db --db-host "$host" --db-port "$port" --db-name "$name" --db-user "$user"
}

while true; do
  say "Choose an action:"
  printf '%s\n' \
    "  1) Graphical installer" \
    "  2) Interactive CLI install (download online)" \
    "  3) Install from local app/db packages" \
    "  4) Check environment only" \
    "  5) Exit"
  read -r -p "Enter a number [1]: " choice
  choice="${choice:-1}"
  case "$choice" in
    1) run_gui; break ;;
    2) run_online; break ;;
    3) run_local; break ;;
    4) run_check; break ;;
    5) exit 0 ;;
    *) say "Enter a number from 1 to 5." ;;
  esac
done
