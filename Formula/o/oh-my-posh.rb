class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.13.0.tar.gz"
  sha256 "f041fc7421193a988f90eca27d9d2b00f959e88c80bf792554f90df326d8e1f5"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbf2e337c214f58f400120a604f8f2882ff810913fa20d3c09231916175acf12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27e181adfc716137b9b28b3677d2d72d52f95b4106010bfa7170eaf857a8868a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22d43fe1140fe3a82ecbe4ac6ec043e8fb77ab99222eaa4cf97fdaca8705b6f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "5515bd8c044f5470fcdcf707b9c2944ec4866b66fb8a52912ebea06382cdad15"
    sha256 cellar: :any_skip_relocation, ventura:        "48d25f926046b70c355831cefc8598f9d69864c935741614e3ba884f94c4c912"
    sha256 cellar: :any_skip_relocation, monterey:       "d2cd5164da78ebbbb80a031417978c61feac7a82aa0a536f16a81ee4d56a5a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5150a97fa68256bd0b40f2f29972649964ff276709a06d190c7247b35d52cd8b"
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
