#!/bin/sh
set -e

PUID="${PUID:-99}"
PGID="${PGID:-100}"
UMASK="${UMASK:-0002}"

umask "$UMASK"

echo "Starting Caddy as UID=${PUID} GID=${PGID} with umask ${UMASK}"

exec su-exec "${PUID}:${PGID}" "$@"
