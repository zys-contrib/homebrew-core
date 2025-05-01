class ChalkCli < Formula
  desc "Terminal string styling done right"
  homepage "https://github.com/chalk/chalk-cli"
  url "https://registry.npmjs.org/chalk-cli/-/chalk-cli-6.0.0.tgz"
  sha256 "480a85e48da024092e1b63fe260f810880f5f82322d82f62304f32e970112216"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "34ba6623e9eb8c3903a10be845faa920fec20d6133e17390a16326cb670964c9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "hello, world!", pipe_output("#{bin}/chalk bold cyan --stdin", "hello, world!")
  end
end
