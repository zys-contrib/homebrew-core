class Prettierd < Formula
  desc "Prettier daemon"
  homepage "https://github.com/fsouza/prettierd"
  url "https://registry.npmjs.org/@fsouza/prettierd/-/prettierd-0.26.0.tgz"
  sha256 "4e99452dd2fb62971f8bf035d76af38d0af9a10ce9166f82b9a42d86b9ce0d7c"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c6bff9b787b92531aa1acbd522ddbd8215c377717ef1f69466922bd846f3cc0b"
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
