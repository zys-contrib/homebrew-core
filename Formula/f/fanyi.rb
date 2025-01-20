class Fanyi < Formula
  desc "Chinese and English translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-10.0.0.tgz"
  sha256 "b1f718e4d63d600c42bbb52f7b93e60f92e2973be723119f4a47dbb5f77b110e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c57d1e565dc5dec910e10f45f362c19e56ae87b904c34b43e9963990ba384ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c57d1e565dc5dec910e10f45f362c19e56ae87b904c34b43e9963990ba384ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c57d1e565dc5dec910e10f45f362c19e56ae87b904c34b43e9963990ba384ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "35da6341e33ac6ebf7de22e8b43b57e7bc74890e77660f499f927e6cfa13ea84"
    sha256 cellar: :any_skip_relocation, ventura:       "35da6341e33ac6ebf7de22e8b43b57e7bc74890e77660f499f927e6cfa13ea84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c57d1e565dc5dec910e10f45f362c19e56ae87b904c34b43e9963990ba384ce"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "爱", shell_output("#{bin}/fanyi love 2>/dev/null")
    assert_match version.to_s, shell_output("#{bin}/fanyi --version")
  end
end
