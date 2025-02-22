class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.11.tar.gz"
  sha256 "8a6d6dc589d6d70bd7eb95971e3c608240e1f9c938dd5b54a049977333b59f05"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a8324a7722b6db27ecde871f6cdc4ad58da0b92ff66888babb718ecd6a12d486"
    sha256 cellar: :any,                 arm64_sonoma:  "4dc2e0ad4d0c41cb440270180c5e407b0a997fe26a06020490a58380369d78e6"
    sha256 cellar: :any,                 arm64_ventura: "150d4034ae86615a91f6544785113f62b5c56b49a8aefa7317e912139856a16c"
    sha256 cellar: :any,                 sonoma:        "d3db4545c46b4d75ab28b405fbe4e5e3cdb298830a4bdfba70ea8490104c630d"
    sha256 cellar: :any,                 ventura:       "c67c131294778af280a1b26e5112bbf04e2a8e3e7ff2e50011907eb67856e5f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "177c64fb786f7273cfe5fba39f6db7c215e8d92e99608336f377aba13eca191e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https://github.com/rust-lang/git2-rs/issues/1109 to support libgit2 1.9
  depends_on "libssh2"
  depends_on "openssl@3"

  # curl-config on ventura builds do not report http2 feature,
  # this is a workaround to allow to build against system curl
  # see discussions in https://github.com/Homebrew/homebrew-core/pull/197727
  uses_from_macos "curl", since: :sonoma
  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)

    [
      Formula["libgit2@1.8"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
