class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.20.4.tar.gz"
  sha256 "ae4ec098b583ca4317765defe0e654fc54705a83f661455c30042701b7597fee"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f87c4fd6fc97735c022205c33f1704c900ff27b9399391b5ebcc084ca2a599db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f87c4fd6fc97735c022205c33f1704c900ff27b9399391b5ebcc084ca2a599db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f87c4fd6fc97735c022205c33f1704c900ff27b9399391b5ebcc084ca2a599db"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed6d94e61bb956c1f4c9ef7aa4de18f095ce90af4670f576b73391d55fb00ede"
    sha256 cellar: :any_skip_relocation, ventura:       "ed6d94e61bb956c1f4c9ef7aa4de18f095ce90af4670f576b73391d55fb00ede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03de585e44bb750d74fa9d31c5335c233f5d951104692269f3d12b7e1042951f"
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
