class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v2024.12.07/structurizr-cli.zip"
  sha256 "3c22f0820f92496514030e7e99af234cac710ade373f157dd3dc8abe3bc7af37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "19340dc955170ef3a78b2005896c37905cb44ad5cfb28e1caae9c0450ebd7f13"
  end

  depends_on "openjdk"

  def install
    rm(Dir["*.bat"])
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = shell_output("#{bin}/structurizr-cli validate -w /dev/null", 1)
    assert_match "/dev/null is not a JSON or DSL file", result

    assert_match "structurizr-cli: #{version}", shell_output("#{bin}/structurizr-cli version")
  end
end
