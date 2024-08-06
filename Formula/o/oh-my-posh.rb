class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.6.0.tar.gz"
  sha256 "7c7ff26499101e01067ddc40a5be545b696f5d481f36c5e0c35c43aebd47cb71"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "252ab18f2049ede814df6cfa4f88bde4f75e78d956ab5226e7a3d783cba73518"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab69eb130e8b0b7ae38931e050f1c3a009f826b1dc3e35ac602588cb788c6fc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c1dd580e925bb6655c65e0a411c87468b1800474799d81caddfbb5bde286106"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d798216d505d73ebe69c29f0ae52c7a473bb80e9833f8c3030cfb69aa72c06d"
    sha256 cellar: :any_skip_relocation, ventura:        "06e06b3eebaa02f4805100389ac4a875f13141d9b8fdc2b19552b4e3feccf0f9"
    sha256 cellar: :any_skip_relocation, monterey:       "dd4abeb5a1d636b2d45fc79114306e519dc7040fcb3adac3692b56276701d706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e07ab13083b3526abc17a103543a6b7c1fc687ef9cf810ac9cdb44c7d993904d"
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
