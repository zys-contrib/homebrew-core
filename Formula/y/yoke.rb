class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.13.1",
      revision: "49c863f88d390b0ba477f0b8e49f4067f96e4884"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8060c13fc787e735ff8571b224aadbdaf9a66f1840955fb2d572e463979b2c93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e08b0e5b8a5d69f7d2c1f36f74a2e765b87e7014d562a2b0c17110f3cc1eddd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2175d440a801d661429a118c99f9137634f33dd71d950e9b72f463f3891ac675"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d11a2c75195c5410df4fdb80950ab34609615f264011a0e5730c3907ed32a15"
    sha256 cellar: :any_skip_relocation, ventura:       "8de4d03eacf727e89e302eadcfb02a5646e8a9cfc02e681a583b1c4f8e6da080"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3506d8bda0e93db959ac6175c903008c1906ff8bd97c15fbfe1e0253b358cb60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb563aab57c1882115e69c4ebbc05dab8f8818b5e49100024bbb71866bbedf70"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
