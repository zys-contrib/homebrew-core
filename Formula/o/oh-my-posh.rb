class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.4.0.tar.gz"
  sha256 "60a1d428afb942327d80290141cdaf32b152c98653fe3652acab1c8519b70c02"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b089f697381a2e92f787579112c336c44e4677449a7154d0c6075162146a465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64a016274dcaaec5167110c739fc6a777eaca3bf408f269dfe526ece54d86447"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fd836f08900d8efc9727eef4d3f4b2c085544e41e6294f4e35ff8dfe7e50416"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4456d9c071e6227221adc4811c2f7482325dea79a4caaf14b7aaad81a9b4344"
    sha256 cellar: :any_skip_relocation, ventura:       "6cd79aa29627db06cd0e729d983ab660b5ebe6f9d4c267613a27d605d1f7f16c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8dd8ce2fbbf8f4bdd3e49350c7009cba9383be3f8d83dcc2519579af23db376"
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
    assert_match "Oh My Posh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
