class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.0.10.tar.gz"
  sha256 "da43637f85122a638a88cbbb16c8d11607f799e5f36ecbb653feba4c72c91ac1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f41629b31254313c62dba2bf356054fdc39e629e1e972093466e46d349b39f23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b7bf20b88d89c1cc860797cb78345629b819f88abba846bb9aca3cd04c66a34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cd4e96282f95616d866d2858ab95345752c6e76e649882991c304e1163960b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "35fb9c5637e2bf39d68e1e94e48cc3d56e42aa8bd6c2ed508656c54bc37076b6"
    sha256 cellar: :any_skip_relocation, ventura:       "343ad35377cda7de367cbfe9815095038aae7492eaa926a4ffbb3091a5900268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67cc6a26031eb48b07c6ec813b20eff82aa23db19287e7102c67a4e95599336b"
  end

  depends_on "rust" => :build

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
