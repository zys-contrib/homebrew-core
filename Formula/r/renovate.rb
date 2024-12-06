class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.52.0.tgz"
  sha256 "707c9024e62c301aa7cc3ede23eb93edfeb2cc60e8748e370a4476e0ad173f7f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b290e66b0852ed9fbda80b5883af80e68c53a1790fff0d82430e6d910c3026ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a9916e4361bb9f9a880ccf0655f216f890e30b7b6eb6d673b0365a949bbc9b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb8c7cdc0e49ee02dce2e2016815d0ec1141233d8df69b4d0d1f06b211492306"
    sha256 cellar: :any_skip_relocation, sonoma:        "15007d0088ed4e0ad3c6c1bb25fda10ebc0d6372d7e6f9ca3a1fc2fadb9955c3"
    sha256 cellar: :any_skip_relocation, ventura:       "233d9f6a8cc8ecdbb63c3137bd5a78765250eba74bdd4aea696f7ef8180fa6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51ea316b53ddeef56f6d331fb991102cbb9f6ff159921050243ec535a371f670"
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
