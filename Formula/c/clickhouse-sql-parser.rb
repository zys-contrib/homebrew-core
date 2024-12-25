class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "0bce0941f40efb0386508fcf5f8a3831f81550122c0a4d262713751ac2fea907"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d699cd4f90e59082620169ff3522bc95d02c8700623c1d9843bd9307dbfeca24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d699cd4f90e59082620169ff3522bc95d02c8700623c1d9843bd9307dbfeca24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d699cd4f90e59082620169ff3522bc95d02c8700623c1d9843bd9307dbfeca24"
    sha256 cellar: :any_skip_relocation, sonoma:        "db4513225472cff1ccbf7b72ed557b4205fd96cbf9a6d77226bfa79963f44147"
    sha256 cellar: :any_skip_relocation, ventura:       "db4513225472cff1ccbf7b72ed557b4205fd96cbf9a6d77226bfa79963f44147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e0680e25898cff9bc8e4db3ca8297f81e9bbec7017d7f953616cfdf224f45b6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/clickhouse-sql-parser -format \"SELECT 1\"")
    assert_match "SELECT 1", output
  end
end
