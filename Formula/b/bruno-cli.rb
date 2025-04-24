class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.2.1.tgz"
  sha256 "1addc02c419ec6c9d08fdc91ea895e6f2b6e99ab5cf614e0a7a6c0366c986ff2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a83caf5d8cc1f6db2095a5bb11ff790949ad43e9eba73eda2639a330a555167"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a83caf5d8cc1f6db2095a5bb11ff790949ad43e9eba73eda2639a330a555167"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a83caf5d8cc1f6db2095a5bb11ff790949ad43e9eba73eda2639a330a555167"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c2f61da169e4e7775733eb24136eacd4de45efcf72004e8553e6173a6d47fc9"
    sha256 cellar: :any_skip_relocation, ventura:       "6c2f61da169e4e7775733eb24136eacd4de45efcf72004e8553e6173a6d47fc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a83caf5d8cc1f6db2095a5bb11ff790949ad43e9eba73eda2639a330a555167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a83caf5d8cc1f6db2095a5bb11ff790949ad43e9eba73eda2639a330a555167"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # supress `punycode` module deprecation warning, upstream issue: https://github.com/usebruno/bruno/issues/2229
    (bin/"bru").write_env_script libexec/"bin/bru", NODE_OPTIONS: "--no-deprecation"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bru --version")
    assert_match "You can run only at the root of a collection", shell_output("#{bin}/bru run 2>&1", 4)
  end
end
