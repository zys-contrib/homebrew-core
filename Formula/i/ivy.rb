class Ivy < Formula
  desc "Agile dependency manager"
  homepage "https://ant.apache.org/ivy/"
  url "https://www.apache.org/dyn/closer.lua?path=ant/ivy/2.5.3/apache-ivy-2.5.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/ant/ivy/2.5.3/apache-ivy-2.5.3-bin.tar.gz"
  sha256 "3d41e45021b84089e37329ede433e3ca20943cb1be0235390b6ddf4a919a85af"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c42e8ba023f1686707a52c7aedd6379798d1faa80a781f6c8d2b0169cad93888"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["ivy*"]
    doc.install Dir["doc/*"]
    bin.write_jar_script libexec/"ivy-#{version}.jar", "ivy", "$JAVA_OPTS"
  end
end
