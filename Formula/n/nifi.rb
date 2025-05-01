class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.4.0/nifi-2.4.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.4.0/nifi-2.4.0-bin.zip"
  sha256 "3937c5b1a6fbd28be4b2aab5b588d19993b8d2a416970f18a81d5fe2e330550f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c8b8f5ca37382ed05872957a5b1d282558b374473b853fe925b0e746c3776682"
  end

  depends_on "openjdk@21"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("21").merge(NIFI_HOME: libexec)

    # ensure uniform bottles
    inreplace libexec/"python/framework/py4j/java_gateway.py", "/usr/local", HOMEBREW_PREFIX
  end

  test do
    system bin/"nifi", "status"
  end
end
