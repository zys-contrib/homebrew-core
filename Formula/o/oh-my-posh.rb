class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.13.3.tar.gz"
  sha256 "b0c068fa0e0ae99e105284082e95027a3396c0a0f34065ec4378f048172a47d6"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d531a175564ca44c28fbd1552f3910a27280f044af9c0c564601e63b08f14f34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e72217f041c48acafec766b43d8276f7eb2316857e9cb7127a0ecf015cc62da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af95a8173cabce597e41a7c596723e807920a2f4a51ad740c1bf5f1cdc1b0024"
    sha256 cellar: :any_skip_relocation, sonoma:        "0687be5efe7e529ea7d376c14d2f844afbe9652db96c7bce86df8fbf7e36137b"
    sha256 cellar: :any_skip_relocation, ventura:       "d81d834114e2c0d79ffb0dc2c8fa23b0466b6f4697a404fbf59d8a1989068916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6b0759c6a7ad6b0f2f05db049bbeee6e87f847ea11c1fdde6984255fe661a8f"
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
