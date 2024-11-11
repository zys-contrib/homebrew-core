class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-2.5.0/apache-opennlp-2.5.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-2.5.0/apache-opennlp-2.5.0-bin.tar.gz"
  sha256 "2e0891f2518b2194e1ec23fb63d40d1fa8971f6a3fc8df5b20edecc7e39c1138"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "42cf0a7445e9c93111baffa1bed63d57fddd3c73dce8fbdb33d9a741cefa2061"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"opennlp").write_env_script libexec/"bin/opennlp", JAVA_HOME:    Formula["openjdk"].opt_prefix,
                                                            OPENNLP_HOME: libexec
  end

  test do
    assert_equal "Hello , friends", pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends").lines.first.chomp
  end
end
