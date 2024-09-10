class CouchbaseShell < Formula
  desc "Modern and fun shell for Couchbase Server and Capella"
  homepage "https://couchbase.sh"
  url "https://github.com/couchbaselabs/couchbase-shell/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "404c704f5816c3abd26d460ecbd2e049e45170854948a7219cd9ec41a6fb753c"
  license "Apache-2.0"
  head "https://github.com/couchbaselabs/couchbase-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25b370cd8dbc1c5df81496309a679c713820cbbf34806b7ea56ac17174edb52b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "311bd08f0e1124ec4bcb6b10c4b0837cc153678ed436e7d1c876ea447c5ddd0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "332d09a84990ce0176557353b842d7ecdcfb3279b90eee9f6742be3c87eaa910"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de39e28bff9b2e2d1cb5c2b54e10ee4bb1646fa19ea0ab3feef5729ba1ea7bfd"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4a61feed429597d57de9fb262c077cd133293c3fffe9deb44f66c2a2ef45168"
    sha256 cellar: :any_skip_relocation, ventura:        "65515ea14fee716e8b7b6bd3c1afae1cefdff348b493a985ebdcc81c86c81f0d"
    sha256 cellar: :any_skip_relocation, monterey:       "1c0ef9f1d4803f103ad256a3b8248867a9d3b25294bda98434b84229a1f78419"
    sha256 cellar: :any_skip_relocation, big_sur:        "81798858544b739e736244e94098131f6e7d2c5ad3dedcff91aa641e0bd875f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea805526c8d9cf548f9771302c502c5e3c809a2f09063d80e278e091170ac7a7"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "homebrew_test", shell_output("#{bin}/cbsh -c '{ foo: 1, bar: homebrew_test} | get bar'")
  end
end
