class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.0.5.tar.gz"
  sha256 "8b6f37fe745fdc4b23aae9da6b793ca4fbd06e2458c9f177e91b90eebe69d50e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "117b014d5c8a722695e079ef84055debe3300a9e92a6d41d4cf38c0ea89577ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6c3788cfc010541cb4995068d1692b53744049c84ff68b1aa31cd19562406a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60d37f7e3b871c390603007bbc0a8447b71b687e0cbf087424010671ee1725b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f1bd76260ae65766939d11c1b2fc7cf393c82579a516d5d65d5b47fdc40083c"
    sha256 cellar: :any_skip_relocation, ventura:       "fdcdeb60eb5d3e7d5479d17c6297d8651e6bf77edf6610c15efa23c06d0c369f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fba18bd3367a5e159033c7237c2ecc7a6c9f7af30e1e469dc3fd49d71512d0b"
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
