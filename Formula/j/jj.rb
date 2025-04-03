class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "5560d7cef3bf6322aca7a9e34e61e757871da46585fcbd02661c376682d36548"
  license "Apache-2.0"
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d0634c7e5d2d58395b669e17fd6216cd1b479d053c6939758944b5773cb4379"
    sha256 cellar: :any,                 arm64_sonoma:  "d274c267c3ee8e1e7c44118f02161f2aeb6edcaea36a2624efc68710e38bccb1"
    sha256 cellar: :any,                 arm64_ventura: "c0f83bf316cd23337defe87ebd3af29c79eb8c946440e945ae47ee4b0bdbac3a"
    sha256 cellar: :any,                 sonoma:        "5f68e6206a8b6ada72b5c775a28a6fa9b5537e07932cf73d2fb4c31a1c69f6ab"
    sha256 cellar: :any,                 ventura:       "ffc4619099fdd5a445efda8e5e00afeaec487e748ee63673321829b2ed6872cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "829cf6f24da4b7d63dd5e39257552df581acac0b89fc6fc6a1f390663ff15331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff87d1f90bfbe3daf2a0566d661c73bb94d957019ca762fd02781160b23142db"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"jj", shell_parameter_format: :clap)
    system bin/"jj", "util", "install-man-pages", man
  end

  test do
    require "utils/linkage"

    touch testpath/"README.md"
    system bin/"jj", "git", "init"
    system bin/"jj", "describe", "-m", "initial commit"
    assert_match "README.md", shell_output("#{bin}/jj file list")
    assert_match "initial commit", shell_output("#{bin}/jj log")

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"jj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
