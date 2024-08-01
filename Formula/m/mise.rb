class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.8.2.tar.gz"
  sha256 "e9185434e5395ba0965c976275ca1ef6e8022c8fc87de22de0f4221f3dbecc83"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "485abc360fbd0710786cec48efaca4a5786b30abb6d617ce7c416adc8ef89347"
    sha256 cellar: :any,                 arm64_ventura:  "4d6339815ca9033a7d978e35f6f528af382df01f0dd7ed63dae3fff9c83fe0f9"
    sha256 cellar: :any,                 arm64_monterey: "775090bebe43e0fb7ac33c67985f661d481120be973a1cc489443481e3e82303"
    sha256 cellar: :any,                 sonoma:         "5b0f120e0a03fd1fe2cea357d4530ca558fe2e1b0dc0dce79372830d5d6f1eea"
    sha256 cellar: :any,                 ventura:        "aa30bd597dac0b391ed4de382424a77d13122fbdbc2c78394ce4b72bf8a6b604"
    sha256 cellar: :any,                 monterey:       "7d08274eda1eb7020c8bab94a6c4cb055b72f14eb2106e0f2fa707223c4cffa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27e3ada63b1ea90e9b7c7122994f23d45ebf13a868cd27230c612fcce3668a5c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

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
    system "#{bin}/mise", "install", "terraform@1.5.7"
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
