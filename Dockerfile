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

RUN apk add --no-cache su-exec

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# COPY replaces the original Caddy binary, therefore restore
# the capability needed to bind privileged ports as non-root.
RUN setcap cap_net_bind_service=+ep /usr/bin/caddy

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
