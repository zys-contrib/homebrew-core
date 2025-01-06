class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.119.12.tar.gz"
  sha256 "a20b9ac2262735c1c631a35d19492aa80d70414ce9cb84b2fe25ce736f5624d6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94bb224e81b19003631eade4e60d160335156494c8120c9988ff50291aea5de9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94bb224e81b19003631eade4e60d160335156494c8120c9988ff50291aea5de9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94bb224e81b19003631eade4e60d160335156494c8120c9988ff50291aea5de9"
    sha256 cellar: :any_skip_relocation, sonoma:        "482228e86d413b87d3f4dab8eb9f198f37497c9902b354d15fe1c7db04c300f9"
    sha256 cellar: :any_skip_relocation, ventura:       "482228e86d413b87d3f4dab8eb9f198f37497c9902b354d15fe1c7db04c300f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56fe9380136b7f0f13ecff858a3bc9b07f1ad65c302c1c0acc4aec4b6993b220"
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
