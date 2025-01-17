class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.114.0.tgz"
  sha256 "96c2589db985b27ac41dcc47775fa7b4ad4a1ae62bfbc86b2e4d6d1dd5bb761f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77d7044bbf55407f909cb3f585c3c5e9aa89c253b8096e392e2c50fbe9a6e75c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0594488be3ba8f98c180526fad4adedfbe92eeb488ea11d86eed6e8f1797ccdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb4a3c705d365537b59fb28bd0ae4368d9a17356664ab54c004d9338789efb8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "18bb783a7074e1d6fe67ab8430bdf6299c3228e7a8c3e77fd9920c0ca42a9f1f"
    sha256 cellar: :any_skip_relocation, ventura:       "d41b6d3d0e23cf44167b86eab332967da85fcdb0a0ffe205980ab052aa74b90b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dcd98ab9f54223ede9b9666f5588a2d497a5a8ab109e736c5b677e8e5181cd9"
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
