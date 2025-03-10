class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.19.3.tar.gz"
  sha256 "7905f406afafcbfd735f2c13043b8fb2326e983b176655886b4d159864d18f73"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e8d7358b098b62160ab6187d79a32382647c838a365995a4b64c4bf7112bf14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7d74943d55af834294f7c6281498312db185b7934f435efee79d3ac15f217e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "054df1d1b233ace955d8d8edb59ed5f10cc42c94d5a24df55839fbdc3700c6c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f7a9bf82a86dc120360c9f0c34ea5f7e2e140ab099af30a21be234b11387998"
    sha256 cellar: :any_skip_relocation, ventura:       "b2a41ce3b9be7ad75b0553cee709e9bc8f87419948ec02c7723329f32db0e398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd6bd57af55eda5d2e139a64412229cdcc953aed5162ac943d801d3946903fd0"
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
