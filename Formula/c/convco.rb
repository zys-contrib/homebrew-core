class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  license "MIT"
  revision 2
  head "https://github.com/convco/convco.git", branch: "master"

  stable do
    url "https://github.com/convco/convco/archive/refs/tags/v0.6.1.tar.gz"
    sha256 "ed68341e065f76f22b6d93ff3686836a812f6a031dc7ee00bed7e048b0da4294"

    # libgit2 1.9 patch, upstream pr ref, https://github.com/convco/convco/pull/299
    patch :DATA
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5e8f4af7167c711b94120c2a0dd293289b3e4a3ba78945a6fb9c5d1efd2aab2"
    sha256 cellar: :any,                 arm64_sonoma:  "65b439d389ddf9612d3d3cef18df84d60eb220530eacf121857dd27e8273ef6b"
    sha256 cellar: :any,                 arm64_ventura: "da85dd370e5714c0c13a3d9c6760d58862c84e3b7a34af4827511b241bebe555"
    sha256 cellar: :any,                 sonoma:        "c7e429b28b7d7848958beaa73bec1c06ecabfeeddfa3c568f6420d9795e99ed0"
    sha256 cellar: :any,                 ventura:       "729b6ff47aaab6e8d52f85de48a959ce5f764d9860385e63fc7b0d95236555e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "015cbd770a86d0b53e43de0721a256ed27c8326c10c76bccb2e53438ec872df0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args

    bash_completion.install "target/completions/convco.bash" => "convco"
    zsh_completion.install  "target/completions/_convco" => "_convco"
    fish_completion.install "target/completions/convco.fish" => "convco.fish"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "invalid"
    assert_match(/FAIL  \w+  first line doesn't match `<type>\[optional scope\]: <description>`  invalid\n/,
      shell_output("#{bin}/convco check", 1).lines.first)

    # Verify that we are using the libgit2 library
    linkage_with_libgit2 = (bin/"convco").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index cbdd452..4bc0524 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -366,9 +366,9 @@ checksum = "4271d37baee1b8c7e4b708028c57d816cf9d2434acb33a549475f78c181f6253"

 [[package]]
 name = "git2"
-version = "0.19.0"
+version = "0.20.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b903b73e45dc0c6c596f2d37eccece7c1c8bb6e4407b001096387c63d0d93724"
+checksum = "3fda788993cc341f69012feba8bf45c0ba4f3291fcc08e214b4d5a7332d88aff"
 dependencies = [
  "bitflags 2.4.1",
  "libc",
@@ -452,9 +452,9 @@ checksum = "d8adc4bb1803a324070e64a98ae98f38934d91957a99cfb3a43dcbc01bc56439"

 [[package]]
 name = "libgit2-sys"
-version = "0.17.0+1.8.1"
+version = "0.18.0+1.9.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "10472326a8a6477c3c20a64547b0059e4b0d086869eee31e6d7da728a8eb7224"
+checksum = "e1a117465e7e1597e8febea8bb0c410f1c7fb93b1e1cddf34363f8390367ffec"
 dependencies = [
  "cc",
  "libc",
diff --git a/Cargo.toml b/Cargo.toml
index 7b8f7e9..7edb023 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -23,7 +23,7 @@ anyhow = { version = "1.0.89", features = ["backtrace"] }
 clap = { version = "4.5.20", features = ["derive", "env"] }
 ctrlc = "3.4.5"
 dialoguer = { version = "0.11.0", features = ["fuzzy-select"] }
-git2 = { version = "0.19.0", default-features = false }
+git2 = { version = "0.20.0", default-features = false }
 handlebars = "6.1.0"
 regex = "1.11.0"
 semver = "1.0.23"
