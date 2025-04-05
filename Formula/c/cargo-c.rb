class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/refs/tags/v0.10.11.tar.gz"
  sha256 "8a6d6dc589d6d70bd7eb95971e3c608240e1f9c938dd5b54a049977333b59f05"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "298df64a0e6a0dc44feb6e6f187ee495a64091c2d7d195a7ac2030296a38c7e5"
    sha256 cellar: :any,                 arm64_sonoma:  "15b1aa983ae12abeb6dc7ba2a7aeae970d084e1bcf77d29dcf7fc13edc1e9210"
    sha256 cellar: :any,                 arm64_ventura: "98619f3def2143892c25e9984be916a898565ad813dd587d3af907065c657afb"
    sha256 cellar: :any,                 sonoma:        "6053926d4acca21c203de290071319528f6dd15ac42c853a789907d6a5dfdfac"
    sha256 cellar: :any,                 ventura:       "9e401453b90ff4daee3a67da086f94b1bdf928a61a4ab5bd3b23643946bf2b19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dbe0a6f7c5f845845753b643a2dbafe4ccdbe597155891256996b18dcb3dced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5c4fa68eb6e3bf658bfdbd90a0606b8d392e6fbe56b3e8004a9655bc432568c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  # curl-config on ventura builds do not report http2 feature,
  # this is a workaround to allow to build against system curl
  # see discussions in https://github.com/Homebrew/homebrew-core/pull/197727
  uses_from_macos "curl", since: :sonoma
  uses_from_macos "zlib"

  # bump cargo to 0.87
  patch do
    url "https://github.com/lu-zero/cargo-c/commit/8c5b7af3d6edb6d99f7bffcc94adf550cfee65b3.patch?full_index=1"
    sha256 "a9938fae68b87a65a6d64b3e6a4b644ed543fb572cd9385321bb91deb3d6c5a2"
  end

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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-cbuild", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
