class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.131.4.tar.gz"
  sha256 "56f5f20473d703959f2647ad3171e79ac510702e86b38aef80e37378f2e0c2ce"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b85b653d9c48e4fd9b25088602fa0ad41e6e4dc4295873ee675afbf813bcdbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b85b653d9c48e4fd9b25088602fa0ad41e6e4dc4295873ee675afbf813bcdbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b85b653d9c48e4fd9b25088602fa0ad41e6e4dc4295873ee675afbf813bcdbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb60ed101ae2229d05414fbabc9e726992ce86352f88b0863fd3747f460d7fc4"
    sha256 cellar: :any_skip_relocation, ventura:       "fb60ed101ae2229d05414fbabc9e726992ce86352f88b0863fd3747f460d7fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb198acfa8ed1e128bea3931118afc8e298e5be0cda577a4872b2cb26d55713e"
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
