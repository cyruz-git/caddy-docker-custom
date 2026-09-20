FROM caddy:builder AS builder

RUN xcaddy build \
    --with github.com/mholt/caddy-webdav \
    --with github.com/mholt/caddy-l4 \
    --with github.com/caddyserver/forwardproxy \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/greenpau/caddy-security \
    --with github.com/ggicci/caddy-jwt \
    --with github.com/hslatman/caddy-crowdsec-bouncer/http \
    --with github.com/hslatman/caddy-crowdsec-bouncer/layer4 \
    --with github.com/Javex/caddy-fail2ban \
    --with github.com/porech/caddy-maxmind-geolocation

FROM caddy:latest

# su-exec is used to drop privileges after container startup.
RUN apk add --no-cache su-exec

# Replace the stock Caddy binary with our custom build.
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# COPY replaces the binary provided by the official image, therefore
# restore the capability required to bind ports < 1024 as non-root.
RUN chmod 0755 /usr/bin/caddy \
    && setcap cap_net_bind_service=+ep /usr/bin/caddy

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Must be explicitly defined because setting ENTRYPOINT resets
# the CMD inherited from the base image.
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
