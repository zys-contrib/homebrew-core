class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.6.4.tar.gz"
  sha256 "ea8e4681dfa52a7c514f88d35a28e5456ecdc317232fc890360d6d68abd8dff0"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1418f612b9a1f76defa8ec2291f7b84aec7182ab7ee0b90e1bb7dd827cdde032"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e1273fe5705e4bdfa1205c006a3dda5650874c2c4cd4d91601f0a72f175953e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f920c7adc2030742d6c27bce3860e695827d7d4674d2288466c9c5307dc6714"
    sha256 cellar: :any_skip_relocation, sonoma:        "39b9ff953bc2d2510f80facb9e465932df9e85b1fd29ca4a66f1c3521d133c2b"
    sha256 cellar: :any_skip_relocation, ventura:       "499957f487083d336ca9b87b4a2e089e8d6f4aa4cbb0f30aebbbc189b3dd512d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f586dd85a11c351d9c5907e113a137c3acbcb38fc98a8b158b7902a4cd05a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89b5700dd2dc1ea30b4994c09dcb138d84d5f1aef9dfd1edfc5e5b1e28fcbf06"
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
