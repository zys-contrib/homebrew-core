class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.11.2.tar.gz"
  sha256 "33878c3732b8170e4b5163e0972d7e933c790b0bfaebf6068a90be76ca478f93"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15dcb48c67f28162a3e6b645fd5446b17f49532e82b7c2173e62f00536848f23"
    sha256 cellar: :any,                 arm64_sonoma:  "f24dc50b9bd2c694248b8d8b8494f9d459a6e62bd274072a2753d657e317b4fe"
    sha256 cellar: :any,                 arm64_ventura: "9eb45aa70903a96ef360ad4612ddb379d7a9d49934044b8483ddb17b319fb2b3"
    sha256 cellar: :any,                 sonoma:        "363d157a0f26ac19167ac78ca0db2bbe78d10f6d45ce14819e37b911ff706d61"
    sha256 cellar: :any,                 ventura:       "4684b75036fe510ce5db2939915a463ceefabfb3d1e7e5651759715f0247b098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7628eace3ed8f0fe86d39ba329d556c31534781497c4d1f7aa42ee78f342a5f9"
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
