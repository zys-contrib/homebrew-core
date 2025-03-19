class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.50.7.tar.gz"
  sha256 "21232b8f2deac2676a3b219ddc34911041b5112dc5b99cfd229804284dc0b9bb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9218f574e6dcef2c7cc2d00425f45c754ff5dc1b8966ebca57c7c918a04069b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02c3e3fb8577418b89f2333f818019d2dd5bafdad48bb035b8f62e7886a4a64c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e205286dc696127020d5539f6482a4d7f34ec676a0ecf492bfc8b654c6b6675b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d9f687b98b161369819815aaf02aa286c7cbde0505452de43d3fee8d3b49b18"
    sha256 cellar: :any_skip_relocation, ventura:       "f804e2a6311d72af3dc0d629beb3a00d630df715f14eca77ba1579c31f129894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc404a14665df40f103bc7dc0bcbe0c8e966048111dd12ae134e22775dbbe937"
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
