class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/glideapps/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.1.0.tgz"
  sha256 "9ae88335d255afbe40206a4b51bac998c966208aa51f8ba5d35f707769b74641"
  license "Apache-2.0"
  head "https://github.com/glideapps/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "707c8eba6eb5b7581b9fa36f7a44cb2258f86f7328ad64d5554a68fce73a5f7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "707c8eba6eb5b7581b9fa36f7a44cb2258f86f7328ad64d5554a68fce73a5f7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "707c8eba6eb5b7581b9fa36f7a44cb2258f86f7328ad64d5554a68fce73a5f7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "263d832da57c7616ae4a7fda972a0537ec0fa2044e719d10d164916dd0990433"
    sha256 cellar: :any_skip_relocation, ventura:       "263d832da57c7616ae4a7fda972a0537ec0fa2044e719d10d164916dd0990433"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "707c8eba6eb5b7581b9fa36f7a44cb2258f86f7328ad64d5554a68fce73a5f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "707c8eba6eb5b7581b9fa36f7a44cb2258f86f7328ad64d5554a68fce73a5f7b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~JSON
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    JSON
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
