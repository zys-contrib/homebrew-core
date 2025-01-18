class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.2.2.tar.gz"
  sha256 "3935e4fb01a8f9f629ff624fe5ceb7616ef6336e56f1ebb4f7217b729624017b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56165d505d50e4031fa301d1c3f2fe570dbffb7df60cd6bdfc63f90c12a58d5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b95b5f778a5fd48bfa93cfa186ec32b6bb9dc5e57cd2e8c40400b1af50db3054"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4089e1e5a7837fbcf42fa15c55d837d94f7778eeee65aa27a0f68e276a058e24"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a9add51494b8243821b00ce6a133d14e0bda540728e383e4330434196b3acb3"
    sha256 cellar: :any_skip_relocation, ventura:       "6d63beb00c10f578a7c2871245a2bc4c7948aa867b60c4755ad6560b9c29b33c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c996b8307335187b91f19e5da7928ff739b129b96c811671cc55108ee24e32f1"
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
