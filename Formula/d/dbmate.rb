class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "2fb78ed466505f20a4b060b8e103c6010bf788a4445b19ec1f0e5589739fc659"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39b2bfe372ddaf3e7b4c97534ce5233ed59efdc20633d95bb02355975e0e9cd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c591afef8e2843dfd6a625ef37f6c3fba8c6776f73d23c265534561405ffd99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db6a88519af372e4cc9bd9ec5a3cedcb9d23c1b36d003e0cbc6036950477debe"
    sha256 cellar: :any_skip_relocation, sonoma:        "55e8d777e6763236e5fae0e92eeda00c235824616f798fda3a1e4a5010e3d728"
    sha256 cellar: :any_skip_relocation, ventura:       "cf53970ff5c6220317dcbc8349095d0d96cefeaa00e082966f4a8e9d643dc2ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44cc479ec057c4c858468219a0cae0cb95426f2a28aa0e1fc27094c7bc290a44"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "sqlite_omit_load_extension,sqlite_json"
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_path_exists testpath/"test.sqlite3", "failed to create test.sqlite3"
  end
end
