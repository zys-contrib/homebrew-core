class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://github.com/bluesoft/bee/releases/download/1.104/bee-1.104.zip"
  sha256 "b0f1ab8daf944fcb80c85ec9939bf830dbb0aab9231c217e360a41ea012d12f2"
  license "MPL-1.1"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "99eb856182015001c6458a1b1010d14f2330f92e616da5388e6e64e191b81c76"
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
