class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/codesnap-rs/codesnap"
  url "https://github.com/codesnap-rs/codesnap/archive/refs/tags/v0.12.7.tar.gz"
  sha256 "e0cbcf6734582876d139f2ee2e6c1f26dd765552e0102f5f2c1cddd9cc5b3caf"
  license "MIT"
  head "https://github.com/codesnap-rs/codesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57ae94bd2e89509e4361eb43ae744b6f800aa4fc06cdab6f60376b625ee774d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae3d83f193d4648ed80cd3423cc558153014898c0ee1e45ef8c18a031496b138"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4980f31d0c6da5982094d7b75de2123d758d0f7ae58094450781f411d4c97e6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "517b769bb4782a5876a60c31a396a614c4705b6cdda8783cd6b509dd084df3de"
    sha256 cellar: :any_skip_relocation, ventura:       "9860c76aaaba3aeacc3dfdfab0b08e142a06e800d845021335dca9bd76de6ae0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc4fe32c8a7527a273dc72cce1d8cb5a838cf3369b389bbf1f4c4f6ef90dcf0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4e42c9a85a6a9ec350ea882bd48dbb2719110d534c0a9ed23a4599a94f29e4d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cli/examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}/codesnap -f #{pkgshare}/examples/cli.sh -o cli.png")
  end
end
