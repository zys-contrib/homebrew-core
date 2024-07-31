class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.6.1.tgz"
  sha256 "d6eef86bd841dac598b7641d725f1932ef3dc0f87e6047bdf552defca9262f48"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26a00a46ccb9f40b84fc56ab59f4c9dc08f84e836e203068e7166a9b3bdb8ae1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26a00a46ccb9f40b84fc56ab59f4c9dc08f84e836e203068e7166a9b3bdb8ae1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26a00a46ccb9f40b84fc56ab59f4c9dc08f84e836e203068e7166a9b3bdb8ae1"
    sha256 cellar: :any_skip_relocation, sonoma:         "411ebc2decc79803251343de21b7111459208b6c051f6da94a95fe08f787285e"
    sha256 cellar: :any_skip_relocation, ventura:        "411ebc2decc79803251343de21b7111459208b6c051f6da94a95fe08f787285e"
    sha256 cellar: :any_skip_relocation, monterey:       "411ebc2decc79803251343de21b7111459208b6c051f6da94a95fe08f787285e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4a12bebf91b927d725ff200a5ef73c537deaffb3993433368d7886e8ec83f8a"
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
