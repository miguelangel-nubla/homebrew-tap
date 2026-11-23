# Homebrew tap

Formulae for [Homebrew](https://brew.sh), on macOS and Linux.

## ipv6ddns

[ipv6ddns](https://github.com/miguelangel-nubla/ipv6ddns): DNS names for every device on your network, wherever its addresses move.

```bash
brew install miguelangel-nubla/tap/ipv6ddns
```

It is built from source, with Go. Edit its configuration, which the install tells the path of, and start it as a service. Discovery listens and probes with raw sockets, so the service runs as root:

```bash
sudo brew services start ipv6ddns
```

See its [documentation](https://github.com/miguelangel-nubla/ipv6ddns/blob/main/docs/README.md).
