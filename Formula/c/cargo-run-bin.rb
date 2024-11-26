class CargoRunBin < Formula
  desc "Build, cache, and run binaries from Cargo.toml to avoid global installs"
  homepage "https://github.com/dustinblackman/cargo-run-bin"
  url "https://github.com/dustinblackman/cargo-run-bin/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "fd492430a60ca488ad8c356f9c6389426f3fbcd59658e5b721855e171cb62841"
  license "MIT"

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "cargo-run-bin #{version}", shell_output("#{bin}/cargo-bin -V").strip

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "homebrew_test"
      version = "0.1.0"
      edition = "2021"

      [[bin]]
      name = "homebrew_test"
      path = "src/main.rs"

      [package.metadata.bin]
      cargo-nextest = { version = "0.9.57", locked = true }
    TOML

    (testpath/"src/main.rs").write <<~RUST
      fn main() {
          println!("Hello, world!");
      }
    RUST

    system "cargo", "build"
    system bin/"cargo-bin", "--install"
    system bin/"cargo-bin", "--sync-aliases"

    assert_match <<~TOML, File.read(testpath/".cargo/config.toml")
      [alias]
      nextest = ["bin", "cargo-nextest"]
    TOML

    assert_match "next-generation test runner", shell_output("cargo nextest --help")
  end
end
