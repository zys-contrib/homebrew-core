class Fileql < Formula
  desc "Run SQL-like query on local files instead of database files using the GitQL SDK"
  homepage "https://github.com/AmrDeveloper/FileQL"
  url "https://github.com/AmrDeveloper/FileQL/archive/refs/tags/0.8.0.tar.gz"
  sha256 "3ff4541e28e385a97848a818884121a6cc1c80e2ee5ec11dff3c93b3215c85ef"
  license "MIT"
  head "https://github.com/AmrDeveloper/FileQL.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = JSON.parse(shell_output("#{bin}/fileql -o json -q 'SELECT (1 * 2) AS result'"))
    assert_equal "2", output.first["result"]
  end
end
