FROM caddy:builder AS builder

RUN GOTOOLCHAIN=go1.24.1 xcaddy build \
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

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
