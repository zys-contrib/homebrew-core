class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/refs/tags/0.8.1.tar.gz"
  sha256 "fa0aade40a2e2f397f5f8734a0bc28391147ed6ad75c087f8ab7db7ce1e49b88"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "1850ceffe1ef0fcba2b1aac07221a9269b63a60d1bb51820ba06aed90d92393d"
    sha256 cellar: :any,                 arm64_sonoma:  "5acd3bd5f1a97a9c2e1cf24864404ddc565ed3fa88a0ff57578a73cc4a9bbb6a"
    sha256 cellar: :any,                 arm64_ventura: "883964af1f657a480c7acf478eba931dd962d440d078426d90170d14bc16fbab"
    sha256 cellar: :any,                 sonoma:        "e8059857164d2809f5c4e3ba1c785c20c4e03dd283a52d437a561dc6010d2c26"
    sha256 cellar: :any,                 ventura:       "0de5177015a9be8bda748768364b17bfbe1f2cb47e6b7d2439fe143e8c493d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "135d4a23da11bf70b86fba244b4c2efe4f7bfad83067d282fc8c8718b8ee5647"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  # curl-config on ventura builds do not report http2 feature,
  # see discussions in https://github.com/Homebrew/homebrew-core/pull/197727
  # FIXME: We should be able to use macOS curl on Ventura, but `curl-config` is broken.
  uses_from_macos "curl", since: :sonoma

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args

    bash_completion.install "completions/sheldon.bash" => "sheldon"
    zsh_completion.install "completions/sheldon.zsh" => "_sheldon"
  end

  test do
    require "utils/linkage"

    touch testpath/"plugins.toml"
    system bin/"sheldon", "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_path_exists testpath/"plugins.lock"

    libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]
    libraries << (Formula["curl"].opt_lib/shared_library("libcurl")) if OS.linux?

    libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"sheldon", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
