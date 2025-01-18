class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.2.0.tar.gz"
  sha256 "e0d146c4d44b1aef0998e565e037dc37679c782893a642ec416f117c463c1a00"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57223ccd411bd834d5cac2bdde9423710142c8a1c011fdbfa248a75fa980e8cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43ea32520e8258ad23ae33311763b679f8b9dbc1df5ef9155ca989186538e481"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28a70faa63261cb0e88a591ee578cd20017becfc0c56dc25e78431462862b26f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4936ad1a2f3dc3089b99c9021b6f80487cfdf6297668d45a5abc81174d8115d"
    sha256 cellar: :any_skip_relocation, ventura:       "61fb32c4cd2d7d3f00818f19afe0a1afd7db11f453b3d15a7f34fe21f4d50cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9f2b9efb22a322e916d55c702e9dc2a8126f693fe99df02ea8855190197fdd5"
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
