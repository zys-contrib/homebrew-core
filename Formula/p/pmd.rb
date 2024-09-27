class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases%2F7.6.0/pmd-dist-7.6.0-bin.zip"
  sha256 "e07f7a9c3607d643509a96d7f5f891961e98ea88b6eba85d120d08f0c08c985e"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d937c7207bcec7e95bfd21f1f4cccf3bd6fcd97062c18a000ab8703518434709"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (bin/"pmd").write_env_script libexec/"bin/pmd", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"java/testClass.java").write <<~EOS
      public class BrewTestClass {
        // dummy constant
        public String SOME_CONST = "foo";

        public boolean doTest () {
          return true;
        }
      }
    EOS

    output = shell_output("#{bin}/pmd check -d #{testpath}/java " \
                          "-R category/java/bestpractices.xml -f json")
    assert_empty JSON.parse(output)["processingErrors"]
  end
end
