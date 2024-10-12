class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.14.crate"
  sha256 "35c0d03a4d743b37e0be9dc160214f94a2450a01a1ea01d9f5b677444d53a91f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f31761400b5c05e70bd09187afb632c49f242916f9e99aef3d2774ee07b331f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a51a4e719f4515b492454c4ed8dd3d78ecfe99e913e9e457544143925fae2929"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2b54a183ee52275b0ee0ad5b5822e662076a26546fccfb17cdc029c97974ae9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a4522648076c4511315888955ebdf641bfdab42ebf7844dc5d457984e0903b6"
    sha256 cellar: :any_skip_relocation, ventura:       "2d0587b07237d276bdedb2e9b029fc4469a773946d610086e1cd3f2b1d0827c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe7b8bbc4fa5629b6df6b91381c3ebd9fe7fba4a9ab76c88d8421f625fae8db8"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_predicate testpath/"hello_world/target/llvm-cov/html/index.html", :exist?
  end
end
