class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.69.0.tgz"
  sha256 "7611d0370ed65deb127b74e165d89772a5e5e8fb648bce33e02c7f781c462557"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "803a4f991368820efaa4775f4dae52e02d6184ad8cf67b3c4bd8c9cb3ced59e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b860d838fe4b1b34c24af618cb66753ec1a786b545a12944852933bc8c53d233"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f65714d89e307619f8f4445d9077908f310a58e83878454111187a32e11f3d91"
    sha256 cellar: :any_skip_relocation, sonoma:        "67f650dbd50beb330a332c63ad5fd8c6e394ca9cb95fbbeefb9ff5b45e043f32"
    sha256 cellar: :any_skip_relocation, ventura:       "529547d0002c5e9029af287fde4b34c760422719ff1db70fd1cbba11e26ab44a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a4f4f606e0492a4936a89479836f07a7a6783e64a76573d8477619bfd6f23e3"
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
