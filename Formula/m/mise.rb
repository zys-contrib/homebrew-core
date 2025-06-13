class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.6.2.tar.gz"
  sha256 "c0ac618f1bc22dd8a3ca6726e550a7f4c565533ff9077e6ce7491f6a9946b0c3"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc6fed7e90804b8d8906b180ab0d77191dded113deccc6fbf3650ba3bd2b8471"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ca66ce99ce90ba1c21f8ef8051c3594c35f1a308d49409eaf19ed0c7505ea19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ed6327248401ce65f302dbaa9725666a9c597cd3d44f8d07f04756caa57d1cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb6498e456fbefdd6e1d7681039c0d90b520cf3ab7f5d5f34b279be650424057"
    sha256 cellar: :any_skip_relocation, ventura:       "41b5d3a2c595c265d26085ccd3293f183f39d9a1a0c7bb53c525689bd81a1ace"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f3e524ad70230145cc47fc5dd6469c35257d81da59cf5d2002abcd6543f1fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a54cfb7ec636f062c37aa5a8386bd0d43ba52b9e643b6a6ac0b90b94a52faaa"
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
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
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
