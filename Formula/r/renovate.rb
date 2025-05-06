class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.7.0.tgz"
  sha256 "3c444ead6fa9d239b6a47da42eba9ebfba7d970dcfd76b48696fad4cabd2662a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c4d36e0401011e7bbe1803a54e61d10e4fe6ce572bfcc0ca27b3e9cec81aae8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4eb73a956f53ddbc49b9fef6eac64808dae696fae220f8900d72451a15ba114a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29c00d3d27924db4e58e7047c1b65867be6582410420b3b01fde33d891676f83"
    sha256 cellar: :any_skip_relocation, sonoma:        "41910502614c3ff50431ee5e8cb495ee98416c83c72fb02d6c194f99c96d2aa6"
    sha256 cellar: :any_skip_relocation, ventura:       "7e592d5b8f141887949b36248801b12b6698f4acaf03f432ae4fa55845688e7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cae8a40b195f65f3cdf9ca92f70c9c0e58c68f478b4eb89ba63d8d490139624b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf963ce92c743e787103351004b74912ce87f92fae73f4396abdbb220999d189"
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
