class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.50.3.tar.gz"
  sha256 "78fa6d2fc965bcaa7c8931eefea6f49a80a0825a1dbb4e57952c57bbe5233097"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4af7d826059b3c05cdfce940cee27a9291e13cae7ff495c44d3ed54cc5f75430"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb81e2a8e702558617fa587d1ef5ea878ec0d1a2d6f0a138e4b6a0a15edd7bda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e3582fa35a5920e218a3283fda7e783c3761506295182ebd27990fd5c990484"
    sha256 cellar: :any_skip_relocation, sonoma:        "ace43f28c9f437f91de16a0623e133d02a9131c2a0423208b03cf51152dec1de"
    sha256 cellar: :any_skip_relocation, ventura:       "0609d7db73944e3b2f8f8211c6491017455666596d40a5e87a97df5b5cbf4b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cfa0c3f6f411739b9c115a335bb6d62b364fc9f03a70d3fe54212aed43e0937"
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
