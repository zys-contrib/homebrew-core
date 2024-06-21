class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.25.10.tar.gz"
  sha256 "3db220c865caa9820bf2d66c0c5a5ad5a3c7be7ec91c27c623c0f62c3754ea8b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1d3d841ded4e68526e9ec2934114aa656507242731966f792970810b56484228"
    sha256 cellar: :any,                 arm64_ventura:  "7855ec1af4741ef421874dcb6db73ee553746a9be669fa6ad47c653a3e647381"
    sha256 cellar: :any,                 arm64_monterey: "fab870db9e4bd8db39c7b4ab07e9fe2fde9d662aa9faab3187327db43696438b"
    sha256 cellar: :any,                 sonoma:         "36ae8dacc2f8de46382e529b4369afe6c9e1d9fd8f4e904a7fbfecc72f4c5359"
    sha256 cellar: :any,                 ventura:        "7044f6d03b6f9a48255c83375732fe5af2bc3516043e7e4b18d8386674b2673e"
    sha256 cellar: :any,                 monterey:       "15e4cef504a31118f8ee44989f3dc2801d2be2cbc6c6d431964fd95fb2b9a23f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea1f30bcdffd549b49fd1c78c0fc5b084a23ca592a56ded8596189c539aa2235"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
