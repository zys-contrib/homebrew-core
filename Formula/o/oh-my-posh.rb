class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v22.3.0.tar.gz"
  sha256 "e90dfe8671c67e4dbca2a389b152dea2622e49368074d0076e332e2951a2eb8b"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd2f1364297ad556bcf9084f49365b8133ab7e18f618cc2f8bea8e1d926757d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ed77b1020dd52c0bf9f7d398043ef79e956486af6fcf4ef576b1ff62b9bc52a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "492541b14c92e2bce8a3fc3678a00ea77483bc488f0161dee0c477d504001c8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "cda4c4bc23c6b1b1fc97222b50b9b82139f5de3ab480d95eb68b62b902449614"
    sha256 cellar: :any_skip_relocation, ventura:        "758758515ac412f32b3cf169dc6ceeefbb3b83a8a9922b0137dd525ee855493a"
    sha256 cellar: :any_skip_relocation, monterey:       "071a5ac894a25eb81dc7d5ead727fd14bd71929739b80daa962bbc6408764735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f27febf1de62a844442bf492ad1f59de4391d6690927aae2254ff0b86f90131"
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
