class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.126.2.tar.gz"
  sha256 "b846f2db3c03affb2eb6666692782ad11e04f3aed1a5668956778b5d89cbd8fe"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b15cc69be569e416d5afc3ff36e73093dd5276dc25e168e3cc81c15a177a5e7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b15cc69be569e416d5afc3ff36e73093dd5276dc25e168e3cc81c15a177a5e7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b15cc69be569e416d5afc3ff36e73093dd5276dc25e168e3cc81c15a177a5e7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "17194781295521355bbab4dede34bc776b5e185ab7b0fa893610f629f74d7f3b"
    sha256 cellar: :any_skip_relocation, ventura:       "17194781295521355bbab4dede34bc776b5e185ab7b0fa893610f629f74d7f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29ff86e6fd81501e2ef505af90fad717c9bec979ecd3bcbe6f7883515196be95"
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
