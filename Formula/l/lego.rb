class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.22.0.tar.gz"
  sha256 "542a06d2a6f1fce5b2987164c43ee8c6134c4a34954cc82e623a052c3cdfd91f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75fc88bcc70fd41ade218d62f372a4a69ac4cf17afa05742a8622f65119e6ee9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75fc88bcc70fd41ade218d62f372a4a69ac4cf17afa05742a8622f65119e6ee9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75fc88bcc70fd41ade218d62f372a4a69ac4cf17afa05742a8622f65119e6ee9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5352b010d1d57d80daf45baa13414ea8920c07ed4afa66e5bac3e99deea82746"
    sha256 cellar: :any_skip_relocation, ventura:       "5352b010d1d57d80daf45baa13414ea8920c07ed4afa66e5bac3e99deea82746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1b77238f94dd08c2f72287f259154cd1a50f93a3a3486834fe671fe361bd75a"
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
