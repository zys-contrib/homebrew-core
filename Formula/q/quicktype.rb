class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/glideapps/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.1.2.tgz"
  sha256 "0924e180725c6ea5176ad2f45cc1931e5f9bf789118236ccc7325fcd6b4e4ead"
  license "Apache-2.0"
  head "https://github.com/glideapps/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5996f54fdece520f1d039fb5a048b17e7e855719ff49bc4188ff62b986bd1049"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5996f54fdece520f1d039fb5a048b17e7e855719ff49bc4188ff62b986bd1049"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5996f54fdece520f1d039fb5a048b17e7e855719ff49bc4188ff62b986bd1049"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d6f474e694bae9a0708acd5cfd8000301f1a3f8dbbdd5a12d104587bcbfa534"
    sha256 cellar: :any_skip_relocation, ventura:       "6d6f474e694bae9a0708acd5cfd8000301f1a3f8dbbdd5a12d104587bcbfa534"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5996f54fdece520f1d039fb5a048b17e7e855719ff49bc4188ff62b986bd1049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5996f54fdece520f1d039fb5a048b17e7e855719ff49bc4188ff62b986bd1049"
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
