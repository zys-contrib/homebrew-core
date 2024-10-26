class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.28.0/nifi-1.28.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.28.0/nifi-1.28.0-bin.zip"
  sha256 "2dabe11972af3b84a697a1705b68a20e4778904081e379c50f023be2636803f7"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9624e6e61bf2fb4b9950109a9d4e5d2fe0a9dbf30cf5b063695f545608c8a1f4"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("11").merge(NIFI_HOME: libexec)
  end

  test do
    system bin/"nifi", "status"
  end
end
