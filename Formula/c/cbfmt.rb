class Cbfmt < Formula
  desc "Format codeblocks inside markdown and org documents"
  homepage "https://github.com/lukas-reineke/cbfmt"
  url "https://github.com/lukas-reineke/cbfmt/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "42973e9b1e95f4f3d7e72ef17a41333dab1e04d3d91c7930aabfc08f72c14126"
  license "MIT"

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_config = testpath/".cbfmt.toml"
    test_config.write <<~TOML
      [languages]
      rust = ["rustfmt"]
    TOML

    test_file = testpath/"test.md"
    (testpath/"test.md").write <<~MARKDOWN
      ```rust
      fn main() {
              println!("Hello, world!");
      }
      ```
    MARKDOWN

    system bin/"cbfmt", "--config", test_config, "--write", test_file

    assert_equal <<~MARKDOWN, test_file.read
      ```rust
      fn main() {
          println!("Hello, world!");
      }
      ```
    MARKDOWN

    system bin/"cbfmt", "--config", test_config, "--check", test_file

    assert_match version.to_s, shell_output("#{bin}/cbfmt --version")
  end
end
