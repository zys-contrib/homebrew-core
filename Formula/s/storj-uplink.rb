class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.123.4.tar.gz"
  sha256 "992486a41750f5aeb2057118e4d399a15c822d2710165d0f1a0234291158ba1f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0615e4479136888bc0ef47a8a1d1319723d54de64ce53497375c61293ea76da3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0615e4479136888bc0ef47a8a1d1319723d54de64ce53497375c61293ea76da3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0615e4479136888bc0ef47a8a1d1319723d54de64ce53497375c61293ea76da3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5eb789f969188f2f9696fc3075e121334c8cdd845f635768ed2a350adcbc471"
    sha256 cellar: :any_skip_relocation, ventura:       "c5eb789f969188f2f9696fc3075e121334c8cdd845f635768ed2a350adcbc471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a3201348aea689a1c451caac13d2586cf6048f7f8a31de79435d531bb477f03"
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
