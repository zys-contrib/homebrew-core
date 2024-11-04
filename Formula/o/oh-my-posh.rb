class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.0.3.tar.gz"
  sha256 "09dd90335507975041a59e549fc83253c6bacef9d17c9961e128585247dcb112"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a6985220574a0ddcfea8085b9f454ad4b254d0ff6550bebe16642e2243d7ebf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f120f16e7300fb46ed4150cb15baa85963223fd889e9e4fd375db9329ef5939"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72fedf1449a771972050bcf41e36be5ffd91a12e51ae6f2c39f2ad6b5a102c24"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ffa5613bc197d351c2d6ce1c759333903730430b973431052c761faa271ec7a"
    sha256 cellar: :any_skip_relocation, ventura:       "64e2b5962c1b83e378214d30dc1b0646e815e6e57cd003876fe43a5afd83806d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56c6b2d4e1cfe192aff5b3002595686f269fa18840e97c7079c23670a98d05e7"
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
