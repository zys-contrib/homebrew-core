class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.12.tgz"
  sha256 "68edb800176fd15f610d73a69473a803cd599dff49ee29a637d5dccdb1fcb4f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "23373ce71312a177bc30fae1d5441befa117657d615689e586855a57c768517c"
    sha256 cellar: :any,                 arm64_sonoma:  "23373ce71312a177bc30fae1d5441befa117657d615689e586855a57c768517c"
    sha256 cellar: :any,                 arm64_ventura: "23373ce71312a177bc30fae1d5441befa117657d615689e586855a57c768517c"
    sha256 cellar: :any,                 sonoma:        "9053398f20d8f611a821581ede0f36dba35347f69b72344a810db2d44453fa4e"
    sha256 cellar: :any,                 ventura:       "9053398f20d8f611a821581ede0f36dba35347f69b72344a810db2d44453fa4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "051fa23d3302690e49bc79acb03debea10fd75262d5530450f07a870dd52d3ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "347571b4258f79a4dcfc3c788b0b175983f1692b08de37199ea01557f5d225ed"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
