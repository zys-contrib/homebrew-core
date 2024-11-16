class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.11.14.tar.gz"
  sha256 "dd47a325c132b961f485a6465fc2930b668187650af9f3364720c40c5898346d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "498b3bfb904a46a639075ddba4bd6b58626b821734b1c1cf0881d4cde7c07eb1"
    sha256 cellar: :any,                 arm64_sonoma:  "63fe689892320f9a73f680a6c456b39d595d3743c973f3bbb498f748e5739bce"
    sha256 cellar: :any,                 arm64_ventura: "cfb8c37704c1ef8c655dace7fb2cb407e56c0def9cb406bd08879cfd7d635dff"
    sha256 cellar: :any,                 sonoma:        "75f7b62f901d05f811f40980a0017da61c75e0643914aad3796a8c4e85710314"
    sha256 cellar: :any,                 ventura:       "46be6139b344c138cc7e9cc48698469ed14f966f9ce38de790ff47d0c7d9ef8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d29c28ce8898907b4f5aca242f8ca48c9b0a46b8b2a41337d2bd955722e73b34"
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
