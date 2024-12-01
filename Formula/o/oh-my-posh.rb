class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.11.3.tar.gz"
  sha256 "7c52689617f13ff2714bc0e9b6c0e4962efeefa820e28e358149443dcaebc44f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f082a262e9d3735e0c88a4163e889431a343ab8812527b302c17cc200593e7d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16960c629036596412b21e21f5d26fb3a777b37cdd18dc032fd0c04691904d9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c02c1cc3fdeca424f55fd345e1ada1053eabfda444ed4b156c9eac30635d95b"
    sha256 cellar: :any_skip_relocation, sonoma:        "819f01a7d221812485fc38f6aebcb01c3c05042909ebfccb9d8be55d74058fc6"
    sha256 cellar: :any_skip_relocation, ventura:       "bc570897acd9abc3c88f0ce8bc602202873093bdbde813593e8ea6284b407aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d1352955b85deb87f4c5f2c42ff0c61f9166db7e6bcfa490b16263d8e945970"
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
