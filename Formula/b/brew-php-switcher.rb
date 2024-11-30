class BrewPhpSwitcher < Formula
  desc "Switch Apache / Valet / CLI configs between PHP versions"
  homepage "https://github.com/philcook/brew-php-switcher"
  url "https://github.com/philcook/brew-php-switcher/archive/refs/tags/v2.6.tar.gz"
  sha256 "a1d679b9d63d2a7b1e382c1e923bcb1aa717cee9fe605b0aaa70bb778fe99518"
  license "MIT"
  head "https://github.com/philcook/brew-php-switcher.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8c51cf96644238337f5e47ff322fc06d15d0597b96bfd15daeb20909346c87d8"
  end

  depends_on "php" => :test

  def install
    bin.install "phpswitch.sh"
    bin.install_symlink "phpswitch.sh" => "brew-php-switcher"
  end

  test do
    assert_match "usage: brew-php-switcher version",
                 shell_output(bin/"brew-php-switcher")
  end
end
