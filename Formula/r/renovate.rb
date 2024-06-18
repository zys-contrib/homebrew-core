require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.412.0.tgz"
  sha256 "ae85c0dc3f6c16280087bd84d64d379ea37b12215d39ebfb54ad1807c8ed3a42"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f08913b48eedc8bea3e57e324d98df3fa467aec89196a84948a67d30f6e7b18"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d3e9d81af725bfa47a8c331ed45d920e1046d1792924ef2238e85824dccb508"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5cb3a6000af1877b07794c3d321c237ff963f1ebd39720d565db9193414bbb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "552f6b76071edf2463f793d1a5720aa8adfb4dcbd962cd6b903aa4ee12b69ae8"
    sha256 cellar: :any_skip_relocation, ventura:        "31513a77c464f34ff096ddba8213b60d1737998570e6d310a46cd27d8b4cafde"
    sha256 cellar: :any_skip_relocation, monterey:       "bf9f72b28a18349938e0804a6ef2c3587f017b77247d49dfe314eb540f84e06c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "684efa93e47177e889c6e8999935f63c1bae56b98176e5d568d0bb5f46abad53"
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
