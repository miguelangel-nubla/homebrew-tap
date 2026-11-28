class Ipv6ddns < Formula
  desc "DNS names for every device on your network, wherever its addresses move"
  homepage "https://github.com/miguelangel-nubla/ipv6ddns"
  url "https://github.com/miguelangel-nubla/ipv6ddns/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "46877e6af228604aec869c3328552a8d93c938e026519f81c0850479d18a1f24"
  license "Apache-2.0"
  head "https://github.com/miguelangel-nubla/ipv6ddns.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=homebrew -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipv6ddns"
    man1.install "packaging/ipv6ddns.1"
    pkgshare.install "cmd/ipv6ddns/example.config.yaml"

    # A configuration to begin from, which an upgrade keeps: it only discovers, and serves the
    # report to this machine alone.
    (buildpath/"config.yaml").write <<~YAML
      # ipv6ddns: the names to keep, and the DNS providers to keep them at.
      #
      # Until you add tasks, it only discovers: the report lists the hosts of the network and
      # their MAC addresses, to choose from. After a change: sudo brew services restart ipv6ddns
      #
      # An example with most keys: #{opt_pkgshare}/example.config.yaml
      # Every key: https://github.com/miguelangel-nubla/ipv6ddns/blob/main/docs/reference/configuration.md

      tasks: {}
      credentials: {}

      # The report, at http://127.0.0.1:8053, for this machine alone: it has no authentication.
      webserver:
        listen:
          - 127.0.0.1:8053

      # How much the log says: debug, info, warn or error. The log: #{var}/log/ipv6ddns.log
      log_level: info
    YAML
    # The credentials go in it: its owner's alone to read, and root's, which the service is.
    chmod 0600, "config.yaml"
    (etc/"ipv6ddns").install "config.yaml"
  end

  def caveats
    <<~EOS
      Edit #{etc}/ipv6ddns/config.yaml, and then start the service. Discovery
      listens and probes with raw sockets, so it runs as root:
        sudo brew services start ipv6ddns
    EOS
  end

  service do
    run [opt_bin/"ipv6ddns", "--config", etc/"ipv6ddns/config.yaml"]
    keep_alive true
    require_root true
    working_dir etc/"ipv6ddns"
    log_path var/"log/ipv6ddns.log"
    error_log_path var/"log/ipv6ddns.log"
  end

  test do
    assert_match "ipv6ddns #{version}", shell_output("#{bin}/ipv6ddns --version")
    assert_match "--config", shell_output("#{bin}/ipv6ddns --help 2>&1")
  end
end
