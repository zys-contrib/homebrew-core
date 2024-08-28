class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.81.3.tgz"
  sha256 "d4e03c675b71239d5b069dfeaaaf0efa6c290e56e4f5d540a521b90149e3d5be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b142c5798e747ccfe34c69152a6d112dde3feaf6f19f57dd3f209a8d735cb08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16a2281f59342c113f96357a33f260467def4022c134bf896650db2fd056b036"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18b4c69e397861263f414b0c17b3fb4238cfb080ee5e94202cb9b4149dbe5f70"
    sha256 cellar: :any_skip_relocation, sonoma:         "667ef868371ef0c6e81da2c81acd087b492326620569ae7459c9fd041a021f4e"
    sha256 cellar: :any_skip_relocation, ventura:        "ad1511c595738663dced2ad71a22788eacfa07e2ce9067465d6dcaa146b64033"
    sha256 cellar: :any_skip_relocation, monterey:       "c60830bdc13cdfde1de530f641207f7e467d9d92d5af0b093e71a15c68fd9695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c42c8e300098001919d0702d3959a6c3b357a50ef7d9436d4ca0f1c2a3a25487"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
