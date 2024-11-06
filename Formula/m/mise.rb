class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.11.3.tar.gz"
  sha256 "38f93f4e22e35706cd17cc156ad696b0a5e128e96b636bae6d10e1f909cbcd5a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "27499a52936eb0156da5bd21e8eb0e30d958df7f8567a9e68de9da1629f86677"
    sha256 cellar: :any,                 arm64_sonoma:  "2a2eb4d5c9221b7728d9af9d38f1090cebbd6a010886a1460a7e650d1d1d38c0"
    sha256 cellar: :any,                 arm64_ventura: "58785be19466d71a54e97a77470081f3aafe8254413880645855fcc0019d91b4"
    sha256 cellar: :any,                 sonoma:        "5cd4594e2d021d97937a3121de101a83aa4f0eb8dc6319fd4c77d63e8e539616"
    sha256 cellar: :any,                 ventura:       "a82c13cce023713da2f82e5d24ef404fe9dcd0210da19f12e54caa1a9bda86e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d79b97b7817f9fb33febd2cffad84a9b9750d4f713b05f3764f3e9180c2088e8"
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
