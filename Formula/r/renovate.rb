class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.124.0.tgz"
  sha256 "f2140c5efcbbfeff173c3cb205ca73a30db3d65c7b50ab6c9baa32864937d212"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "722502cf4f086b3e3e16b28ea803dd7882c9ee26c5b9012c96baa2806e2b5b17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0ee8cbca79110e4a510e175b35629c81effbd742cea0bcb43ea9b51a0d262b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d3dcd136288646c5080ca00d41bd5232833b2d4320ac9ce320422d384ff741b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd8e79fcf21cbe6b25fb0562965f8dc3c92426175259a10dcf7eb355adfda2f1"
    sha256 cellar: :any_skip_relocation, ventura:       "21d7c2ed0f76a4d10e3ff732631ae860e959368f77851c63a24ac6e8458280bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "734201c5ac1898ec39c7b6b1e6711b08f3ef2d3bcc0d686ea2a281efb185925a"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
