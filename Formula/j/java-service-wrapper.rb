class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.60_20241102/wrapper_3.5.60_src.tar.gz"
  sha256 "877896e14f375c0c881c3a50f8ee910bc6504b388fbbfe65128e79d763d08717"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42546aa39dbdb2b9d5feebca3bd30ed59c2b670820b75656687a7bc6b499d8a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfc916da6dab2ba80be5b9c1c2a059c3faceb43fbe6b3b6f11fbd2c687179514"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "456932779eafcff80ba5af62f8fc39dde78c8aa43ec7fad22e54ebd973ff92e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aeac6598fb9e5846713be61e6e2ba9615b3bae5eacbfdebb66d81ad85c6a5dc"
    sha256 cellar: :any_skip_relocation, ventura:       "7fb3083e15a6e97c975342669b73f15c88f8cc5b5b3a75b3202a939626117463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "873539f87543ccc1140bd5d2eee6cae4528f0b5081962155a255bdf1dacb0e88"
  end

  depends_on "ant" => :build
  depends_on "openjdk" => [:build, :test]

  on_linux do
    depends_on "cunit" => :build
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home

    # Default javac target version is 1.4, use 1.8 which is the minimum available on newer openjdk
    system "ant", "-Dbits=64", "-Djavac.target.version=1.8"

    libexec.install "lib", "bin", "src/bin" => "scripts"

    if OS.mac?
      if Hardware::CPU.arm?
        ln_s "libwrapper.dylib", libexec/"lib/libwrapper.jnilib"
      else
        ln_s "libwrapper.jnilib", libexec/"lib/libwrapper.dylib"
      end
    end
  end

  test do
    ENV["JAVA_HOME"] = java_home = Language::Java.java_home

    output = shell_output("#{libexec}/bin/testwrapper status", 1)
    assert_equal "Test Wrapper Sample Application (not installed) is not running.\n", output

    (testpath/"bin").install_symlink libexec/"bin/wrapper"
    cp libexec/"scripts/App.sh.in", testpath/"bin/helloworld"
    chmod "+x", testpath/"bin/helloworld"
    inreplace testpath/"bin/helloworld" do |s|
      s.gsub! "@app.name@", "helloworld"
      s.gsub! "@app.long.name@", "Hello World"
    end

    (testpath/"conf/wrapper.conf").write <<~INI
      wrapper.java.command=#{java_home}/bin/java
      wrapper.java.mainclass=org.tanukisoftware.wrapper.WrapperSimpleApp
      wrapper.jarfile=#{libexec}/lib/wrapper.jar
      wrapper.java.classpath.1=#{testpath}
      wrapper.java.library.path.1=#{libexec}/lib
      wrapper.java.additional.auto_bits=TRUE
      wrapper.java.additional.1=-Xms128M
      wrapper.java.additional.2=-Xmx512M
      wrapper.app.parameter.1=HelloWorld
      wrapper.logfile=#{testpath}/wrapper.log
    INI

    (testpath/"HelloWorld.java").write <<~JAVA
      public class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    JAVA

    system "#{java_home}/bin/javac", "HelloWorld.java"
    assert_match <<~EOS, shell_output("bin/helloworld console")
      jvm 1    | WrapperManager: Initializing...
      jvm 1    | Hello, world!
      wrapper  | <-- Wrapper Stopped
    EOS
  end
end
