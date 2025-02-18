class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.174.0.tgz"
  sha256 "aac90525f1967e61c29d6ed09add82932251575ec43d436ddc79f795dc3d81e2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9c3226c19434a3c60d628fe353c5fc0a3e4b094b5046520fd504aa574ba692f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "464b1107ffbdeabb99b53a5106f6edd08346b9c59d1cf89cff7e769d6764f340"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c921d06a13c2ce59b50407d6c5c1bda8dfdbefd8cfb3637fbb7582954b2c61c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "24e1cfd0967492eb1f70c7a56ca180bc63c53d150fbe08be2c3e516d5856f1a3"
    sha256 cellar: :any_skip_relocation, ventura:       "e09eaf721e8dbdf23a249a0da2777250397694caa4a29e254c4c2fc565778b88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2890f00d029c982e7e35cb51bf7beaf90b27e70b5036c322a3b3fe7d88a88500"
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
