class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.79.0.tgz"
  sha256 "d2da8ecc43690809059ce4139608e4a5b1dbd991d27ff9d7408d721f88fb52c2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5ecc59cef9238bd600f938465f776b20e525f42dad5822b24d5a6ae9ed59895"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cffc13f8e2de723272f86d47032e34e518e7ccdffd01ad64ac6cfa78ced0ed9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a824c1b1a269f44b0f8d7aed3e54ef1921210e9972d119f56797ccc878237c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0738f76c044e7d3d0303a7207cc389f1ba5368c437ebfaccec04970ea8bbd544"
    sha256 cellar: :any_skip_relocation, ventura:       "a586d2e3f6e0059b9d296af74c4d786f2ae924de1635222d74baa9504729707c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f74d1fb69bf8ade5369ecb1427c5273b34ddd1f585d4144bd568a2b3ca4ee752"
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
