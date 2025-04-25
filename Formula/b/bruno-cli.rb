class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.2.2.tgz"
  sha256 "8bcd0de0c3ce7d94179e4385d07f7f7936f869cb1d5333a9f4bf7c8f9b655853"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16feb93de49e7c6eabcef48c42491b746e9a1488e01296897732ed95a60cbaed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16feb93de49e7c6eabcef48c42491b746e9a1488e01296897732ed95a60cbaed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16feb93de49e7c6eabcef48c42491b746e9a1488e01296897732ed95a60cbaed"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ab743749fc773ffab398bd894c135aaaa48c9c7f449684dcaa709aa267de15d"
    sha256 cellar: :any_skip_relocation, ventura:       "9ab743749fc773ffab398bd894c135aaaa48c9c7f449684dcaa709aa267de15d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16feb93de49e7c6eabcef48c42491b746e9a1488e01296897732ed95a60cbaed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16feb93de49e7c6eabcef48c42491b746e9a1488e01296897732ed95a60cbaed"
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
