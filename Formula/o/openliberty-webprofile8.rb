class OpenlibertyWebprofile8 < Formula
  desc "Lightweight open framework for Java (Jakarta EE Web Profile 8)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/24.0.0.7/openliberty-webProfile8-24.0.0.7.zip"
  sha256 "a5d188a8a48ea3bbe8dc3e9357e889f2c46f4d7eece867ecb5c983234890819a"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c91ef5993566ec27eb27a62e465f9c8215ba2ec46d812ae33eba3885c2bdfd9a"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/**/*.bat"]

    libexec.install Dir["*"]
    (bin/"openliberty-webprofile8").write_env_script "#{libexec}/bin/server",
                                                     Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Open Liberty Jakarta EE Web Profile 8 is:
        #{opt_libexec}
    EOS
  end

  test do
    ENV["WLP_USER_DIR"] = testpath

    begin
      system bin/"openliberty-webprofile8", "start"
      assert_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    ensure
      system bin/"openliberty-webprofile8", "stop"
    end

    refute_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    assert_match "<feature>webProfile-8.0</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
