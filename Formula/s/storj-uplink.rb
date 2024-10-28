class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.115.5.tar.gz"
  sha256 "2d65569b6d470e1e747ed99346d8da3b9a46bbe668c8f0902b2a9aaea39e06fb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86e05dc51dcab3a0ec302d76fdf8b23592a5fa84903e792e173aa340358d1124"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86e05dc51dcab3a0ec302d76fdf8b23592a5fa84903e792e173aa340358d1124"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86e05dc51dcab3a0ec302d76fdf8b23592a5fa84903e792e173aa340358d1124"
    sha256 cellar: :any_skip_relocation, sonoma:        "71cc4da8ba01fb241f08607bf47e5daa2ca21b076a6a33ba022d2e8bae912d69"
    sha256 cellar: :any_skip_relocation, ventura:       "71cc4da8ba01fb241f08607bf47e5daa2ca21b076a6a33ba022d2e8bae912d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "836fc53387ae54d6c9e479c678f2b4d07d3ac4ee4b85255e9b538d9d8e615177"
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
