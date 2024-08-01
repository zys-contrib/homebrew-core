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
    sha256 cellar: :any,                 arm64_sonoma:   "9a14629f1d006e108d70563cf9cd7132830b5b48830ab3e750f331662c83992d"
    sha256 cellar: :any,                 arm64_ventura:  "a83573c798e4554502d8ee8b7ccf10e9d3a3c34724b7c22a18ffadd81cf5a045"
    sha256 cellar: :any,                 arm64_monterey: "2cb490f47ac6e08f060a6fe25e1b669d7d244c05370fc9b843d35a016e1d04ca"
    sha256 cellar: :any,                 sonoma:         "6742a4854829aa87bae17ce91bd82812dac0a24e1e04dabc3ee001a39ce9ed98"
    sha256 cellar: :any,                 ventura:        "eaa4441d6504f53ba9c73763eb4bc049a1696a590be3b4c2020bbab09a33de06"
    sha256 cellar: :any,                 monterey:       "d05d6ae15599390b530d1de46261772e3182b109fe19cb805753dadeea292d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1df9a8b81214753df92ab8fc088380ce2e772f826dfa39a12b2ad36285bfc7d"
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
