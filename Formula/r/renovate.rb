class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.50.0.tgz"
  sha256 "a13f175af0ce48d936d71a6b13bc83f2a0d4317c2af2cb3c9162597e9b692167"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68e3793fa569a7120c20fb765e5fdf283aa538cbc688713d8c8ae0ea6f4fd47a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebc2eea984fb1fad5381a166ad7e97629a162c37e354997194a307d30d706506"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b60d7eccc233ee32fda1ae37d21ea814ab0544e86e3ec2bc77d4b67b16c113cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "96cabdac68825fba15f1e5a696857088b6e8fedb218072ee93d73fd6b5088550"
    sha256 cellar: :any_skip_relocation, ventura:       "0eb98422872d404dca869e9d118a3946d9326ec7d62dde77142c2ee24aca99b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df66c2dc53120a61f923a794d710d7567d5ab8abc7d3e0f114b98289f12ec67f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75504d7f130e7db89b8ad0babc2b74e9bc05733035b00de3bfd8b92e27d04556"
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
