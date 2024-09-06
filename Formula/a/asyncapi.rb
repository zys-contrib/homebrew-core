class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.3.11.tgz"
  sha256 "e6b152ad0064b00ed4689ad010f6734d57f45fd4273b28e4d6fd3ea0a7fa5c7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5bef59f9631958584181f32f56a70c9814c272c1bd0bb8d898cb2f9b38f2ccd1"
    sha256 cellar: :any,                 arm64_ventura:  "5bef59f9631958584181f32f56a70c9814c272c1bd0bb8d898cb2f9b38f2ccd1"
    sha256 cellar: :any,                 arm64_monterey: "5bef59f9631958584181f32f56a70c9814c272c1bd0bb8d898cb2f9b38f2ccd1"
    sha256 cellar: :any,                 sonoma:         "b1af0f54708115e7c8efe1f13cef9b3fd8a3021aa1ee3469049469825425f495"
    sha256 cellar: :any,                 ventura:        "b1af0f54708115e7c8efe1f13cef9b3fd8a3021aa1ee3469049469825425f495"
    sha256 cellar: :any,                 monterey:       "b1af0f54708115e7c8efe1f13cef9b3fd8a3021aa1ee3469049469825425f495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eea3bfd9f314b08ba50fdb45d0bd0a02efc57084cbaf70f4326504244f8afe0b"
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
