class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.23.0.tar.gz"
  sha256 "7522508894399768eb6c21d6de51faa2c60a83704a611e4c1cb419d9fbe2d63f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c562c31d2050904677a87fac0fabc3367ef86869f5f6d6f434e99bd5e54b01a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c562c31d2050904677a87fac0fabc3367ef86869f5f6d6f434e99bd5e54b01a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c562c31d2050904677a87fac0fabc3367ef86869f5f6d6f434e99bd5e54b01a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f737cb30c9c2f13fe7f0cca8d21cf0a7a1b36e0fec2ac0717ae463d229306f0e"
    sha256 cellar: :any_skip_relocation, ventura:       "f737cb30c9c2f13fe7f0cca8d21cf0a7a1b36e0fec2ac0717ae463d229306f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccc571cdc6b15bfbb9ed3a0085ddb4efdd2a051189658cbb9593660821d180f6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
