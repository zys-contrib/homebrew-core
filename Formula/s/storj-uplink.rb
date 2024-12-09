class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.119.2.tar.gz"
  sha256 "550d4e1dd460d0e1830ad08a743de3da669b648f891d4edab241b997e2c0a4ef"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f69307a98bd4e0f0c7ce92024e14213166ada95d54b51943f0f2ae4422702fd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f69307a98bd4e0f0c7ce92024e14213166ada95d54b51943f0f2ae4422702fd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f69307a98bd4e0f0c7ce92024e14213166ada95d54b51943f0f2ae4422702fd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "df0e3ced74ed25c604515c3cd912931fed1b37c47df54991d6fbb952736c35b6"
    sha256 cellar: :any_skip_relocation, ventura:       "df0e3ced74ed25c604515c3cd912931fed1b37c47df54991d6fbb952736c35b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e9c4adf00eced8acb3d5a7ddb192627e68a211a90c80fc7b6d3119a563123ac"
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
