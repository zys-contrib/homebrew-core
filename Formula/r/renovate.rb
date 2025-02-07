class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.163.0.tgz"
  sha256 "038a95ed08dc3e92429d32d62c304eb2d506ea6c2392f5114119e3d29543dbaa"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a6d39a85b3e0e4aecc0841bdafe8d33beb6c1b3e8cb191a1e6152585e0479d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d24abc39fe87602ab4a7bf4634b88523f2049a1e4da825b3b542b372d90c48a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2fe11b8678e0805ca35340f3a60eca74ee866ba024cc168256d643d70921b9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0effef1e6b65b357ab50757d922baddf0c0958d15a6e1481703e339d6d086fb"
    sha256 cellar: :any_skip_relocation, ventura:       "828d31c51ad97da9c8706e16375871b7ad1dabd7d85d3854bfe745829fd44a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e8805a3be17b9e179e4f1b267de89307b0d1e6895e83484b1fae973d6b9d53a"
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
