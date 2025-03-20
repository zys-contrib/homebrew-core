class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.210.0.tgz"
  sha256 "0c43e8ee684aa2f9b35e72f61e0403299d82042dbdaf08dec2041b040617a23d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d01c54a348710e8f933a8f874a0053d293f2efb4c66fe632c8ffb879d60f3e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9b84407c2d8aa83f97a023bd7ef1cf25bc6610fa86a8f7c35c58cfe895b4fc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12a47a0a65d7be2390fbe58d8ea2df150abf50885333112546b5d6587b4eec27"
    sha256 cellar: :any_skip_relocation, sonoma:        "1879f4797852bbe476889ad17652aff95e91f063b8767e45b63e8820386e81e2"
    sha256 cellar: :any_skip_relocation, ventura:       "1930fa120d6eab86f4a3c3c5019be7be03c74aca5a90e2483cd2d1b93c35c6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e590c06193fd60d1c5d5053349177ea2c87750a259d346aef0ebd73903df74ab"
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
