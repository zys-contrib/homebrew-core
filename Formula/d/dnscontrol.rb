class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.15.0.tar.gz"
  sha256 "8ec565cf01fcc3d1a03fce854c78aad11f5fe67e9c9c2b66b6f3b89e58850465"
  license "MIT"
  version_scheme 1

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83ec2863c1b845bd2dcdc4a9781dee4410a1e5299c57655b4b90d342cec75cb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83ec2863c1b845bd2dcdc4a9781dee4410a1e5299c57655b4b90d342cec75cb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83ec2863c1b845bd2dcdc4a9781dee4410a1e5299c57655b4b90d342cec75cb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b651bbd07aa273959493be213f2f3f3d2ca2558f758da2cabbac2b41126b3423"
    sha256 cellar: :any_skip_relocation, ventura:       "b651bbd07aa273959493be213f2f3f3d2ca2558f758da2cabbac2b41126b3423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bed0995764c41d0addb82286ee740964e78b13a6e033c99f63aa73c900083475"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dnscontrol", "shell-completion", shells: [:bash, :zsh])
  end

  def caveats
    "dnscontrol bash completion depends on the bash-completion package."
  end

  test do
    version_output = shell_output("#{bin}/dnscontrol version")
    assert_match version.to_s, version_output

    (testpath/"dnsconfig.js").write <<~JS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    JS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end
