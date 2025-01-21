class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.119.0.tgz"
  sha256 "930b25787a53da2147958c9a664b8471ce681b3038e5428bf571a7e09c5f242f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ebd596cc10ae5b77146a6edcf218174c8b68f9a8ec9eaa834f91ecee3a4a8c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f43938ea5e38127f11b76bcb4d68a1b766fdb0098dc7e460355ebb87622a8202"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "310177e1c3bef8fcd65175450fdfb8dc5aa922dfd0a089052edbbc194b4a45d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "585dc5f4a830df189224a7a95ccfb25559ee3ce66ab70cae34f7e92ac614c57f"
    sha256 cellar: :any_skip_relocation, ventura:       "66acb67d296c916ba9dd200c57a971c6444fc5e5867645b2b84cc17d05036ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20faf56860df723255b81dd52fb707d8c3977ed9559eb9ad95559bfb9888f413"
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
