class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  url "https://github.com/wp-cli/wp-cli/releases/download/v2.11.0/wp-cli-2.11.0.phar"
  sha256 "a39021ac809530ea607580dbf93afbc46ba02f86b6cffd03de4b126ca53079f6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dace929d5d39a8582f3b590acbbcafb8066381e8b2e3332b16d5f330e0f1d737"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dace929d5d39a8582f3b590acbbcafb8066381e8b2e3332b16d5f330e0f1d737"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dace929d5d39a8582f3b590acbbcafb8066381e8b2e3332b16d5f330e0f1d737"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd21081f212ac6544e0d1def23cbeff4119e2d492fcf66e9a075aa2a574e0422"
    sha256 cellar: :any_skip_relocation, ventura:        "bd21081f212ac6544e0d1def23cbeff4119e2d492fcf66e9a075aa2a574e0422"
    sha256 cellar: :any_skip_relocation, monterey:       "bd21081f212ac6544e0d1def23cbeff4119e2d492fcf66e9a075aa2a574e0422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dace929d5d39a8582f3b590acbbcafb8066381e8b2e3332b16d5f330e0f1d737"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "wp-cli-#{version}.phar" => "wp"
  end

  test do
    output = shell_output("#{bin}/wp core download --path=wptest")
    assert_match "Success: WordPress downloaded.", output
  end
end
