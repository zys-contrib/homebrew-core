class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.129.2.tar.gz"
  sha256 "6c191aa90064a255ac6bde13ca425af75efd72ffc2c3e0f72b6bbd92190016bb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b66c38089e860f51a496138d80d2196b569a70329e6efaf47d5ab24a82b6366"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b66c38089e860f51a496138d80d2196b569a70329e6efaf47d5ab24a82b6366"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b66c38089e860f51a496138d80d2196b569a70329e6efaf47d5ab24a82b6366"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfe18af1fc4b61aed0dea015134e9f32a40558252d460014c8195e8f726fb279"
    sha256 cellar: :any_skip_relocation, ventura:       "bfe18af1fc4b61aed0dea015134e9f32a40558252d460014c8195e8f726fb279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69f6001c3ba0b424081fdb6cea84f3e71b89374cb78a048bd46f43cba80c8b45"
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
