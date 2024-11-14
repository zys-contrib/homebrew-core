class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.5.0.tar.gz"
  sha256 "4f053e6b9ec624bcc404a33d20e8a373ae7d3a049bce313b170132dd75201c3a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edbe07bc76dac96d5f8e992ebb3c4ec835b36f337dfe5d61822a066f9cf6c88c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5737ad6bf9b5091bdbdca65980ed32f1b380022ddc6adbc05b78e11415d84440"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5f304228edde8914ba298e411f57a1766bcf0e629b457d9427b754b90888761"
    sha256 cellar: :any_skip_relocation, sonoma:        "586e0f0726c4619ff7bedecb4b5331f243a177f76afadba0da29a4f93f077533"
    sha256 cellar: :any_skip_relocation, ventura:       "9610af2acc193a39327390bee8b149fb942fd5d16e2a692c90287132b5725675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5ac1a287050d232fd995dd358fede0b22f566c8b880e217c18e36237351c129"
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
