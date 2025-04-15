class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.4.4.tar.gz"
  sha256 "3dcd68d05830fec5da392a99badff9133db3eb30e4b8470623df15f9b307a7f1"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9a1f612548857cbab49a7e469906f26f8a6f679d6a25f1cde46a976aa7527b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f81afd9adbdf531e6476a1940ef182fdae636b48d832c76c5b4d5d023e8eb95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9691b7e5fae6ee774ae49a7ae3257be737b92960f5ad8b527d180d87153ec940"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb7634d9349d69c87198d482435531bcdb26120145d43ec5a0d97a4bbc4ba1fa"
    sha256 cellar: :any_skip_relocation, ventura:       "88a5a3e9763fcb0b9a53e37579c7e8b80551ea7affdee1152e0c77ef204509c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cda4e7536888bc6fe847584e77d73db590758cb93baf9a2f43e9e5040a8ac4f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "833d229e0dc260bf7cfa92c392fe6d736ecbaf47af2c819d460d9fe2d0293502"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    generate_completions_from_executable(bin/"mise", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end
