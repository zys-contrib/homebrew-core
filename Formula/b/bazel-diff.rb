class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/7.2.18/bazel-diff_deploy.jar"
  sha256 "542b53c7f0eb319eed3ae115807bd7adc6f1ff590a81e8c0dc660ccff6f08d0f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "937cb9a642360dc74938aabc0de9acb6a78ea1afad9c8737d6d58927b4428cff"
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
