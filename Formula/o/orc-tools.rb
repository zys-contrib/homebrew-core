class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/2.1.0/orc-tools-2.1.0-uber.jar"
  sha256 "f89fce464e53a64ea0e97ab1c1ef4f8f498e835732b53b299599230d1067e94a"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "29e22587e1b751c03f09357e62b8e2897366e9945cd97f2e2452a859e6d243d9"
  end

  depends_on "openjdk"

  def install
    libexec.install "orc-tools-#{version}-uber.jar"
    bin.write_jar_script libexec/"orc-tools-#{version}-uber.jar", "orc-tools"
  end

  test do
    system bin/"orc-tools", "meta", "-h"
  end
end
