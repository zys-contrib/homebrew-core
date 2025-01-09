class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.45.5.tar.gz"
  sha256 "dbf1d7847682d4c955282082cec0e7691a5156e21e6cf1ce19fec61241ae5002"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a9d5debf526b48642925d6249cc3efc22b898fa82359a76eba770f292956da3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48347a0202b810845819511e01c0c2fb1fe467092bc1dd1db4cf1d8823574e68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acbff905c822175545652bb839367d48a8a554490f9e0566b8cbe3246fb14b28"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a08b2dc4246e2f9f0d366a24223bc89d8f6269d72be28651451e8f33aa6cc87"
    sha256 cellar: :any_skip_relocation, ventura:       "6173331ccdd3719196e9db81807b956864b7f9240347b350d4522137c114bb60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "433e77749e8bf8eb60fb5d44907aa366409fb7488fb4101e740f94df23363f4e"
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
