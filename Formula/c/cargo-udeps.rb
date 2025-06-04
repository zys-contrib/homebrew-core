class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.56.tar.gz"
  sha256 "a93b87ca3b7819d4918436b37f216f50adef43c2247d1793e0ebd0ecd6e9dbdf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3560b35fd8924f4ec6302fa0ea7b863d6c414c3c0b3aa4e6e298492ed0ec8624"
    sha256 cellar: :any,                 arm64_sonoma:  "606e4b2328d76762bd073eeab96270944674ce07434b3fae9443559a4fe2d9a8"
    sha256 cellar: :any,                 arm64_ventura: "129f68ff4fe461ab23c956c0f3e51b67bc1b262ae7546d9c2c061ebc95a21f97"
    sha256 cellar: :any,                 sonoma:        "2da242eca94859097a7baa91d471d939e64e21b111a90b9653af0b32a5a0315a"
    sha256 cellar: :any,                 ventura:       "4a494ab4fef41d74b00be5c5d6346a46aed3c88a2c22951c7e7736e18a278bbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2530630d9bc5f7c7a08eb4c16c47c5a86ea709ace3a7db541f7482d2e0bc293e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f50c44c0c93396485ab604ebf9c953afa7a83ef222c41caa1a1d53e9dec89250"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utils/linkage"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "3"
      TOML

      output = shell_output("cargo udeps 2>&1", 101)
      # `cargo udeps` can be installed on Rust stable, but only runs with cargo with `cargo +nightly udeps`
      assert_match "error: the option `Z` is only accepted on the nightly compiler", output
    end

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-udeps", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
