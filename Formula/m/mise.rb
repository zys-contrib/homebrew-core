class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.12.9.tar.gz"
  sha256 "7369da78652d6206791d24967caaf917304fef7eeab4a42fd666badb3833080c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "93485bd452265272fe7f189c13e11022980289ff92ac5bf3e6791ff99dbce56a"
    sha256 cellar: :any,                 arm64_sonoma:  "1f387e08773023459b5ce045828a5e228efc4be0898d63027dcf3ac9b70605b2"
    sha256 cellar: :any,                 arm64_ventura: "473f55619941d62417e0871604c506207561c9d954f38c5cbf39f5af9d44ae9b"
    sha256 cellar: :any,                 sonoma:        "a0d12a12dacebc4615f01029a055f6c8880a7a6b40b553ddcc8447d99d52a920"
    sha256 cellar: :any,                 ventura:       "57717d7f2408adc4237c8af86ce016692015c4d94469d56a2dea18fe4219bb4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1f2cc72b64669b5f77c49b26493ad4f9f486b40ee6777580cf36fd8236a1bbb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"
  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "xz" # for liblzma
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"mise", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
