class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.108/bee-1.108.zip"
  sha256 "ce6206ef8a23046f79bd96cd894886f31bb199f4070a08183d0e423bb76d811d"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aeec7d4184e245f4f567dcc86e8df481bbb0c345fe2aa10f4d489cab451c9b60"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin/*.bat"])
    libexec.install Dir["*"]
    (bin/"bee").write_env_script libexec/"bin/bee", Language::Java.java_home_env
  end

  test do
    (testpath/"bee.properties").write <<~EOS
      test-database.driver=com.mysql.jdbc.Driver
      test-database.url=jdbc:mysql://127.0.0.1/test-database
      test-database.user=root
      test-database.password=
    EOS
    (testpath/"bee").mkpath
    system bin/"bee", "-d", testpath/"bee", "dbchange:create", "new-file"
  end
end
