class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/10.17.0/flyway-commandline-10.17.0.tar.gz"
  sha256 "caefd51fdb73e033baf005ea6206c7d7bbd58074470ca7b296ea403564bc30e2"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7285589d303093ebae880102dd965b3be8ec76662d42827b83b4af357c378b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7285589d303093ebae880102dd965b3be8ec76662d42827b83b4af357c378b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7285589d303093ebae880102dd965b3be8ec76662d42827b83b4af357c378b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "69241e4860c7d1bcb5e16ff2f7e0f694b5c281e19f94117227bd0651ad930a6b"
    sha256 cellar: :any_skip_relocation, ventura:        "69241e4860c7d1bcb5e16ff2f7e0f694b5c281e19f94117227bd0651ad930a6b"
    sha256 cellar: :any_skip_relocation, monterey:       "9f3527f5bd5e1d8a6afd0034c7836759944a3fe9ca555b3f66423351783c19de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "481783a77a0818d83239885f18b125aa96cb64c1b8e255de281a037d08461441"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", Language::Java.overridable_java_home_env
  end

  test do
    system "#{bin}/flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end
