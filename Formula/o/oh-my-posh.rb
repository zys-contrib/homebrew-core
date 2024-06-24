class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v21.16.2.tar.gz"
  sha256 "f26c6038a1d510ea443fbf712a364a54f1dcf1675b378544ff31b2e26f93b408"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e16e9edca713ccd73861660b3340288035b5512d0ffb26c69d2f5fa02997518"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfb63b67f23ad1bac530571972d49a27b4fb95473365adcecf4bd5d52b919537"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d9ba3bfd29eedfddd1f3035d8e9de2c4480dfb9855b7a2100508b4b2d34c616"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5e1372e35e13299e23e276a662dad9514d33e47e54a8a0ae9a4a4b9a8f38d82"
    sha256 cellar: :any_skip_relocation, ventura:        "7f00c158146362da9bd2dd1d6ac4157008530d7ce9e15d7fc0a7d2b49649a6af"
    sha256 cellar: :any_skip_relocation, monterey:       "2d633387c398037ae1fbbbf5f8689c90d6a716d1a392f730b32b962b0a69fd60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "001d442c02e9a4dceddcd965803724fdfe33cff04b385ee7b28373bd527b02e5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
