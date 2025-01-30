class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.144.0.tgz"
  sha256 "172d2b9138ecb18619ff6fb5997aed67fc2a211c9d36bfe1442fece2f336150f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e4e993517ed5ad3addbe8265985e233409a818fbeefbd1252df4371da5e89c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f504f6b9930e60c0c5d32d94c7342188263868566a209bb13d06ab859eff9e15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53cd1b4bbaf21f5bd42455a4c0bd8236a17c71bec2c2db48d623edd0eb840fb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "085a7c4665b491b718b0e4e28b9d0348085b9fd08316ba12b91a874a909a8267"
    sha256 cellar: :any_skip_relocation, ventura:       "aa56aa7da11ef879eca46dd27825c3351ad70e030ea3456d37dc9869485ad5b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "010f29735d9c2ea533b4258982b68373d7e3378a7b51e279407f05d71c590609"
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
