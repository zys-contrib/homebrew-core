class Topiary < Formula
  desc "Uniform formatter for simple languages, as part of the Tree-sitter ecosystem"
  homepage "https://topiary.tweag.io/"
  url "https://github.com/tweag/topiary/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "7c84c7f1c473609153895c8857a35925e2c0d623e60f3ee00255202c2461785a"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "topiary-cli")

    generate_completions_from_executable(bin/"topiary", "completion")
    share.install "topiary-queries/queries"
  end

  test do
    ENV["TOPIARY_LANGUAGE_DIR"] = share/"queries"

    (testpath/"test.rs").write <<~RUST
      fn main() {
        println!("Hello, world!");
      }
    RUST

    (testpath/"config.toml").write <<~TOML
      [language]
      name = "rust"
      extensions = ["rs"]
      indent = "    " # 4 spaces
    TOML

    system bin/"topiary", "format", "-C", testpath/"config.toml", testpath/"test.rs"

    assert_match <<~RUST, File.read("#{testpath}/test.rs")
      fn main() {
          println!("Hello, world!");
      }
    RUST

    assert_match version.to_s, shell_output("#{bin}/topiary --version")
  end
end
