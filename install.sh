#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${GW_INSTALLER_BASE:-https://gewumind.com/downloads}"
VERSION_DEFAULT="2.3.0"

say() { printf '\n%s\n' "$*"; }
fail() { printf '\n错误：%s\n' "$*" >&2; exit 1; }

if [[ "${EUID}" -ne 0 ]]; then
  fail "安装系统服务需要 root，请执行：sudo bash install.sh"
fi

case "$(uname -s)" in
  Linux)  OS="linux" ;;
  Darwin) OS="darwin" ;;
  *) fail "当前脚本只支持 Linux 和 macOS；Windows 请下载 gw-installer-windows-amd64.exe" ;;
esac

case "$(uname -m)" in
  x86_64|amd64)  ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) fail "不支持的 CPU 架构：$(uname -m)" ;;
esac

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT
BIN="$TMPDIR/gw-installer"
URL="$BASE_URL/gw-installer-$OS-$ARCH"

say "GewuMind Boot 安装脚本"
say "平台：$OS / $ARCH"
say "下载安装器：$URL"

if command -v curl >/dev/null 2>&1; then
  curl -fL --retry 3 --connect-timeout 20 -o "$BIN" "$URL"
elif command -v wget >/dev/null 2>&1; then
  wget -O "$BIN" "$URL"
else
  fail "没有 curl 或 wget，请先安装其中一个"
fi
chmod +x "$BIN"

run_online() {
  say "进入交互式命令行安装；安装器会继续询问版本、语言、数据库和安装目录。"
  "$BIN" install
}

run_gui() {
  say "启动本地图形安装向导。"
  "$BIN" gui
}

run_local() {
  local version lang app db host port name user
  read -r -p "版本 [$VERSION_DEFAULT]: " version
  version="${version:-$VERSION_DEFAULT}"
  read -r -p "语言 [zh/en，默认 zh]: " lang
  lang="${lang:-zh}"
  read -r -p "本地应用包路径（必填，例如 ./gewumind-boot-app-2.3.0-zh-min.tar.gz）: " app
  [[ -n "$app" ]] || fail "必须选择本地应用包"
  [[ -f "$app" ]] || fail "找不到应用包：$app"
  read -r -p "本地数据库包路径（可选，应用包内含可留空）: " db
  if [[ -n "$db" && ! -f "$db" ]]; then
    fail "找不到数据库包：$db"
  fi
  read -r -p "数据库地址 [127.0.0.1]: " host
  host="${host:-127.0.0.1}"
  read -r -p "数据库端口 [3306]: " port
  port="${port:-3306}"
  read -r -p "数据库名 [gewumind-boot]: " name
  name="${name:-gewumind-boot}"
  read -r -p "数据库用户 [root]: " user
  user="${user:-root}"

  local args=(install --version "$version" --lang "$lang" --source auto
    --db-host "$host" --db-port "$port" --db-name "$name" --db-user "$user")
  [[ -n "$db" ]] && args+=(--db-package "$db")
  args+=(--app-package "$app")
  say "开始安装：版本 $version，语言 $lang"
  "$BIN" "${args[@]}"
}

run_check() {
  local host port name user
  read -r -p "数据库地址 [127.0.0.1]: " host; host="${host:-127.0.0.1}"
  read -r -p "数据库端口 [3306]: " port; port="${port:-3306}"
  read -r -p "数据库名 [gewumind-boot]: " name; name="${name:-gewumind-boot}"
  read -r -p "数据库用户 [root]: " user; user="${user:-root}"
  "$BIN" check --check-db --db-host "$host" --db-port "$port" --db-name "$name" --db-user "$user"
}

while true; do
  say "请选择操作："
  printf '%s\n' \
    "  1) 图形安装向导" \
    "  2) 交互式命令行安装（在线下载）" \
    "  3) 使用本地 app/db 包安装" \
    "  4) 仅检查环境" \
    "  5) 退出"
  read -r -p "输入序号 [1]: " choice
  choice="${choice:-1}"
  case "$choice" in
    1) run_gui; break ;;
    2) run_online; break ;;
    3) run_local; break ;;
    4) run_check; break ;;
    5) exit 0 ;;
    *) say "请输入 1-5。" ;;
  esac
done
