class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.7.2.tar.gz"
  sha256 "b601f7ae727ec4b684deb641a01c275932aee40e962334ad1995ac0e4ab0a38a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cf70495a5e00195919e59629a33a7cb50c592f4540fc24053d9be9793e6caf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05d2766fd1963671bee22aaa5046068d9b04e383009212b544cdb1f74c0d5dff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f64520ece90a8cec7ee48a7793afc6c19e587e6e06d6312a47b38723cc7e8340"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb0d8f643b4167de044a1030ab3c4dba23eec4aa672fa9b38d60a32d70f1444"
    sha256 cellar: :any_skip_relocation, ventura:       "a8e45e29e07f052089b1a89070079021cd040f2ee733ff575d9e7922ea1ec959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eee98131f208dcd55b7a12f0b8affcfef3c2dc33d6ee1590e419a06284c5d0e"
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
