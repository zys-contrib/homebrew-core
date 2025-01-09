class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.99.0.tgz"
  sha256 "10aa199d2b14bde7474de07105207041b4ee722b3c8e93148c4e3ebbfe3b1f30"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "407eb70ad39f3a774e33c5e355e487bcde8fccac79be1932c3e40ab156904119"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3caa73aa05235892b769e68d772f2883471d94f5dd25eaadfb72d8decdd7de12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16eaa7ca33bbc8746e4533a20c91814ff88c391b4a860763c760062455cbb66a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f99fd153a79244d54452a9eac4bb0f7ad39c374f8e8f0d8c7bd3acd9b9acf8d"
    sha256 cellar: :any_skip_relocation, ventura:       "ab6395d09fb42e43ce0b4f623c9652f63fbc71446faf439cdfdc227baa22979b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a43e7d9246c48c2d2c44ba6ec52f76bf18c7b629ac7169b95920c75549fa704"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
