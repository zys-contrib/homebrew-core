class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.113.4.tar.gz"
  sha256 "5e99aadeaed394a3c0779642e2ea299ee5a00a4150b0940669d8dfbed8951d88"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c886e43082d1fa67d9982957aa9d1fd0e4c73ed44dd731fc3464269f6715c115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c886e43082d1fa67d9982957aa9d1fd0e4c73ed44dd731fc3464269f6715c115"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c886e43082d1fa67d9982957aa9d1fd0e4c73ed44dd731fc3464269f6715c115"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9ccdd7e309249d059fb0ec195a237d43be8b8427dda5434fdb9bfc65ba4e3f8"
    sha256 cellar: :any_skip_relocation, ventura:       "c9ccdd7e309249d059fb0ec195a237d43be8b8427dda5434fdb9bfc65ba4e3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a93b6bb228f647e0892d824d948ea6a70340ff5c2971b16653e59920e10765d"
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
