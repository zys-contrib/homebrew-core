class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.11.10.tar.gz"
  sha256 "d72a48d790aaeb349e5511bcf1916fe40065745bcf49d5f42907074caa458c69"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8e70102cc9342d185da7166fb6f787b4ef6c08ff984df6063225d6891e7ecb97"
    sha256 cellar: :any,                 arm64_sonoma:  "130175b59277c14d623c436b86957a84b672c25e2e868203418fb37ba5f81947"
    sha256 cellar: :any,                 arm64_ventura: "86731957915a58d261a78632d4b205e8abff6e01f77bfd8f2a4cf8da965a0f81"
    sha256 cellar: :any,                 sonoma:        "9f846c626d7c5ad2ea76636a147228e283a3d2f73d3079ea5fb37c7e2c60726a"
    sha256 cellar: :any,                 ventura:       "d13b34b76645c8882d5e28c587f3edef6ae40945030a7dab8ce57823c0f0f2f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14d9580b76158cb50be452e6619d1582e200a5e193f739e03230c748a2a4d3ea"
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
