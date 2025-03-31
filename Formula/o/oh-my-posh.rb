class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.10.1.tar.gz"
  sha256 "d973f558cb8e73b40e120e64720e2aef0b17619aaa2ac4525e0feee04074abea"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "271462f0ffe34ef68ea19a58ee283dc2cc54943246025ca931f1890691b8fc3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "903d802bf4184dd6e90991a8e18671031835e9592c71a7efd7d72bef987c9ec8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad6022ac3f4da43540727c89c343483ea2f7be93f04e281de24e5c1ca0f7dac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d34e7a9ee64d45d73db7155fad13454b686ed11a6e353ae06256803cef2501af"
    sha256 cellar: :any_skip_relocation, ventura:       "09d002c88517d2810cfd5b7e49fe81861f0bb042ea5ac11c4d9040b8e39f4950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3675f734b2c2088a169e7044cc3790ccaccc2fdbb343ca7fddb40b8d0962f5bf"
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
