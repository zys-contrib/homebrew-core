class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.20.4.tar.gz"
  sha256 "3cc8b75b0311b2d430992b761343b298da19c3db01a303ca4609027d82b751ac"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "686a1f0b80a9701d2becc1e6deda4d7dd0ba682d471d88b84af4c8bd50ab29c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ead0bad0dd78e4a8a6a19176a2bbab8eedd6638627509c7e801e107d2734344"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c2ccf897b6fba473d1b74a5f1275e0f254a42ad4aaf33e64f8be43ca5eb8c47"
    sha256 cellar: :any_skip_relocation, sonoma:        "62881d17308298d56fbe9cbeb0c4f3880e07cac49adb6b24ea4e2a577a4178ab"
    sha256 cellar: :any_skip_relocation, ventura:       "62ddf6a3976a5e14c54e2e7fddd8ff7a0a149e634bc4626edb400ddec7aff908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca4bca33e340e04e99ae2f48e6193943fc6c5c4ca85d9827cedfa8a1f7963038"
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
