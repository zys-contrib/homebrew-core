class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.3.2.tgz"
  sha256 "7045e0c08eda29eb2c5347f58900992a7e70b1df6c6c3c1519ea200422db4590"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8fdff98e17d2cb304c0d9d412657ebdcb4c5fdd37b38c2f418735902cbd34e13"
    sha256 cellar: :any,                 arm64_ventura:  "8fdff98e17d2cb304c0d9d412657ebdcb4c5fdd37b38c2f418735902cbd34e13"
    sha256 cellar: :any,                 arm64_monterey: "8fdff98e17d2cb304c0d9d412657ebdcb4c5fdd37b38c2f418735902cbd34e13"
    sha256 cellar: :any,                 sonoma:         "d621e2548eee46844dc2a0f0b6a661db4dd9ec5754bb455f7729d21ae22bd15f"
    sha256 cellar: :any,                 ventura:        "d621e2548eee46844dc2a0f0b6a661db4dd9ec5754bb455f7729d21ae22bd15f"
    sha256 cellar: :any,                 monterey:       "d621e2548eee46844dc2a0f0b6a661db4dd9ec5754bb455f7729d21ae22bd15f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a53ba57b2b2d34448e0b4ee2970e5070b3fc984185621b5ad32e94dba03e223e"
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
