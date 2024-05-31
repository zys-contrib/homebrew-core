class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases%2F7.2.0/pmd-dist-7.2.0-bin.zip"
  sha256 "2dfee533351069816870c3fc1ea3b3089f0fea602748b0d8ab9db1f0c381ded2"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8cab947b4f6623dc3c1640d15ca207ddc17250fe120f686ce1d623d5dfb690b4"
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
