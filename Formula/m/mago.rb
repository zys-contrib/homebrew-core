class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.0.6.tar.gz"
  sha256 "26580f99d2a0f224fcb696d9433639aaa60d7ec9adc59784eba4170b2f6c73fb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af5cfa25d07f9265a58e7e4cdbec773e05867c50e3a56afd61ddcdb0ec4ccb90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fd2c6d41905da0fdcb5a32d99a240e8941ab2368010049fa2a11f1e7d05eacd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5197a3b0fe4c811b94a4e0516b6e8616f294e8991d162de81b3a7ccaa54f031"
    sha256 cellar: :any_skip_relocation, sonoma:        "e603ec47e569eeb1ce97b86ee4cd5502ba878400691f7f4f97fe801e438f543c"
    sha256 cellar: :any_skip_relocation, ventura:       "60ce046ca8a5189eb320c13c6967f27e1a04548cfe8fe76fcf8d298a133ae461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a7d669efa9df228666a1e311981e9c165991862a01ae2ce560d432f19e3a766"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mago --version")

    (testpath/"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}/mago lint 2>&1")
    assert_match " missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php\necho 'Unformatted';\n\n", (testpath/"unformatted.php").read
  end
end
