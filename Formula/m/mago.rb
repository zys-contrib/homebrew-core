class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.13.0.tar.gz"
  sha256 "590b6ad09198ce255476809fda27cca36b7cddc19b9a7d084a8b4ab23d07e792"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8600e5670f064fcc02f4e5121bc925862c9ce5c1276770359ab7c4eb73e66d21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "821146be0f70b2df57ba5a1e8ba143be30f9d0841b75d7614f506de059b75f69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38383c4492e0f4a0bd99eccfb828e6223d48447185bdafc55d067b5e54ad67f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6547b583f8d3be99de520b0cf28b5457e9bd02152a13bc74f81425b7ea59a937"
    sha256 cellar: :any_skip_relocation, ventura:       "14135a8917788e99d5a456eb64bf49c4b47b38d5192fd5a748f1f037b497889f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e44a363871bbc5319fc5862fb1437ec21ac00e7ac4160fae911a2332879ff45f"
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
