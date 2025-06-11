class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.5.0.tgz"
  sha256 "4f07cd0075c389a9f082d0c9ada79d2dd27cf89f41d8f21a25fa363ae9ba4807"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce68402017d66b4db9e396bba2bbbbc73b4c8a770afddec992dd6df6c1c10230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce68402017d66b4db9e396bba2bbbbc73b4c8a770afddec992dd6df6c1c10230"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce68402017d66b4db9e396bba2bbbbc73b4c8a770afddec992dd6df6c1c10230"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b1446c3bf162cbca8d3a98508cb42704c019ddaeb076adb839be14b5c382e50"
    sha256 cellar: :any_skip_relocation, ventura:       "0b1446c3bf162cbca8d3a98508cb42704c019ddaeb076adb839be14b5c382e50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce68402017d66b4db9e396bba2bbbbc73b4c8a770afddec992dd6df6c1c10230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce68402017d66b4db9e396bba2bbbbc73b4c8a770afddec992dd6df6c1c10230"
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
