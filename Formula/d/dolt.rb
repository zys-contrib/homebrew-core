class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "15a6c8069f2ba00ebf9f11718c054fa58a4b5f4c98b5899a11e8c3579d37b9ca"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c693900f14fe2d3bde1511c066fbdac5f80f18536bc759cbb5ccc93c0363cd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc611610b2da3c338babd1061e2c7cb0e255091cb7b6ef90d0f3bda89793a849"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb1a611b371e5bc34507ab60741273b9c7707a8b74db822877a08bc77608adda"
    sha256 cellar: :any_skip_relocation, sonoma:         "d64acff089b24e7c43da68f219d19881225c63d31ef2290d420b9f2843cf61d3"
    sha256 cellar: :any_skip_relocation, ventura:        "b9f32d87f757ad3894db8b97b705bdcc4133de5ca9d6b1c95e29ed9bad4fe702"
    sha256 cellar: :any_skip_relocation, monterey:       "30c8454cde66b03f94fd497e2bb8ca8d40c035aaabf4c00e471de3fd942db963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96bef9db1ecde48e1086125da8b0c492bbbd68d67b174e42a6a7d6fbe776a71b"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
