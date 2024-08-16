class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.42.12.tar.gz"
  sha256 "0a0a6dae75c567d0d6f650acc11e89aa2e591c24b8940b84d825b162ae3c9de9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1410de6513a1465c688aa3f6c502d4684e9a3f6fa5c45caa48c2f53caaf3f053"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcd4a28e8c18f80293a5eebb869433226d77303e1e3d89de727a6cc71130712a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bea745f28b7b7e0a9399cdc8e4a5b4390512dcf6eff46dd91834a9d441c4211f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0923e6424a59a2c74faaae2b4d9feac14c668258f8817b130c623d723adca35"
    sha256 cellar: :any_skip_relocation, ventura:        "89ff6b82030a43fffc9b8022066b7ff900a078189f0800dd41fe371a0e4cddad"
    sha256 cellar: :any_skip_relocation, monterey:       "0c30d958ab10ae69e705b816f126ceeaf199d1d7794b477f242c6ed83ce337b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c01734c23640d00a566a0b59677f58f6e79b47fe68ade9daa5374d5de2e3eff9"
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
