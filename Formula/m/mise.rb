class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.11.24.tar.gz"
  sha256 "ef51194fed215857f0ca8cece2194e1c0d4741c8d9d61a16d2f5479a6c2f8213"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cce7ab8d62b5086c888e518169d48342ec07e30085b29a6e05c9f86d39b22e44"
    sha256 cellar: :any,                 arm64_sonoma:  "eaeb4e0e7750dc93a02b3f022af010e4fb3b1d22be5347846b7ef1437bffee08"
    sha256 cellar: :any,                 arm64_ventura: "d48fdee74138941667d696306b05ad0732d59c22022d943b4851c3779b2c2a8e"
    sha256 cellar: :any,                 sonoma:        "3675aee8ad535843c28ec769c46a921a1893d1dc9a75df71d7eaf21b49e98a9d"
    sha256 cellar: :any,                 ventura:       "57ba2a8571af2a78c77da643e4eb914c63ad3c67fa7bef44432cb3b509e727ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31919ada2421d650a85f742618c6dc8c681cc13fbf6cd0033049a342b88ecb4c"
  end

  depends_on "pkg-config" => :build
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
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    EOS
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
    system bin/"mise", "use", "node@22"
    assert_match "22", shell_output("#{bin}/mise exec -- node -v")

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
