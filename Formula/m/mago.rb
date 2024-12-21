class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.0.13.tar.gz"
  sha256 "76815b8c8f8cf262dac5cb7b056985e6652c155f99663b0790638e1fd036fed6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50282a3019449486641e569dad605709f6bd99305a398e0a14498888fa2b8a74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95e1f3e39a04b280c4d4952c75fa22c2bf0c134a7feecc44de9290ed5dfbb184"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8605b83d9c1199f437d4ddca59f1b20e04deaff454858d2fa95523d3cd50746"
    sha256 cellar: :any_skip_relocation, sonoma:        "04f391a456d5e173635033a0838e68f7e9000440f8c3a42b1d0ab5f5e6eaeff9"
    sha256 cellar: :any_skip_relocation, ventura:       "8945c937d2954f620c9e57a48e56c570e1a35bd2dcc112e3bdb6ef35516f294e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4caf5c6ca7b25cdd57c2ba9c3a2faeb9ddebf4ef5512e3b584d2218b189752bb"
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
    output = shell_output("#{bin}/mago lint 2>&1", 1)
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php\necho 'Unformatted';\n\n", (testpath/"unformatted.php").read
  end
end
