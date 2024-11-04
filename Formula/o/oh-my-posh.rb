class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.0.4.tar.gz"
  sha256 "65eb296f419a409df9f8c9f09313f186164e3f0efa77834927a1862ea7e39f24"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "224011af860f7b6ce27b89f63cddd283e6de4100873859d1e936e0e8ee743547"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4ffe03e60ffc0048467f28ed8ddd0386f7ab7708423e02e9f37c2e421863727"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2b6288f845dccf8779e877f6801b6cb34e94b2f916f112dde682934cd43e1f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b99b77030d8fdad0b83742c4dd2b2450235f648d016a788ca0f08eda450ac74f"
    sha256 cellar: :any_skip_relocation, ventura:       "0d6d26dd5efe4e56e8aafba0ce9076c4b575e7d688fc8450e20df51ff3381472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7789fffd50624625266ae7cc0d2a134bebbb24a350a24551e9e498cff6f741fd"
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
