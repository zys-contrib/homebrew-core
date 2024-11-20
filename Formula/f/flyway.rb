class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/10.22.0/flyway-commandline-10.22.0.tar.gz"
  sha256 "6cd8a61c54d5141bbb4ccbd6fc5418c545ccad906fa016806efe515a01f2b428"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "57fef8124dc5fb273b841b4d3fe2bd24777ff26839366335e1d9bb388da88ba2"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", Language::Java.overridable_java_home_env
  end

  test do
    system bin/"flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end
