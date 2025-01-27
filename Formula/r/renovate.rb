class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.136.0.tgz"
  sha256 "80506d38aee3c35d2a5f1b5c331cdca2e5e0c97a5aa940b5c9015dcd04caa545"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d20f171a863719abfdd3ea44f18b61cf84f9d0e607748fb42ec6e2f4047a1df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d22bcc5a41b7e0b401a0322966a1315b7423961b77471eac14e27a3dcae2b591"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "435aa0099b50b5d733891a94ce9fd07f955b60a81afd07cff5956feaf22a6272"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a19e7335ea93c0fbb7a2319334d2e306449ef514fa06accdc9a986dd7ccec15"
    sha256 cellar: :any_skip_relocation, ventura:       "ef603a648462c6654d7ca572b942079b56bff4d24ba4805b26143950e6d76d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dbcc33cfefb62b286a0e491aabceabce8b8b01de5124c4fe51ebb13ed0c26d8"
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
