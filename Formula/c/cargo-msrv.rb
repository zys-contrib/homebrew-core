class CargoMsrv < Formula
  desc "Find the minimum supported Rust version (MSRV) for your project"
  homepage "https://foresterre.github.io/cargo-msrv"
  url "https://github.com/foresterre/cargo-msrv/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "555e6e41ec51dffa8a4dad8b41a05f5d669b78507396c7bea4a143a55607e608"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/foresterre/cargo-msrv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "531161c9309058f2f2995948cc1b5b6bfa5cc6f60d30a28ff22aed4033938b10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6c73128306399f448e0bc9917c46fe348ce7b6c7760db04ae4a9d24f2db4e11"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a832bc6d08b1ff5c24c03a1810a3403edf5fc2608a422636394e88e021355d13"
    sha256 cellar: :any_skip_relocation, sonoma:        "38d185972dc92f8b5beca50d059108fba8fd2784eaf9fc54dbfcbbe24ca3e150"
    sha256 cellar: :any_skip_relocation, ventura:       "d51438aacf1f8277c3bbe94c8ea891248f292ed196c5400922ea7fa00256a9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1823d9af0c541469f28e700353eaa76b1a91b57f8da5eb9b7fc8e74939d0afbf"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["NO_COLOR"] = "1"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    assert_match version.to_s, shell_output("#{bin}/cargo-msrv --version")

    # Now proceed with creating your crate and calling cargo-msrv
    (testpath/"demo-crate/src").mkpath
    (testpath/"demo-crate/src/main.rs").write "fn main() {}"
    (testpath/"demo-crate/Cargo.toml").write <<~EOS
      [package]
      name = "demo-crate"
      version = "0.1.0"
      edition = "2021"
      rust-version = "1.78"
    EOS

    cd "demo-crate" do
      output = shell_output("#{bin}/cargo-msrv msrv show --output-format human --log-target stdout 2>&1")
      assert_match "name: \"demo-crate\"", output
    end
  end
end
