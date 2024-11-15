class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.16.0.tgz"
  sha256 "ddf8fe8c4bad31c8a285e917801b0aba86eaf3824dcdfd11ea6f21a0f7723558"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44423d14ac12ef1cb1f4a6610d607747322670f7339031455d2abfa50c599c1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e778c868152b59c4a9eddf60ad78e10a3148aa5bcfb89451a2880a9e99b573b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d14743dff8ba7d008bf261d5362bba92b6d1fb8ccbafe56e5ec39366cc4e144"
    sha256 cellar: :any_skip_relocation, sonoma:        "69411b5fddc7f2ba7fcad237c15e7037c2d472ca3cd7989773dc4303d445898e"
    sha256 cellar: :any_skip_relocation, ventura:       "02af107882445db224d5fbb52ada0441141603cc43ac8d7f4bd3641f1a0f0eff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6e479d69326803622595da3fbada1f2b14c4a5e6d409537caad8563f1486865"
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
