class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "ca726c524c9451628e602686150c8db95c1431b5428ea56284220f00ac7e4cb1"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8ee67fa9eb5eb2c281560919a2fe81412cd8bd026448bf7d85399015ebe6e512"
    sha256 cellar: :any,                 arm64_sonoma:  "29177adae99204239d592d740e5fac4e000500b20ddb0c483a8516f1036a2fc6"
    sha256 cellar: :any,                 arm64_ventura: "06176abe764cc1843e598174ed5e8222265029dbeff2b484f62a7c711d4c635d"
    sha256 cellar: :any,                 sonoma:        "e9d9551ccf71bbde40df0cba76e6aebcc5503b447cfbbf7ce08cfce5ccbc683f"
    sha256 cellar: :any,                 ventura:       "0e142f020996acf8e14f9a053ac89ee142680d8f884635211baf05f3a066a6a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c53d2052ff34f4b4f11f7ca876d743efca43bb253123df3f31a3caa05d7d77af"
  end

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
