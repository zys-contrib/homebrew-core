class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.23.0.tgz"
  sha256 "143b3e512b4122f8e2c05bfcf5e8df908410d928b6dc548a851165dec2e323c4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cd5db52e32cfa0ec8957558ddd80aca2d74a5df3b0a2186eb2d974e11f945f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45b4634cde12ba8350a4bc9873c0c9c031c484f5fe37d0eec93d02faf503d756"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "369d5680278f2fba958951bf9278e6c4d89024c494e3e7e617ab8522f89e9afe"
    sha256 cellar: :any_skip_relocation, sonoma:        "47357ea75b9741a549e53842b380611d91b39a516f9653dd62da4e116b3f6a65"
    sha256 cellar: :any_skip_relocation, ventura:       "f8dc4fbaf01a6f01de9f8d9b607629e5032934357c4178b6dad8fb7f99d1a40e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "852c281c757e0b024c5be9cc411ba9311ef79bf7d402e92fe5ce8c301bfa43f3"
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
