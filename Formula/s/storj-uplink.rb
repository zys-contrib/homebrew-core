class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.125.2.tar.gz"
  sha256 "8e3dccd6bf6f19abe92f8893741b9f1c251c6a863a82818f16f42e694b0c82f7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1eae344e3456325f33919718e207be213feb752adff6d3cb8f4346b28ed1355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1eae344e3456325f33919718e207be213feb752adff6d3cb8f4346b28ed1355"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1eae344e3456325f33919718e207be213feb752adff6d3cb8f4346b28ed1355"
    sha256 cellar: :any_skip_relocation, sonoma:        "de0cb692e3a090ec9bfb96408419773f14bd2b9e6edf881283f5cfb7c70badec"
    sha256 cellar: :any_skip_relocation, ventura:       "de0cb692e3a090ec9bfb96408419773f14bd2b9e6edf881283f5cfb7c70badec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8c2dad580f22e5edd5f8f33b1a19d1a484538959b61a0bf5137edcd5ddc4ddf"
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
