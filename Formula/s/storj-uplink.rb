class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.116.3.tar.gz"
  sha256 "0d853e9dfcc54e586ad31e9f5bd56f0edfaa21e25702e1385b6b348713b0d885"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy if/when
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0df067a933c1e1ceb27b7e66bbb971ea1075e530194cc0040a13219dca1eb119"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0df067a933c1e1ceb27b7e66bbb971ea1075e530194cc0040a13219dca1eb119"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0df067a933c1e1ceb27b7e66bbb971ea1075e530194cc0040a13219dca1eb119"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b9c361cdd0abbb1fc734f0a058fb684f9a613c9e63d1fb9b412b99162efae31"
    sha256 cellar: :any_skip_relocation, ventura:       "1b9c361cdd0abbb1fc734f0a058fb684f9a613c9e63d1fb9b412b99162efae31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f76f897cb8085a365009194490ff0ee61da842c5532012b7a5e988a1905b813f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
