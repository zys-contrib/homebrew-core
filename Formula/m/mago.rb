class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.8.0.tar.gz"
  sha256 "312a5718bca6a02b93f91aae6231fb2c28af1c06d883f23a3cdaa3717fd8c385"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9c8ac77fe5e2333d27fef2a31ef81ebd3025698ca87d880032aa1cdfb38eb8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "048b4d95edf79e82243a27c784c06deaf9a1244a3826df6677520e88c9ecbb9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6de591ce8c8dcecb628b4547eb10ecb603403615c6679a5bc7d858969f0086d"
    sha256 cellar: :any_skip_relocation, sonoma:        "abbe2c05f83320d9bfa1a6996ad409dd3fbbec99dde2434e8554e92208dec67c"
    sha256 cellar: :any_skip_relocation, ventura:       "5058ee2857f05456b3be090349a57a3465022582a0e8b187720e34ef78262556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98b367bfe7df7b15cf4ff3f15e4efdbc924934d26467114b28c7fdf6d6fbb0e5"
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
