class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.9.12.tar.gz"
  sha256 "3e2482ce2f68ba548b83fb18625b62f796a30a9c44d8bd7584ecbfc7696ed690"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9405be1d05429bf13b3a3a70ee20fd3d3e9f37ff8c49d7368eea41166a66af8d"
    sha256 cellar: :any,                 arm64_sonoma:  "aeb41fec1e6388cf4fcda9a86b3a2d1c8fc5a2f4d8a3fa4612a2c3bdcbd2b471"
    sha256 cellar: :any,                 arm64_ventura: "4321aa0da387ed7b3dd34070d0dabe4c90ae82c318e882d1e576187bf217c9ec"
    sha256 cellar: :any,                 sonoma:        "d0040733e39ae9f6869a4b43a6d501e8522c10253eb000805bb86dbebf7c5dd7"
    sha256 cellar: :any,                 ventura:       "7de9ce2158f766b275bb1526fc36c45bcc6b4c6e0cbfc7755e6e067db9d63f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "051420b24375cc29c01e00c46c4205ec159eef8a92546af1017630f2eca130bb"
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
