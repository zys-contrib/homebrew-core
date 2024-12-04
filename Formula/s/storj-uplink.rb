class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.118.8.tar.gz"
  sha256 "75ef901c759b76e81a59919f5d170d82bfbd2c5c9a455ce9197b3125e2af7dc9"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f038fb5738c30c284660d55cc1727d58ed86313c8ecfb6343f5302f4dcbe3fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f038fb5738c30c284660d55cc1727d58ed86313c8ecfb6343f5302f4dcbe3fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f038fb5738c30c284660d55cc1727d58ed86313c8ecfb6343f5302f4dcbe3fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5199ccb1702519a535905a1c150cf4211ba2450cab0dcf6065bcb7e7db3619d"
    sha256 cellar: :any_skip_relocation, ventura:       "d5199ccb1702519a535905a1c150cf4211ba2450cab0dcf6065bcb7e7db3619d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb9cf4c9183c2f744cc1170d7b0e15c652e03d805e25eefdadba65ebaa467a59"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
