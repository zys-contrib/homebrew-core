class Prettierd < Formula
  desc "Prettier daemon"
  homepage "https://github.com/fsouza/prettierd"
  url "https://registry.npmjs.org/@fsouza/prettierd/-/prettierd-0.26.1.tgz"
  sha256 "aae1a7c3dcdbc7e98b4aa456ad090adec954258c65308a0e7ef1c55c7f5e54c9"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7267f5166526478255bba5330f289d8d62640495d32ae6799fec9ac81465e569"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = pipe_output("#{bin}/prettierd test.js", "const arr = [1,2];", 0)
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
