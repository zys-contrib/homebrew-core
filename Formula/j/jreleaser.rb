class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.13.1/jreleaser-1.13.1.zip"
  sha256 "c384888b61fd99ba3a3d3366a20ca5bb63e6ec054eb2841490ede5762d87ae59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c76ebad8e530a48dbf24be456b479bf53858b427a577cd2e972aeb621d312e86"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"jreleaser").write_env_script libexec/"bin/jreleaser", Language::Java.overridable_java_home_env
  end

  test do
    expected = <<~EOS
      [INFO]  Writing file #{testpath}/jreleaser.toml
      [INFO]  JReleaser initialized at #{testpath}
    EOS
    assert_match expected, shell_output("#{bin}/jreleaser init -f toml")
    assert_match "description = \"Awesome App\"", (testpath/"jreleaser.toml").read

    assert_match "jreleaser #{version}", shell_output("#{bin}/jreleaser --version")
  end
end
