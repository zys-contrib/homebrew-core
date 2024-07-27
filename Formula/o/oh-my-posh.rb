class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.2.1.tar.gz"
  sha256 "bd2dfea8ae37e7bbeb10a8bcb60c309bc2800fe68a1126bdb506405d56398e20"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84eb5d0498d92fcca5882529bd004e0e18c2a159a6c3e839bd8e41a65238c9b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7dd2b722fa54e895cb2822bf38add538514d2585485ba70f8d6abb4cbc240c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9cb4ce117bd37a9eb7d6cef896edc2df464941fa0dbd6ef301add5741eb0577"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ad9b3ff497f4e127a5827ffd353e9210a8511fd9d6281d2a418ea535446d2a0"
    sha256 cellar: :any_skip_relocation, ventura:        "e615b8a7bb6c6abc7894188b8456796d4b1bd6b8225e4ad5280dc566261d9e32"
    sha256 cellar: :any_skip_relocation, monterey:       "5bd12930109d071c05b9f8f053d95d24709efb6ad584bd7eac6a778e164570a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dda6370153dcc2fdfedf15ec79212977323a259bcf1eb2c260d17003cfab67f"
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
