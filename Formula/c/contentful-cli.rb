class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.4.4.tgz"
  sha256 "1ea4f9f48a683e1e19c6628176577c20383a6902a6c130ca0cc8a44cf97537c8"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a51522f9e32b70fdee666f57f6d1963588c498a9a738792141d68c34f7abbdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a51522f9e32b70fdee666f57f6d1963588c498a9a738792141d68c34f7abbdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a51522f9e32b70fdee666f57f6d1963588c498a9a738792141d68c34f7abbdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "36c1965ff7dab2abccc1dc024e2d12014ac4d6e763989bd81110f69dd06e560d"
    sha256 cellar: :any_skip_relocation, ventura:       "36c1965ff7dab2abccc1dc024e2d12014ac4d6e763989bd81110f69dd06e560d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a51522f9e32b70fdee666f57f6d1963588c498a9a738792141d68c34f7abbdc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
