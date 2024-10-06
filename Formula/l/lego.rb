class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.19.2.tar.gz"
  sha256 "c6741f3ae0f17370b1b400ed170fd070575c55ba6bc2aa71d90738f3f0a719d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a7819002a997ba78f8b45785b2aef3f8ee7b6e903caadce273bdd229d413fd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a7819002a997ba78f8b45785b2aef3f8ee7b6e903caadce273bdd229d413fd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a7819002a997ba78f8b45785b2aef3f8ee7b6e903caadce273bdd229d413fd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ea05ee3efad7c3a28cbae4ce27256e19ff14c291d6e997b9e6ac63f78bc3349"
    sha256 cellar: :any_skip_relocation, ventura:       "3ea05ee3efad7c3a28cbae4ce27256e19ff14c291d6e997b9e6ac63f78bc3349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "758d92653ea0152439d9688e229d51b5198909a6267c29c349e75212baefd497"
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
