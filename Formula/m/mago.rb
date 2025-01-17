class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.1.2.tar.gz"
  sha256 "8e8db6f95ffe1d9ae0ea6e7a39059507c3f318cb2f20153382f3e314b5f8a101"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bd44317be7901b70e4ca34a7d388239e6c9228455482c47e83023f50d93e464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c364fe9cbb159abeb2b891aa3772f47f94cc061104e9836a27a67ed1b307bea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bac0a2f1b647c731ce419c794cfb50a618903234ba15e70c82f6817dc5683d0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a32493b4b705299af5d9f28bc6542616f6e1dd42e3b1b2893852de3e288d9b8c"
    sha256 cellar: :any_skip_relocation, ventura:       "179693a148cc3ee9dc2d76862d82b997b22a6d867794d9ed3b8e21f8d18648a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2610892e424c0426a307965ee485b4a24b67d06a45457c8a45a6568c6744973"
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
