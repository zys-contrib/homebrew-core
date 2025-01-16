class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.0.20.tar.gz"
  sha256 "f8f4e55eb3bf81466fad82232ea4f6c6ec86fb370c9e6c7ab8c255163e4e8fe2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f41b1e2da0163632b915325143f551f60b02fa05252b6c64492cf149f5e59c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ab224a5ab535945cfb58bb00323bac9c195d0ade3721ab63b6a1b1a0b722b4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c9251da9a830249977a323e4b855d33492eb3418050a97d170c339ce32ab150"
    sha256 cellar: :any_skip_relocation, sonoma:        "e63c1a0bcddf5e339009bb9b966005ef09a805ffc211a05435bcb234d5c8ad2a"
    sha256 cellar: :any_skip_relocation, ventura:       "56e27f96ac77e4575a9b528dfbe033a67767fc05343892550a3c456f34906c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8f28507a58c9b1989163daae2950fe3d29c68e9b5cf12544289fdbfaea3cf86"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mago --version")

    (testpath/"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}/mago lint 2>&1")
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php\necho 'Unformatted';\n\n", (testpath/"unformatted.php").read
  end
end
