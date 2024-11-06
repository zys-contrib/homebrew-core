class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.8.1.tgz"
  sha256 "76d196302645ec73334e731baf3f7ec2497b27f314f7a50d0f5cc08c28ae8a12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ddaa6d718d5c633a94c83db42a6ec1325ecaa5b4a862c4c36094e12b4ce8d5b2"
    sha256 cellar: :any,                 arm64_sonoma:  "ddaa6d718d5c633a94c83db42a6ec1325ecaa5b4a862c4c36094e12b4ce8d5b2"
    sha256 cellar: :any,                 arm64_ventura: "ddaa6d718d5c633a94c83db42a6ec1325ecaa5b4a862c4c36094e12b4ce8d5b2"
    sha256 cellar: :any,                 sonoma:        "d77f22ef7ed880aaf5141c0e0850f5c6da53f1f34041a75211ce29e46a587506"
    sha256 cellar: :any,                 ventura:       "d77f22ef7ed880aaf5141c0e0850f5c6da53f1f34041a75211ce29e46a587506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87641f381eb6508f230419312facaa53b5542cd7d704c665d56a0053f5bc0a45"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
