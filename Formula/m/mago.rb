class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.24.1.tar.gz"
  sha256 "ce5143261e8a798a7195f19f1ffca1c5019537bd78f47e6058e9d4ac4805bb44"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24ed841d380e72c80b3776cb583fea38b65d9733d53413715ed27321a4d91ca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da9836664541523da7fa2b498b6b91999b7145039d19dee629c5996934376903"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "beae2faa9b124a541fb4527079656978b15992f0048201a2f2b47abb8145d4e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5ac85564a52aa4660fcc30a89139a7f3a0e0ed2e5d5a8f1ff576a8b047a656f"
    sha256 cellar: :any_skip_relocation, ventura:       "c3bb3e01c9853a52326eb414e537521bc4796e15d389db79cb67d2d1c2fd853e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6bc7302b712f0199c8e8b4c3a915dd52b23224a7d697c0d9d8a2346d9172da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b395f7a6d62b611253cae10b5f39547b5218abefc9dc7e43ebe5ae69f59fd3d1"
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
