class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.14.0.tgz"
  sha256 "3784b61e3937acb6d1f60db6f19bb429225ae1c4d1409b3950e26d156ebe4fe6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0618e11ac2c0c27202e14123a40d5f32488d4129de84caee61e16c2512c0c8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "801788f42b345e64546d500149117547dcf5f9272d405828a938f9a2120eb6c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b40cc0d27b9a7db43663cb1b79a716f9ca3b9c624d4390bac838b05cb203ec3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3629f86fb53b0e6b39916e22200f0008cee289b37868c3baedaad817ce56901d"
    sha256 cellar: :any_skip_relocation, ventura:       "e4e4d3aba940895c617adb568dcb404e096b9f708af992460b6fab49476a9ca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18ecb270cea3774fa8da723bc42099bef68edd1384eff0f9a6a2246f924d441d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "955384a845aa82c968dc6e3a1ca26b77585cd7a17b9513f568281a7663dd6d51"
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
