class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.0.0.tar.gz"
  sha256 "30df0a49a76196cf1ee96d3a0ac19838810d828ceebb9268ce28c137939b5861"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33a2e7596e0b5c044050f4d1b8419c8f174ca6d5e26e6392aa52710e76314558"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cf90700992aeabe7ffbb870ad1b5f4b27f805b0c13985e614727c727985467a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88c9ebb500a9fa6949a8a106af60dd731cfe72d2b6e63b280df08a9ebed4db93"
    sha256 cellar: :any_skip_relocation, sonoma:        "3125b1696d85b9321c7b454ce68352a6e63b73158389542af5fc38ea48ff5fcb"
    sha256 cellar: :any_skip_relocation, ventura:       "abcfcb21f9eadf55cab8b7b8adb34632f28293002cc8219521cb0b5b9ae5b727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccfb33715071adf594fe9f522c318040f9f8aa39dee65da40b7fc13914b76d35"
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
    assert_match "init.#{version}.default.sh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
