class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/2.0.3/orc-tools-2.0.3-uber.jar"
  sha256 "d21d15a0c44cc3c0b48a3951ee7377ee2af2ca58cb72bf31cf8ac1179703c194"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4a902d30ecf17f68855819623ed89a239b4b59cb1bb3d0fcd9ca452569396730"
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
