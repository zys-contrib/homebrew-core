class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.116.5.tar.gz"
  sha256 "58c94ffc34ad92c9b1178295983d9eb240486946bedcd9132dc85cf1dfcf3e9b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be6ef724757ca83c5d96bf7ee5fcec44aba93179bb24532885a7f7633d02c17b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be6ef724757ca83c5d96bf7ee5fcec44aba93179bb24532885a7f7633d02c17b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be6ef724757ca83c5d96bf7ee5fcec44aba93179bb24532885a7f7633d02c17b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e77e3d2e6c2a0a9723d50a038697e15e01dcc7ff76eb4912fd28807e1a756f8a"
    sha256 cellar: :any_skip_relocation, ventura:       "e77e3d2e6c2a0a9723d50a038697e15e01dcc7ff76eb4912fd28807e1a756f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f1e1baa7160cfb51857cec9f73fa885b540d574e0820fd7f13f62e43c7f9186"
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
