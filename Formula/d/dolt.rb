class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.41.1.tar.gz"
  sha256 "de861b3b674161b1400855e0b67a26d2374942f4da061c2d28dbba573a89ccdd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "631e00a2a907ec95ec8c46db0662a870f8cb71b6425b42696c2139511029ddf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fd72790cb7cc1ef0b93a10c2434549b212e725d692528c59cab23cef162ef8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66af7a4dda344ed99f7907222bde9430d8c1362fb114006adec07a58a26e4d5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a699dbb1dce8cec740f2ab025ed2f79029da859082df7bd0263b6e82790d48a8"
    sha256 cellar: :any_skip_relocation, ventura:        "0ad8b1f77f862739a07a894e2ad6b065e96275ab567fb61f57a7500ed5e5e737"
    sha256 cellar: :any_skip_relocation, monterey:       "acc14bebea89c97e71ff711c4e599c2611588f1280ecfd73ed1bbc18083cdd5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "284d40f86c20b62182fcc2d287405214167e55500d66622fa58a662503bbe795"
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
