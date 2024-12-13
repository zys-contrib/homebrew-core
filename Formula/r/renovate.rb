class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.65.0.tgz"
  sha256 "def2b9714990be72b1d877355eb5e5bded315ded830cd533ef7e82f7668c4afa"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b8a98180e2ad60327d31597c73a389f830c2e829547e95cea2c0e6e9db6ec18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0831f0b3cb29fbae7643d9481937f059f8021b9eea72318ef7192fab112879e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ed6aa115ab7f1b894cc6be570158fe21f9c726613601d15663b221d7fe3d078"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf9a12d7aa686d751a733cb715d8db7b7de8f7e1088f67a441c61d840a5b97a0"
    sha256 cellar: :any_skip_relocation, ventura:       "1e0594f88fb925a93f53397dc24f32673411e94a9aef5c9ff93b231cc46efff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "677140ef134e2080aaec8ffe5c15a0bf30ebe58c5546971aa89b8b506fe9f3a1"
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
