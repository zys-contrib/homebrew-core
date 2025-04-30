class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.18.0/jreleaser-1.18.0.zip"
  sha256 "581b6089f2fecc3eefa33da530df54cbf8e8fe57f2c2c85d8d29d1b111a84424"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "025dff66feb62157bc86f5f3c3103fb9ae3d076ae5dffbf8734752b7606287c4"
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
