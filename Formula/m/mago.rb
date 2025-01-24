class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.4.1.tar.gz"
  sha256 "bf9d8a83ddcf4eefaee5a2c38ac3302d2d16e932aaf37a87e8a6fe0f429c0217"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43fc18ec8bc7f58383c1cc90403a654aa684c1bffa5f31acc920e0f256b46e9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "130dfc58f4c8ddfd38aa3f03b4a487448f0af0e66d112e78502b55bf5f70616c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b24a516dcf7716e9e54d96f31c7a1fd6d280b86414466f60f759859235296bd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "769b3c52dac5264638993d406f3b69087ff638f591b555f11fe07f35e1e9ed0c"
    sha256 cellar: :any_skip_relocation, ventura:       "449aded5fdde05259dfd497ec166056745ecba2051096d5054cf37b9a8f65311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "496182157ab8f0aa6deaa08a5bb6b3ac5d0305a9449193aacc61e7b203c3fbf5"
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
    assert_match "<?php echo 'Unformatted';\n", (testpath/"unformatted.php").read
  end
end
