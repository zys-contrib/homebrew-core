class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.37.0.tgz"
  sha256 "5f325bad0dbb512c2a8b0f9635f24dc7f29995c2da3eaaae9017223e06ce2a5f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "357920f5ea16ccfb6dd5356b2c22b0cdec45b25a9d1b0e072b4633760fe475c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fdbb68feebda54599689b4b89fd9c82a1a4087513ee3ea9138af78ca490619a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43a467434af63d8cee7a672d5ef42ce5747e2b0835124b76fa8c94bf947636a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c75633a243000b71911e8305e824c8203c6bcebd93d1f088a61948984424ca25"
    sha256 cellar: :any_skip_relocation, ventura:       "bb8c2c67e8ce76c60bc2a3d6eb774b3dfb0581f36c7511774debc80f3fe5f4cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9d77b5711229bdf017a4b078fd8298f05cf78be6468c91ad594e207eaf1d43c"
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
