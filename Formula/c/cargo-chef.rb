class CargoChef < Formula
  desc "Cargo subcommand to speed up Rust Docker builds using Docker layer caching"
  homepage "https://github.com/LukeMathWalker/cargo-chef"
  url "https://github.com/LukeMathWalker/cargo-chef/archive/refs/tags/v0.1.68.tar.gz"
  sha256 "2cb41c1f9060965c33db781fa85b5946d2cbc64125d66fd38adddb6d71b43108"
  license any_of: ["Apache-2.0", "MIT"]

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

    (testpath/"Cargo.toml").write <<~EOS
      [package]
      name = "test_project"
      version = "0.1.0"
      edition = "2021"
    EOS

    (testpath/"src/main.rs").write <<~EOS
      fn main() {
        println!("Hello BrewTestBot!");
      }
    EOS

    recipe_file = testpath/"recipe.json"
    system bin/"cargo-chef", "chef", "prepare", "--recipe-path", recipe_file
    assert_equal "Cargo.toml", JSON.parse(recipe_file.read)["skeleton"]["manifests"].first["relative_path"]

    assert_match "cargo-chef #{version}", shell_output("#{bin}/cargo-chef --version")
  end
end
