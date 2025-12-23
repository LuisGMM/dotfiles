#!/usr/bin/env bash
set -euo pipefail

notify() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send -u low "Displays" "$1"
  else
    echo "[Displays] $1"
  fi
}

INTERNAL="$(xrandr --query | awk '/^eDP.* connected/{print $1; exit}')"
EXTERNALS=($(xrandr --query | awk '!/^eDP/ && / connected/{print $1}'))

PREFERRED_EXTERNAL=""
if printf '%s\n' "${EXTERNALS[@]}" | grep -q '^HDMI-0$'; then
  PREFERRED_EXTERNAL="HDMI-0"
elif [ "${#EXTERNALS[@]}" -gt 0 ]; then
  PREFERRED_EXTERNAL="${EXTERNALS[0]}"
fi

ACTIVE=($(xrandr --listactivemonitors | awk 'NR>1 {print $NF}'))

is_active() {
  local out="$1"
  printf '%s\n' "${ACTIVE[@]}" | grep -qx "$out"
}

has_mode_rate() {
  local out="$1" mode="$2" rate="$3"
  xrandr --query | awk -v o="^$out" -v m="^\\s*$mode\\s" '
    $0 ~ o {f=1; next}
    f && $0 ~ m {print $0; exit}
  ' | grep -qE "\\b$rate(\\.\\d+)?\\b"
}

choose_external_args() {
  # Devuelve args para xrandr con la mejor tasa disponible en 1080p: 144 → 120 → auto
  local out="$1"
  if has_mode_rate "$out" "1920x1080" "144"; then
    printf -- "--mode 1920x1080 --rate 144.01 --preferred"
  elif has_mode_rate "$out" "1920x1080" "120"; then
    printf -- "--mode 1920x1080 --rate 119.88 --preferred"
  else
    # usa el modo preferido del monitor (no pisa más tarde con --auto)
    printf -- "--preferred"
  fi
}

if [ -z "${INTERNAL:-}" ]; then
  notify "No se detecta pantalla interna (eDP)."
  exit 1
fi

INT_ACTIVE=false
EXT_ACTIVE=false
if is_active "$INTERNAL"; then INT_ACTIVE=true; fi
if [ -n "${PREFERRED_EXTERNAL}" ] && is_active "$PREFERRED_EXTERNAL"; then EXT_ACTIVE=true; fi

ONLY_INTERNAL=false
ONLY_EXTERNAL=false
BOTH=false

if $INT_ACTIVE && ! $EXT_ACTIVE; then
  ONLY_INTERNAL=true
elif ! $INT_ACTIVE && $EXT_ACTIVE; then
  ONLY_EXTERNAL=true
elif $INT_ACTIVE && $EXT_ACTIVE; then
  BOTH=true
fi

if $ONLY_INTERNAL; then
  if [ -z "${PREFERRED_EXTERNAL}" ]; then
    notify "Solo interna activa y no hay monitor externo conectado."
    exit 0
  fi
  EXT_ARGS="$(choose_external_args "$PREFERRED_EXTERNAL")"
  # Enciendo externa con la tasa elegida y coloco a la derecha; mantengo interna
  xrandr --output "$INTERNAL" --auto --primary \
         --output "$PREFERRED_EXTERNAL" $EXT_ARGS --right-of "$INTERNAL"
  notify "Activado externo (${PREFERRED_EXTERNAL}) a mejor Hz junto a interna."

elif $BOTH; then
  if [ -z "${PREFERRED_EXTERNAL}" ]; then
    notify "Ambas activas pero no se identificó externa preferida."
    exit 1
  fi
  EXT_ARGS="$(choose_external_args "$PREFERRED_EXTERNAL")"
  # Apago interna; dejo externa con la tasa elegida (sin --auto posterior)
  xrandr --output "$INTERNAL" --off \
         --output "$PREFERRED_EXTERNAL" $EXT_ARGS
  notify "Solo externo (${PREFERRED_EXTERNAL}) a mejor Hz. Interna off."

elif $ONLY_EXTERNAL; then
  # Enciendo interna y apago externa (tu regla), para volver al portátil
  xrandr --output "$INTERNAL" --auto --primary \
         --output "$PREFERRED_EXTERNAL" --off
  notify "Activada interna; externo apagado."

else
  # Estado raro → fuerza solo interna
  xrandr --output "$INTERNAL" --auto --primary
  if [ -n "${PREFERRED_EXTERNAL}" ]; then
    xrandr --output "$PREFERRED_EXTERNAL" --off || true
  fi
  notify "Estado indeterminado: forzada solo interna."
fi

