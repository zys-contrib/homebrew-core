class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/10.15.0/flyway-commandline-10.15.0.tar.gz"
  sha256 "c3a5c9e8ac362347708d795259375c68b56683d5bbef49956801460cf6cfe6b7"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "108d97e8d25d859c50df8e9948e724132923b9562060603b4247d0e98fe95438"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "108d97e8d25d859c50df8e9948e724132923b9562060603b4247d0e98fe95438"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "108d97e8d25d859c50df8e9948e724132923b9562060603b4247d0e98fe95438"
    sha256 cellar: :any_skip_relocation, sonoma:         "108d97e8d25d859c50df8e9948e724132923b9562060603b4247d0e98fe95438"
    sha256 cellar: :any_skip_relocation, ventura:        "108d97e8d25d859c50df8e9948e724132923b9562060603b4247d0e98fe95438"
    sha256 cellar: :any_skip_relocation, monterey:       "108d97e8d25d859c50df8e9948e724132923b9562060603b4247d0e98fe95438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97a71d4224f85c5c20e024166be237d7d95196a9099867d27abbb3a0a1603795"
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
