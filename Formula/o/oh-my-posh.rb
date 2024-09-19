class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.13.3.tar.gz"
  sha256 "b0c068fa0e0ae99e105284082e95027a3396c0a0f34065ec4378f048172a47d6"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5462e15772be10c8d5596079f0caec16b14d8ac13ea8ec05abc0431d29ce26b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10f87e1e7e99c724416c998cbe0486e2aa1d5f6686e8c4c8a4514312d153fd9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd438fb0b0a0ef71f0c78c4f39bd1e315272754819839b9c3853e31db860a951"
    sha256 cellar: :any_skip_relocation, sonoma:        "911340d1f5ab0e3b590c6748e4da9340af7cf50b36e3869cce2d1b6a755c8079"
    sha256 cellar: :any_skip_relocation, ventura:       "a44a93c88f8c5b9745a37e0aea4a6a3ba62b37028bad6a0deafe744ff5783962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb4f95662ca4143233ee2d69f935cd513e4791b826b6e7b34c837551865f941a"
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
