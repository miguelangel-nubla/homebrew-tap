class Ipv6disc < Formula
  desc "Finds the hosts on the local network and their addresses, over IPv6 and IPv4"
  homepage "https://github.com/miguelangel-nubla/ipv6disc"
  url "https://github.com/miguelangel-nubla/ipv6disc/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "c6f318984af0aa5134e19a77d1b81ac3b75f26789fad8c30b6b084210da5b8f2"
  license "Apache-2.0"
  head "https://github.com/miguelangel-nubla/ipv6disc.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/ipv6disc"
    # The manual page, of the versions that have one.
    man1.install "docs/ipv6disc.1" if File.exist?("docs/ipv6disc.1")
    pkgshare.install "cmd/ipv6disc/example.config.yaml"
  end

  def caveats
    <<~EOS
      Discovery listens and probes with raw sockets, so it runs as root:
        sudo ipv6disc --live
      An example of its configuration: #{opt_pkgshare}/example.config.yaml
    EOS
  end

  test do
    assert_match "ipv6disc #{version}", shell_output("#{bin}/ipv6disc --version")
    assert_match "--config", shell_output("#{bin}/ipv6disc --help 2>&1")
  end
end
