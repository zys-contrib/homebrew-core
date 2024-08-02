class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=flink/flink-1.20.0/flink-1.20.0-bin-scala_2.12.tgz"
  mirror "https://archive.apache.org/dist/flink/flink-1.20.0/flink-1.20.0-bin-scala_2.12.tgz"
  version "1.20.0"
  sha256 "708fd544ccf9ddc0d4b192fe035797ce16de2c26f1d764c55907305efe140af0"
  license "Apache-2.0"
  head "https://github.com/apache/flink.git", branch: "master"

  livecheck do
    url "https://flink.apache.org/downloads/"
    regex(/href=.*?flink[._-]v?(\d+(?:\.\d+)+)-bin[^"' >]*?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93e6c996d8ec26b5968a684fc2e6ba3146eab2eb8b541ebb5dbb71fce24cd490"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93e6c996d8ec26b5968a684fc2e6ba3146eab2eb8b541ebb5dbb71fce24cd490"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93e6c996d8ec26b5968a684fc2e6ba3146eab2eb8b541ebb5dbb71fce24cd490"
    sha256 cellar: :any_skip_relocation, sonoma:         "93e6c996d8ec26b5968a684fc2e6ba3146eab2eb8b541ebb5dbb71fce24cd490"
    sha256 cellar: :any_skip_relocation, ventura:        "93e6c996d8ec26b5968a684fc2e6ba3146eab2eb8b541ebb5dbb71fce24cd490"
    sha256 cellar: :any_skip_relocation, monterey:       "93e6c996d8ec26b5968a684fc2e6ba3146eab2eb8b541ebb5dbb71fce24cd490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ad88b00bff78ce4a347abfb4e93248aa8e27c2f58a235c790e6eb9b271a9896"
  end

  depends_on "openjdk@11"

  def install
    inreplace "conf/config.yaml" do |s|
      s.sub!(/^env:/, "env.java.home: #{Language::Java.java_home("11")}\n\\0")
    end
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/flink"
  end

  test do
    (testpath/"log").mkpath
    (testpath/"input").write "foo bar foobar"
    expected = <<~EOS
      (foo,1)
      (bar,1)
      (foobar,1)
    EOS
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"
    ENV.prepend "FLINK_LOG_DIR", testpath/"log"
    system libexec/"bin/start-cluster.sh"
    system bin/"flink", "run", "-p", "1",
           libexec/"examples/streaming/WordCount.jar", "--input", testpath/"input",
           "--output", testpath/"result"
    system libexec/"bin/stop-cluster.sh"
    assert_predicate testpath/"result", :exist?
    result_files = Dir[testpath/"result/*/*"]
    assert_equal 1, result_files.length
    assert_equal expected, (testpath/result_files.first).read
  end
end
