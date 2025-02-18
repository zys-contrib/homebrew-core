class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-1.39.0.tgz"
  sha256 "a16a88c2ac52018f13b58a891befa0372c210409461812d9b489b284f80be13b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4819bbd14f745651a6db61ed333c692a153689419b956670557558b7013942ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4819bbd14f745651a6db61ed333c692a153689419b956670557558b7013942ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4819bbd14f745651a6db61ed333c692a153689419b956670557558b7013942ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3dde18307492a4da1a593137f637f70aba3cc47bce68b57a7f8fdb1be720927"
    sha256 cellar: :any_skip_relocation, ventura:       "e3dde18307492a4da1a593137f637f70aba3cc47bce68b57a7f8fdb1be720927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4819bbd14f745651a6db61ed333c692a153689419b956670557558b7013942ba"
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
