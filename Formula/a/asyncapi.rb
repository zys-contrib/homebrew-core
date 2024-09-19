class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.3.13.tgz"
  sha256 "b883ce938247f5bd3eeb7a7c23395c7a997517a3f5ca36657b22f440ccb98ecd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "90b61d53842762c79119d85fc6aa7d7466fcb04bc9f97253b6e4608f922a98ae"
    sha256 cellar: :any,                 arm64_sonoma:   "cd7d37909b53300a64a54179a720782e6b94fbaf1089c1b161fea5667bdff518"
    sha256 cellar: :any,                 arm64_ventura:  "cd7d37909b53300a64a54179a720782e6b94fbaf1089c1b161fea5667bdff518"
    sha256 cellar: :any,                 arm64_monterey: "cd7d37909b53300a64a54179a720782e6b94fbaf1089c1b161fea5667bdff518"
    sha256 cellar: :any,                 sonoma:         "8d80549a981ae924d52f4daa6ad8cb49fac23863d2f8461eee4c7986fd5718a8"
    sha256 cellar: :any,                 ventura:        "8d80549a981ae924d52f4daa6ad8cb49fac23863d2f8461eee4c7986fd5718a8"
    sha256 cellar: :any,                 monterey:       "8d80549a981ae924d52f4daa6ad8cb49fac23863d2f8461eee4c7986fd5718a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "985d7e1056095de79f3bd8cd0d0f1df86ded53807be2e168000922c5690bd0f2"
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
