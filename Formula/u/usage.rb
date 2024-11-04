class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "6a91ce2c344c8a4576d2bff616033b3f8118f7ecb8b984332cb77fd462ed7894"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "261f56cc1ad720ba5a660dbe17ef64db1ef3fe89ca27067d6aa6cb51eab3576e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "755a5a62234a08abbf7a0bc8500d69afd34cf339a1611886cac1a51d4db4758b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce695c0a0b898aacf6dd0a9ecbf26751fc02303c402b604f40d084d1bd826e80"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8ff6409f0ecafcdb9426b47eebc40d1311825cd1d52c100ba8acada394faf91"
    sha256 cellar: :any_skip_relocation, ventura:       "c9b285b6bbe782a08ab73c9eb825297feed8319661d873f6292b1167f794a067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab1773ee7edf21a5572289a3916145cec1f2c703e8234d79d1cc17064ca9cbc5"
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
