class TmuxSessionizer < Formula
  desc "Tool for opening git repositories as tmux sessions"
  homepage "https://github.com/jrmoulton/tmux-sessionizer/"
  url "https://github.com/jrmoulton/tmux-sessionizer/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "9dfbe99a3c1fe7f48be0c1ab9056e49f36c4f85d023e24f874254f6791a9894e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a48d496c5d45174650050b9051d9374ffa8caa8a902043f6c6af1a4b6a621a1"
    sha256 cellar: :any,                 arm64_sonoma:  "3a5dc714bb698d7bdbb9d9f12aa2e3933133c56dbd952c1670e3aa71bb5c795d"
    sha256 cellar: :any,                 arm64_ventura: "f1398e4d07cf55654b9407247e0e94085217c805872d13c9397e65519368514e"
    sha256 cellar: :any,                 sonoma:        "68fe12ee6d3d796693bc075d62b60d2c560807ef6b742c81c00331652da89aec"
    sha256 cellar: :any,                 ventura:       "3d721d35b405643ca3a91db9a076d3628c7babb14cd9866da2312779e3307108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bf1f035b63c8411b1dbd38c95f92309d65bf4858b00bd633843f558348762c4"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"tms", "--generate", base_name: "tms")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Configuration has been stored", shell_output("#{bin}/tms config -p /dev/null")
    assert_match version.to_s, shell_output("#{bin}/tms --version")

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"tms", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
