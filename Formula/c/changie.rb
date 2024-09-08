class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "0f6abc7b23cc7db940519537da133b2ac049829a9c409895a2ba1078cdcb11bd"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62124bde4dee243fcc4d18770cf22b818db2d2c1e90dd9aec3ca88a29e62af5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62124bde4dee243fcc4d18770cf22b818db2d2c1e90dd9aec3ca88a29e62af5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62124bde4dee243fcc4d18770cf22b818db2d2c1e90dd9aec3ca88a29e62af5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f35a78c9b1fd44a3f61adab233d9434b6ee73cad036d5fc348cf74f100944aa9"
    sha256 cellar: :any_skip_relocation, ventura:        "f35a78c9b1fd44a3f61adab233d9434b6ee73cad036d5fc348cf74f100944aa9"
    sha256 cellar: :any_skip_relocation, monterey:       "f35a78c9b1fd44a3f61adab233d9434b6ee73cad036d5fc348cf74f100944aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7c282417afa2f9c3b63544c26f6e6df45af868b691bb2f7d241da02b0b1eb3a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"changie", "completion")
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end
