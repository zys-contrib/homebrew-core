require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.392.0.tgz"
  sha256 "4f650e07b5b08b8edf03dceea4d6f5c92482da6e13e706ecff768eb2993cc758"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89693e16c73a48d4f4db414db723ad718d287d625a76d8fc1ed9fe3a1b0a613a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5ddeb8157c8050efb5b13bee616eb12b14312da86e069f7560466c4858faf2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea7e136280d74cd33fe6aa9fcc03d4bf18d3b1a0e85618220c8d442dfe9ae5d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "9754293b915f66dcc475c807d89a5405f082dcb3ccf9389d6e9e5277ee4ee0ab"
    sha256 cellar: :any_skip_relocation, ventura:        "fbd530a93c02c7f82beb8f63ed7f27be5d8c430e9412f090999dad39d24b9380"
    sha256 cellar: :any_skip_relocation, monterey:       "066a94ec967bb5e69870994cd3139cff7daf1c371a74eb74a20fcbc94d0ff24a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c2b2cc74db7b503416b053c77251dc857ffb692699f79bc8ab3b052535578c9"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
