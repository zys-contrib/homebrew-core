class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/2.23.0.tar.gz"
  sha256 "fdb1c6e8e6d8baf0c4979757ecc2e8768e5a7234aeb0117002f5ced80fc60cd2"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d793a34302357e762fe4da72c1e3f1326f1168c9c0bb14fa71cc4517fb5db42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a9886822e994dcf9b1ac656510fe9fb41331726d51c7283e2908c977f8c0399"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f92f8bf30b65eacbdf5af89e3e2953a09a820f43f8a9ced1847e1661ad7da763"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a0ca3f1d1b2c41e5adf39410baa8b8522cec0d9439ed07c3b8cb3e305db829c"
    sha256 cellar: :any_skip_relocation, ventura:       "58ccff51a053773bb7e5d177f5f5bf38b0e3fcbef9433bcdf247d1320ddc39db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8283d799290df549cc6c063df5b0100625fcba7c2176ec451b84cafff8a1a105"
  end

  # `cmake` is used to build `zlib`.
  # upstream issue, https://github.com/rust-lang/libz-sys/issues/147
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "zstd"

  def install
    ENV["ZSTD_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args

    man1.install "docs/onefetch.1"
    generate_completions_from_executable(bin/"onefetch", "--generate")
  end

  test do
    system bin/"onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    (testpath/"main.rb").write "puts 'Hello, world'\n"
    system "git", "add", "main.rb"
    system "git", "commit", "-m", "First commit"
    assert_match("Ruby (100.0 %)", shell_output(bin/"onefetch").chomp)
  end
end
