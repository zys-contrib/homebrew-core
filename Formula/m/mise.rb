class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.11.7.tar.gz"
  sha256 "bdcfcc4d8a746531ab397ab7b080ffb0cca6897421db8e8581b99900a1facba7"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d270cc4a2846cac4034e3c44f1fe66dfc26e3f2c6969de67a61cd527048647e9"
    sha256 cellar: :any,                 arm64_sonoma:  "d1b24256cc7e615a77e884558b7bbea8203f8dba9c5e6d45405fcbe2c3b2f476"
    sha256 cellar: :any,                 arm64_ventura: "beae2664df57917a0c8f0ec61c1d751d647a64cbf95c9c2eda1f6dcb96e8aad6"
    sha256 cellar: :any,                 sonoma:        "8b3b990726514fc23b5e3f0f00ec8e3178e2f4ae599dd280a41356513e4ce34e"
    sha256 cellar: :any,                 ventura:       "572ba9e69efe50aace68b0fd5f7268cb7eed33f583f20f7d41a945b8544639c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "816de4fd7e9027d2b68502f7c021fb5044a3eb56a43d44940e3cf1fa16ba5109"
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
    system bin/"mise", "install", "terraform@1.5.7"
    assert_match "1.5.7", shell_output("#{bin}/mise exec terraform@1.5.7 -- terraform -v")

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
