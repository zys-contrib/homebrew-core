class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.7.4.tgz"
  sha256 "5d1ea849bd5f45c25c48c55308eccd0182648f9313a811282ce01cc2dc7d39b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65dd69e53ef5646f99ef98968367583ef18b52d951c18a28a3c17928dacf032e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65dd69e53ef5646f99ef98968367583ef18b52d951c18a28a3c17928dacf032e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65dd69e53ef5646f99ef98968367583ef18b52d951c18a28a3c17928dacf032e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6617e1c394fd11d811c1c3933e62e038636711a5c1dcf958d23104bfee10511c"
    sha256 cellar: :any_skip_relocation, ventura:        "6617e1c394fd11d811c1c3933e62e038636711a5c1dcf958d23104bfee10511c"
    sha256 cellar: :any_skip_relocation, monterey:       "6617e1c394fd11d811c1c3933e62e038636711a5c1dcf958d23104bfee10511c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65dd69e53ef5646f99ef98968367583ef18b52d951c18a28a3c17928dacf032e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    sql_file = testpath/"test.sql"
    sql_file.write <<~EOS
      CREATE TABLE "staff" (
        "id" INT PRIMARY KEY,
        "name" VARCHAR,
        "age" INT,
        "email" VARCHAR
      );
    EOS

    expected_dbml = <<~EOS
      Table "staff" {
        "id" INT [pk]
        "name" VARCHAR
        "age" INT
        "email" VARCHAR
      }
    EOS

    assert_match version.to_s, shell_output("#{bin}/dbml2sql --version")
    assert_equal expected_dbml, shell_output("#{bin}/sql2dbml #{sql_file}").chomp
  end
end
