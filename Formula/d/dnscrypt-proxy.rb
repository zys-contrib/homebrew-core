class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://github.com/DNSCrypt/dnscrypt-proxy/archive/refs/tags/2.1.7.tar.gz"
  sha256 "6394cd2d73dedca9317aeee498b6c2520b841cea042d83f398c3355a13c50f7c"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10ddf3810451fde22bd98ff87ca297f960e0c65f6a2b498aa9040584a6166588"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10ddf3810451fde22bd98ff87ca297f960e0c65f6a2b498aa9040584a6166588"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10ddf3810451fde22bd98ff87ca297f960e0c65f6a2b498aa9040584a6166588"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8ed9a0a67fd983369b4809bc11ac57aea207eb20f034f3e8d1359d6f198ddff"
    sha256 cellar: :any_skip_relocation, ventura:       "f8ed9a0a67fd983369b4809bc11ac57aea207eb20f034f3e8d1359d6f198ddff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30e4b9caa74e462f064715c057210b3d548b5e919b3fc42f0d230db569155c7e"
  end

  depends_on "go" => :build

  def install
    cd "dnscrypt-proxy" do
      system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: sbin/"dnscrypt-proxy")
      pkgshare.install Dir["example*"]
      etc.install pkgshare/"example-dnscrypt-proxy.toml" => "dnscrypt-proxy.toml"
    end
  end

  def caveats
    <<~EOS
      After starting dnscrypt-proxy, you will need to point your
      local DNS server to 127.0.0.1. You can do this by going to
      System Preferences > "Network" and clicking the "Advanced..."
      button for your interface. You will see a "DNS" tab where you
      can click "+" and enter 127.0.0.1 in the "DNS Servers" section.

      By default, dnscrypt-proxy runs on localhost (127.0.0.1), port 53,
      balancing traffic across a set of resolvers. If you would like to
      change these settings, you will have to edit the configuration file:
        #{etc}/dnscrypt-proxy.toml

      To check that dnscrypt-proxy is working correctly, open Terminal and enter the
      following command. Replace en1 with whatever network interface you're using:

        sudo tcpdump -i en1 -vvv 'port 443'

      You should see a line in the result that looks like this:

       resolver.dnscrypt.info
    EOS
  end

  service do
    run [opt_sbin/"dnscrypt-proxy", "-config", etc/"dnscrypt-proxy.toml"]
    keep_alive true
    require_root true
    process_type :background
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/dnscrypt-proxy --version")

    config = "-config #{etc}/dnscrypt-proxy.toml"
    output = shell_output("#{sbin}/dnscrypt-proxy #{config} -list 2>&1")
    assert_match "Source [public-resolvers] loaded", output
  end
end
