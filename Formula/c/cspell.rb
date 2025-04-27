class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-8.19.3.tgz"
  sha256 "04cdc9ed2cebeac0987fb5c4840cf7b5905163b07f67b02bdc68412699e884fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e645a18da7a578b9f81fb60555628e5716a0cec5537222adfd1b09b3646c6ec1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e645a18da7a578b9f81fb60555628e5716a0cec5537222adfd1b09b3646c6ec1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e645a18da7a578b9f81fb60555628e5716a0cec5537222adfd1b09b3646c6ec1"
    sha256 cellar: :any_skip_relocation, sonoma:        "95d1b28e34021e0e01eedeb692d4cf1a62ef54e7f47675530d8bcd8f4a0e6ee0"
    sha256 cellar: :any_skip_relocation, ventura:       "95d1b28e34021e0e01eedeb692d4cf1a62ef54e7f47675530d8bcd8f4a0e6ee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e645a18da7a578b9f81fb60555628e5716a0cec5537222adfd1b09b3646c6ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e645a18da7a578b9f81fb60555628e5716a0cec5537222adfd1b09b3646c6ec1"
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
