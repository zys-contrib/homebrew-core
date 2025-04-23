class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.4.7.tar.gz"
  sha256 "d95596fefe2f795388a8a05241302142a9456681c148d4b60f13cc95dbd738df"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb179c9ee71357327e75a52d66cb32e23788d0361e4b2997bf13463d9e724b14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a9f749353042fe9aa59bf6da9b742e4604f1dd70470166451e5c1288e9d846f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3616bb8d90f92f78b1b5b94263719e075046fccc76f46de85fabe50e564dc08c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d59964c63aa82bfd34e690b8c2804f9e1c88b009a76f255137d05671647cc93f"
    sha256 cellar: :any_skip_relocation, ventura:       "ac94685ecb5a6469c6b10c247e4c0db63e53e72454944aeaf809ec4e01696a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa1bf345db5aaa448015f086cb0b1907753b2fa80c8cb15fcd8c6e4938632cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "698b9fd0501057adbcefe694c84144642950673b69e8facbb7f55ed55f4f1f03"
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
