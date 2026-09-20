#!/bin/sh
set -eu

PUID="${PUID:-99}"
PGID="${PGID:-100}"
UMASK="${UMASK:-0002}"

# Validate PUID
case "$PUID" in
    ''|*[!0-9]*)
        echo "ERROR: PUID must be numeric (got: $PUID)" >&2
        exit 1
        ;;
esac

# Validate PGID
case "$PGID" in
    ''|*[!0-9]*)
        echo "ERROR: PGID must be numeric (got: $PGID)" >&2
        exit 1
        ;;
esac

# Validate UMASK: accepts e.g. 022 or 0022
case "$UMASK" in
    [0-7][0-7][0-7]|0[0-7][0-7][0-7])
        ;;
    *)
        echo "ERROR: UMASK must be a 3-/4-digit octal value (got: $UMASK)" >&2
        exit 1
        ;;
esac

umask "$UMASK"

# Defensive fallback in case the image is started without CMD/arguments.
if [ "$#" -eq 0 ]; then
    set -- caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
fi

echo "Starting Caddy as UID=${PUID} GID=${PGID} with umask ${UMASK}"

exec su-exec "${PUID}:${PGID}" "$@"
