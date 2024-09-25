class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.9.9.tar.gz"
  sha256 "fc368d904d92b83342032734d6548093973af7b8c5f9035473548cd745bcbff3"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "058110ac7b6475bd054b2399e0b1edd4ce4de41ac1f215845365c4b88783aac2"
    sha256 cellar: :any,                 arm64_sonoma:  "8572d7ee872ffcfc6762d6cdd4c3cba7ac1e090820eee32f91819f15f91079c4"
    sha256 cellar: :any,                 arm64_ventura: "78e541bd7c0b80842647c825407a1b0f6c4d38f1592b9f6e082f9bfdeb6c0f8f"
    sha256 cellar: :any,                 sonoma:        "c2251e6d0021d632ce2aefc76b352708c6c2b873e88fa3b932b26587eb7119a4"
    sha256 cellar: :any,                 ventura:       "1f3cdcd26b8b24d67f264ea572e9e1beb66a3d4cedfba408db5d5813e05b3740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b730e77b9707ce4b4bdaeb20f8ad138e208d2206f55829fd1054880d25531b72"
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
