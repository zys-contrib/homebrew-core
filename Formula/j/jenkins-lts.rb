class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.452.2/jenkins.war"
  sha256 "360efc8438db9a4ba20772981d4257cfe6837bf0c3fb8c8e9b2253d8ce6ba339"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2555992970f2ed1bd3cc04ff672b1ac3665ea1d888a2a8a5ae22c526d02ed963"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2555992970f2ed1bd3cc04ff672b1ac3665ea1d888a2a8a5ae22c526d02ed963"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2555992970f2ed1bd3cc04ff672b1ac3665ea1d888a2a8a5ae22c526d02ed963"
    sha256 cellar: :any_skip_relocation, sonoma:         "2555992970f2ed1bd3cc04ff672b1ac3665ea1d888a2a8a5ae22c526d02ed963"
    sha256 cellar: :any_skip_relocation, ventura:        "2555992970f2ed1bd3cc04ff672b1ac3665ea1d888a2a8a5ae22c526d02ed963"
    sha256 cellar: :any_skip_relocation, monterey:       "2555992970f2ed1bd3cc04ff672b1ac3665ea1d888a2a8a5ae22c526d02ed963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e2109c326f41dfbaf9c347574f40a8e3f2b1b19edb890e1afa29ad456277040"
  end

  depends_on "openjdk@21"

  def install
    system "#{Formula["openjdk@21"].opt_bin}/jar", "xvf", "jenkins.war"
    libexec.install "jenkins.war", "WEB-INF/lib/cli-#{version}.jar"
    bin.write_jar_script libexec/"jenkins.war", "jenkins-lts", java_version: "21"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-lts-cli", java_version: "21"
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  service do
    run [Formula["openjdk@21"].opt_bin/"java", "-Dmail.smtp.starttls.enable=true", "-jar", opt_libexec/"jenkins.war",
         "--httpListenAddress=127.0.0.1", "--httpPort=8080"]
  end

  test do
    ENV["JENKINS_HOME"] = testpath
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    port = free_port
    fork do
      exec "#{bin}/jenkins-lts --httpPort=#{port}"
    end
    sleep 60

    output = shell_output("curl localhost:#{port}/")
    assert_match(/Welcome to Jenkins!|Unlock Jenkins|Authentication required/, output)
  end
end
