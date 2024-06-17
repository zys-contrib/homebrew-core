class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v21.12.0.tar.gz"
  sha256 "da719b94d9b8bfdf55e83f8136a6294a419336eab7e0292348c1dbdaa84f921c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c84f3abc8b4935108e6d4c9e3928fc9293a0cd4d36e10bcff46a2beb42f90eb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b46a453c9d1a23d855d8b84be0021ec7bc9c86af8b1fdda96eb267c44254492"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d131449c9274441f4e86804168d74ff39262523fb9b66614c2c3f73d348c3353"
    sha256 cellar: :any_skip_relocation, sonoma:         "8486730eb5638cf3c7f6f26438edb7cb079232b92c2f6d77df309bb06374ed4b"
    sha256 cellar: :any_skip_relocation, ventura:        "53f168a049b9907e75149965a6cbd62465dab15cae7f70215f79cfc24839a841"
    sha256 cellar: :any_skip_relocation, monterey:       "854d244209279f406ccc3b4e5e0d4c1c12c90fec2b40c58841925781f2c06cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "612717b1db22da14972d84b58adff9005bb3affbe69eb31e7872770138be3bd8"
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
