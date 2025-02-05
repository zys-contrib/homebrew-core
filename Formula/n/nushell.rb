class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.102.0.tar.gz"
  sha256 "97faa3626be944d83b26c43d0b5c9e1ae14dfc55ef4465ac00fc1c64dceda7ce"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a25a1d727d750e850bc21be58a35ed017d1295dbbde66d1bf571c7e6b94b216c"
    sha256 cellar: :any,                 arm64_sonoma:  "93bb51e8020d2117712274f8970e5aed7c9091d17e87678ef9511f5cf3f8ca44"
    sha256 cellar: :any,                 arm64_ventura: "80612bc90412f28b96056e3081ea1f2bf0dd2ef515572729ca05834561287cdd"
    sha256 cellar: :any,                 sonoma:        "0aaf21248af61048b45a7d5b7d97e10f4989e7a13b12e9cf451007fc34ed4bb8"
    sha256 cellar: :any,                 ventura:       "7af7cce0e2dbba3a6c41592a0cd2f2f8f83fa7040ac8fbb2454e5609c3aabfe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad018dbb49364c9fbe462c267b7c626a47a8307068da49a3d34e36b1fc85cc48"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end
