class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://docs.structurizr.com/cli"
  url "https://github.com/structurizr/cli/releases/download/v2025.03.28/structurizr-cli.zip"
  sha256 "9bb9073c7387bc4f9c50f33075d87d151ca35aa1bf1b97187fcc19d70dc55dbe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b1f56cc195d53fedbe73472c9e7033a281d02350538e00a7e77a88e58b8b75e6"
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
