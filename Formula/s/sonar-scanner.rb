class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/"
  url "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-6.1.0.4477.zip"
  sha256 "6928d282b22381d37865c725293f8d03613f81104bc2461ed3318fac2f345cdc"
  license "LGPL-3.0-or-later"
  head "https://github.com/SonarSource/sonar-scanner-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0cf45694c4683b4ffd2735c79433b954d7c531496255f3396a8ef6678ba301e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0cf45694c4683b4ffd2735c79433b954d7c531496255f3396a8ef6678ba301e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0cf45694c4683b4ffd2735c79433b954d7c531496255f3396a8ef6678ba301e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0cf45694c4683b4ffd2735c79433b954d7c531496255f3396a8ef6678ba301e"
    sha256 cellar: :any_skip_relocation, ventura:        "c0cf45694c4683b4ffd2735c79433b954d7c531496255f3396a8ef6678ba301e"
    sha256 cellar: :any_skip_relocation, monterey:       "c0cf45694c4683b4ffd2735c79433b954d7c531496255f3396a8ef6678ba301e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dc9079487bbc35160e68c4c9fab52d391e3381eb91d8ce781538b2ec7763c49"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install libexec/"bin/sonar-scanner"
    etc.install libexec/"conf/sonar-scanner.properties"
    ln_s etc/"sonar-scanner.properties", libexec/"conf/sonar-scanner.properties"
    bin.env_script_all_files libexec/"bin/",
                              SONAR_SCANNER_HOME: libexec,
                              JAVA_HOME:          Formula["openjdk"].opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sonar-scanner --version")
  end
end
