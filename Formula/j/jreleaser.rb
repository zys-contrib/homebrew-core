class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.16.0/jreleaser-1.16.0.zip"
  sha256 "7216a8b70616cf0554326db9bf704832f4fe67d4e370b2111629e50a6f9a04da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8ad750ca4d977614f20d0cc94bb43e01fda61c5abe41be3f3e658073ced1b66e"
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
