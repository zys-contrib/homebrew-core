class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.17.0.tgz"
  sha256 "873b29f1aab850655b32ede2a2e9f0b8b6a343bfe1a3110d3471461ce18aeb6e"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4dd5e2b313142845c4b2a8187dc360ca72eb025fe71694c68e93ac62e89506b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a0df6d8f554cd95c204d48cac050d4a001afabbb6e09ca3ac1c0cd78efbaaef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9341dc76f11a7c0faa219aead35e63b72b33a35f97482809c63427e5ff7229a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "3411fb95875c37c450fb3b3ce1e00223b85cd046230fc8bb8b6d769740ee14b5"
    sha256 cellar: :any_skip_relocation, ventura:        "096808882c5e26f986bf6c104d2a8e14d717357a36abebec35ce6c377a179d24"
    sha256 cellar: :any_skip_relocation, monterey:       "b9adf0d8fa8dccaf31b7e33aed7efa7ae595bb6c7f289cfc5e87c3a9cf3dd7d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b2563f5532c01939bf8daecc80fd5d5ed967a179681cb4f0e6a72f6acf87009"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
