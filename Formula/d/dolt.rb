class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.53.4.tar.gz"
  sha256 "d49410b8e07153fec9c7e26e321767706d1d713b9b204ebfa9358e0dd05e403b"
  license "Apache-2.0"
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec0991ea7fbaef708934e434fe8e28f48cca1efbbb4e54fc71d7d8125e0e1c92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ef716e363fd48b8e75a6d0b65e5859e8174c5d7c45caec8d2cca39499cd2495"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5f53b9fd9652d0679037ea78c18bd0229d4d62bf1969fc0721b2461a0df514f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c68dd6649983b3bfba2f5ffc05771d2998d17e9fa36e46d0721cf573ba9b5181"
    sha256 cellar: :any_skip_relocation, ventura:       "5a053c5e356c8fd724de3a692eaf19d75740ec16dd59ce92d8cbacf079adf603"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95d8e6a96c893abf26af871ed73851ff066fde78eb9a533c808fe7fb06a57d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ab795084d55d81d64fc032bdff598219d427e00c5787e14f67b1469c28a4b83"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  def post_install
    (var/"log").mkpath unless (var/"log").exist?
    (var/"dolt").mkpath
  end

  service do
    run [opt_bin/"dolt", "sql-server"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
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
