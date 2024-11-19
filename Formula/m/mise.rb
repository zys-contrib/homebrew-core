class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.11.18.tar.gz"
  sha256 "43ad97a8276b1d57cc3934d1d8d5dfbd2ff8c7c9f948cb1a9885833ea93a7504"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4d8c3819b8cfc0629a66107aed8387610c4c8a79cffcb384cbec3b9cbc6754c0"
    sha256 cellar: :any,                 arm64_sonoma:  "03b71bf353e501ebf1c34c36f6fddd9eef0167a0ca84f8a08f9b7012ab6b703c"
    sha256 cellar: :any,                 arm64_ventura: "39b84dbe1128a289ad232345426bb49836ea145cd1d8e35ed228160b51829e15"
    sha256 cellar: :any,                 sonoma:        "9d35deaa6a6e91eca48bd171743c515624359ca66a6d41ea720d2d246a1e8f6d"
    sha256 cellar: :any,                 ventura:       "a5afc67bd30a4cd19ff1e8e9df5d73be3d6718f6cca8180dd8b200fecc771930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ba3dcb654851cf31ad1d6189b92ab9554fba7d6506843213ab329ff259558ca"
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
