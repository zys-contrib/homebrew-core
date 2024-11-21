class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-4.0.0/apache-pulsar-4.0.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-4.0.0/apache-pulsar-4.0.0-src.tar.gz"
  sha256 "5c3bd7c14167b388e1efc05e8a45c693a2ca056e56d5a069fee7bfd0c6168dac"
  license "Apache-2.0"
  head "https://github.com/apache/pulsar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "84d3eaf420f61cf8d8c1f51dbdc1ad6fcacb1b1631dd22b241ced620b2fa4f91"
    sha256 cellar: :any_skip_relocation, ventura:      "eaca256d0c8f8152e8696142aae0d0aed390adb7ecb7349e2d61c228c38f4f07"
    sha256 cellar: :any_skip_relocation, monterey:     "b01912fe86d28f7c4be6d79134b80d93829ac0e172e9743f4c96ad1d3ddc4028"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3d0a75a7e0c5167a2407a0a20b090eb6859e44374a95ec4c41a468e6627b2a70"
  end

  depends_on "maven" => :build
  depends_on arch: :x86_64 # https://github.com/grpc/grpc-java/issues/7690
  depends_on "openjdk@21"

  def install
    java_home_env = Language::Java.java_home_env("21")
    with_env(TMPDIR: buildpath, **java_home_env) do
      system "mvn", "clean", "package", "-DskipTests", "-Pcore-modules"
    end

    tarball = if build.head?
      Dir["distribution/server/target/apache-pulsar-*-bin.tar.gz"].first
    else
      "distribution/server/target/apache-pulsar-#{version}-bin.tar.gz"
    end

    libexec.mkpath
    system "tar", "--extract", "--file", tarball, "--directory", libexec, "--strip-components=1"
    pkgshare.install libexec/"examples"
    (etc/"pulsar").install_symlink libexec/"conf"

    rm libexec.glob("bin/*.cmd")
    libexec.glob("bin/*") do |path|
      next if !path.file? || path.fnmatch?("*common.sh")

      (bin/path.basename).write_env_script path, java_home_env
    end
  end

  def post_install
    (var/"log/pulsar").mkpath
  end

  service do
    run [opt_bin/"pulsar", "standalone"]
    log_path var/"log/pulsar/output.log"
    error_log_path var/"log/pulsar/error.log"
  end

  test do
    ENV["PULSAR_GC_LOG"] = "-Xlog:gc*:#{testpath}/pulsar_gc_%p.log:time,uptime:filecount=10,filesize=20M"
    ENV["PULSAR_LOG_DIR"] = testpath
    ENV["PULSAR_STANDALONE_USE_ZOOKEEPER"] = "1"

    spawn bin/"pulsar", "standalone", "--zookeeper-dir", "#{testpath}/zk", "--bookkeeper-dir", "#{testpath}/bk"
    # The daemon takes some time to start; pulsar-client will retry until it gets a connection, but emit confusing
    # errors until that happens, so sleep to reduce log spam.
    sleep 45

    output = shell_output("#{bin}/pulsar-client produce my-topic --messages 'hello-pulsar'")
    assert_match "1 messages successfully produced", output
    output = shell_output("#{bin}/pulsar initialize-cluster-metadata -c a -cs localhost -uw localhost -zk localhost")
    assert_match "Cluster metadata for 'a' setup correctly", output
  end
end
