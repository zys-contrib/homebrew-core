class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "049603a7d08508b218f22e2067c4d5f18f890a211df393d3aefa7c4324f20052"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9871d734efa99739d5920319155a5f009a995627b6b9a761ad5183e48d2d697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba6126641658e22264612a0d00dd6bd3ea90be6a2b68f406d4d039d78d13b1a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81e77a015e04bc8cf7b6ba41bb8c82e4bc78f664f3ba94cca91d0bf308dc2c3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0308c0fcc960b5fa9d115ca90b90634cf7367d94a99dab78073920cc13946b8b"
    sha256 cellar: :any_skip_relocation, ventura:       "542738a5e66daa42c8266d2523b2741800599d1a2743abd0f6dd000492e33fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "704c735ee11a89de6c38341d7da43bc01d32dc2351f3b2d644f230ffdc241565"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test

  def install
    system "./postgres/parser/build.sh"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/doltgres"
  end

  test do
    port = free_port

    (testpath/"config.yaml").write <<~YAML
      log_level: debug

      behavior:
        read_only: false
        disable_client_multi_statements: false
        dolt_transaction_commit: false

      listener:
        host: localhost
        port: #{port}
        read_timeout_millis: 28800000
        write_timeout_millis: 28800000
    YAML

    fork do
      exec bin/"doltgres", "--config", testpath/"config.yaml"
    end
    sleep 5

    psql = Formula["libpq"].opt_bin/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end
