class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/8.1.2/bazel-diff_deploy.jar"
  sha256 "190adb4df2c4862423b2cb828c322d4815fa5c18d859cc1563144180cf5e4ceb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb562a7013f2f4d5119f43df12fe5871247fded6a1bdbe7d5dd08f01195a3efb"
  end

  depends_on "bazel" => :test
  depends_on "openjdk"

  def install
    libexec.install "bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end
