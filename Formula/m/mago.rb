class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.19.5.tar.gz"
  sha256 "e1dffc39485a792f0f9c789d055d0eb1d1caf07e3e6fa40a990ce6b59e4e62bd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c6eb379c01ad6c4cb41212b2d7da97aaa5e4072ae25ebad2c72ee4e62ff47fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee0deeb5c23ee9c7516000e3d78a23e2c0888e9e867204f60ec9433d7fb7cfbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffed710032c84d7d7e6b83afccdc5f6642c87ab42413dc0deb47af9926710204"
    sha256 cellar: :any_skip_relocation, sonoma:        "9adf38286d36c5b7e8cdce820d7d90d05e615fbc77995b3ba4d4ac308dff7b4b"
    sha256 cellar: :any_skip_relocation, ventura:       "32b11da6324b3a7552ae9d1567e69c87b410fd6444476bb03054224b5c9c6a76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2531cb0a5fcdf9d12d557b4a7a22b67aa846abf8131611dcf9c08630ef3340a1"
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
