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

To change its configuration, edit it and run `sudo brew services restart ipv6ddns`. The log is `ipv6ddns.log`, in `$(brew --prefix)/var/log`.

A service that ran as root leaves files of root's, and `brew uninstall ipv6ddns` then stops at them. Stop the service, and remove them:

```bash
sudo brew services stop ipv6ddns
sudo rm -rf "$(brew --prefix)/Cellar/ipv6ddns"
```

See its [documentation](https://github.com/miguelangel-nubla/ipv6ddns/blob/main/docs/README.md).
