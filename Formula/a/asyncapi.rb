require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.3.0.tgz"
  sha256 "9b475fec1610c43156e5b6346d8d0fc644a7361d8ba0c9f5249cb60ffeb4fddc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a224c27252158dce560f2e12d7bd6c9b4f0dbbbee42352f32d20b5e4ed488b8c"
    sha256 cellar: :any,                 arm64_ventura:  "a224c27252158dce560f2e12d7bd6c9b4f0dbbbee42352f32d20b5e4ed488b8c"
    sha256 cellar: :any,                 arm64_monterey: "a224c27252158dce560f2e12d7bd6c9b4f0dbbbee42352f32d20b5e4ed488b8c"
    sha256 cellar: :any,                 sonoma:         "d6797e3fc912bb740fcd02441873e18678470738b20f4c2fcb0cfca2bb269ba4"
    sha256 cellar: :any,                 ventura:        "d6797e3fc912bb740fcd02441873e18678470738b20f4c2fcb0cfca2bb269ba4"
    sha256 cellar: :any,                 monterey:       "d6797e3fc912bb740fcd02441873e18678470738b20f4c2fcb0cfca2bb269ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ed4fab9886ce097f327e7f5e9c9c956811c38e76d22dcd00a8e3848dd1223bc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
