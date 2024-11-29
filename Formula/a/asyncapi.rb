class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.11.1.tgz"
  sha256 "31681640b058085603937dd4f5c916401211aa63d94e226a4a27818d832f8519"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "82672af6d48398a4aa6425c4598ed7d07165a9e3ea0233020d57667f96141940"
    sha256 cellar: :any,                 arm64_sonoma:  "82672af6d48398a4aa6425c4598ed7d07165a9e3ea0233020d57667f96141940"
    sha256 cellar: :any,                 arm64_ventura: "82672af6d48398a4aa6425c4598ed7d07165a9e3ea0233020d57667f96141940"
    sha256 cellar: :any,                 sonoma:        "f0e71f1317e3a98efab835179ff08f731c36a46c0f77cc3f9b2ed9cbb26f457e"
    sha256 cellar: :any,                 ventura:       "f0e71f1317e3a98efab835179ff08f731c36a46c0f77cc3f9b2ed9cbb26f457e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17e916d6d1e08e5166ad13f16a7bd79c5fdf72d749db9e298bac627799aca0a0"
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
