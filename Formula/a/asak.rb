class Asak < Formula
  desc "Cross-platform audio recording/playback CLI tool with TUI"
  homepage "https://github.com/chaosprint/asak"
  license "MIT"
  revision 1
  head "https://github.com/chaosprint/asak.git", branch: "main"

  stable do
    url "https://github.com/chaosprint/asak/archive/refs/tags/v0.3.3.tar.gz"
    sha256 "e5c7da28f29e4e1e45aa57db4c4ab94278d59bd3bdb717ede7d04f04b1f7ed36"

    # patch to add man pages and shell completions support, upstream pr ref, https://github.com/chaosprint/asak/pull/18
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/f833fa6c7880376cb5ffe90f4d154368be04517e/asak/0.3.3-clap-update.patch"
      sha256 "04e7172fd4ca7a643849077fcb6bd4baefadaa54231c06503e1946ec8ebcd811"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2795cbaf849109fa15956cad98395a3490e819de09b0e2d790b98b6b91f55069"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b49a2b7183e38d8afb462a21f0d2b3f8773e0f34cd848b234296e71de286a59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48cb2cf400c140c6e8cda9ebb5673d4163145e4faa5f4c93be4887f164e810ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f2a4f570ecee1f7bb25f79c6f85eac005afcb864cd98f14dbb235bc70e7b892"
    sha256 cellar: :any_skip_relocation, sonoma:         "abf9484dec6102a52ecfa42ff1bd6c3bffe9cdeb790d5a809498eed73cde71cc"
    sha256 cellar: :any_skip_relocation, ventura:        "7f01ddb93a0fc05e250b3f02714ff48a948846adb09d4ac4523731f1dbbfd751"
    sha256 cellar: :any_skip_relocation, monterey:       "2c0ef06f470534c2f48ee34d1d711e7647bdc05d684a3e125c0ceb182549ae9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd7c4ef4628e5e217ffdb2734748773d871890232e3183ba7a09eacfe4f1a453"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "jack"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "target/completions/asak.bash" => "asak"
    fish_completion.install "target/completions/asak.fish" => "asak"
    zsh_completion.install "target/completions/_asak" => "_asak"
    man1.install "target/man/asak.1"
  end

  test do
    output = shell_output("#{bin}/asak play")
    assert_match "No wav files found in current directory", output

    assert_match version.to_s, shell_output("#{bin}/asak --version")
  end
end
