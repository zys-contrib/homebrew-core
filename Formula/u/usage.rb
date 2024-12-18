class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "d0f2b07ebdc6e3021f02c9a2c1d3738151c6d55f6136749c1de08c2da7fa9108"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4c270f404594e3ef3c71e409c7659f9b348a207ce10f40559f4dfe25f20c16c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14015a3b55cbf9dc13d1b61646aa522876f028426d5986570fb32c757cf6ce11"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f95420617c1b299a1531f2c1e438236b136eefd9611a6e0f6c9e2887ba20596"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc794c72574e1e9fdd4446a3782c949869d94c2be838fc588335bad83a0361e0"
    sha256 cellar: :any_skip_relocation, ventura:       "a60030d41166ec03e1598ad13d054ea0a532d0667d49ace54f37b8bf7f1d33da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b5a40aea9c81ceaf99eec8a43ac396028cc226bded6fcae9f090756e6bff99b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin/"usage --version").chomp
    assert_equal "--foo", shell_output(bin/"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
