class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "09b25ef2510faf258cc34a04431570ce6815ae38582ce35473906781fbae0402"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  depends_on "rust" => [:build, :test]
  depends_on "usage" => :build
  depends_on "openssl@3"
  depends_on "pkl"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"hk", "completion")
  end

  test do
    (testpath/"hk.pkl").write <<~PKL
      amends "https://hk.jdx.dev/v0/hk.pkl"
      import "https://hk.jdx.dev/v0/builtins/cargo_clippy.pkl"
      import "https://hk.jdx.dev/v0/builtins/cargo_fmt.pkl"

      `pre-commit` {
          ["cargo-clippy"] = new cargo_clippy.CargoClippy {}
          ["cargo-fmt"] = new cargo_fmt.CargoFmt {}
      }
    PKL

    system "cargo", "init", "--name=brew"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all -v 2>&1")
    assert_match(/cargo-fmt\s* ✓ done/, output)
  end
end
