class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.50.8.tar.gz"
  sha256 "fee08ae5b1e6a04875f0dec4c298734c0bc7d25c6e7c609f9d4df16d8e25a1a8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0cff90d85089455f537589ae6040a6d45a6f6ca569cd23702a98dc5df9c0375"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a6de644b5273a529dc7cc722cc46b45b962896e4b33fbf8577af51fd4b5a2bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd317f02ddef6e564550a5951d4c87d25f95e97c9ad1e68ca61cbc630b021f2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d47eceec24827e7129ab775203cb0e5cfeff6d538fa69d489df78eb174b5c3b1"
    sha256 cellar: :any_skip_relocation, ventura:       "060cae7381c931f0b3b1cd9e31877655ce4e8b2aa4ce061115d25ef1140de340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7133a5ebd07a45238b7bd333cb750b2e3854b983c81e4a231603807c1f0e7027"
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
