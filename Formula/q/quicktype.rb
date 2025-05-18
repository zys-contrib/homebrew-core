class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/glideapps/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.2.5.tgz"
  sha256 "ec650d3904d4c16e3aee13b0611db6ff9d4a4ce68cb3d2294981eda75107b2dd"
  license "Apache-2.0"
  head "https://github.com/glideapps/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4346ae14635697841509c059a615d790614242f29818d7fbdfa77ce6a69bf7b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4346ae14635697841509c059a615d790614242f29818d7fbdfa77ce6a69bf7b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4346ae14635697841509c059a615d790614242f29818d7fbdfa77ce6a69bf7b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a94db57533c94e5c099ea1d22f3de6544591af60b99a08d4456e42d04f733be"
    sha256 cellar: :any_skip_relocation, ventura:       "2a94db57533c94e5c099ea1d22f3de6544591af60b99a08d4456e42d04f733be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4346ae14635697841509c059a615d790614242f29818d7fbdfa77ce6a69bf7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4346ae14635697841509c059a615d790614242f29818d7fbdfa77ce6a69bf7b4"
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
