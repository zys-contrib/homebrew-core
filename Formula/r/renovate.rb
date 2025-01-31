class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.151.0.tgz"
  sha256 "8ab29d38278e1236877265725af2d56838787d7ed278b690d230bc77cf34046b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9b00ca86e8daebc837751bbf3449cf8e8e13e56d8db0ce66dcd1c5e238b75ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f27a945d75762aacb0478c62c4d409c151abec620994549bf9816779244f85aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "180caa579075220a50e759b93b27200ae6cedbc68ca80e4e1b5a536423d83929"
    sha256 cellar: :any_skip_relocation, sonoma:        "86b01996e5b0e7a94c22afd1a5e3bcac7a89c51727d04221bde175de78a4e4e8"
    sha256 cellar: :any_skip_relocation, ventura:       "7601c88c581e513dab0113e9c4f598834c1ef4d9fdff157c8cbbb5cc189ccd10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82701662443e474f3e26cd98ce00497052a7bb057e46225100e4d017f18549b2"
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
