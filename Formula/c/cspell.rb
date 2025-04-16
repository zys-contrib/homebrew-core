class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-8.19.0.tgz"
  sha256 "abf8fdfe4d833407ec9beb836d525f55f3db931bc5d3933d149e63e5baf1c0ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c7de9ec19160ae96bee1076a66166a6479a2960512ba8eeca13e71fdfee0d0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c7de9ec19160ae96bee1076a66166a6479a2960512ba8eeca13e71fdfee0d0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c7de9ec19160ae96bee1076a66166a6479a2960512ba8eeca13e71fdfee0d0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaf897168839f843fcf5807020eeda1baa0bfd3ff2b485723d1938ff4be2f28e"
    sha256 cellar: :any_skip_relocation, ventura:       "aaf897168839f843fcf5807020eeda1baa0bfd3ff2b485723d1938ff4be2f28e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c7de9ec19160ae96bee1076a66166a6479a2960512ba8eeca13e71fdfee0d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c7de9ec19160ae96bee1076a66166a6479a2960512ba8eeca13e71fdfee0d0a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # Skip linking cspell-esm binary, which is identical to cspell.
    bin.install_symlink libexec/"bin/cspell"
  end

  test do
    (testpath/"test.rb").write("misspell_worrd = 1")
    output = shell_output("#{bin}/cspell test.rb", 1)
    assert_match "test.rb:1:10 - Unknown word (worrd)", output
  end
end
