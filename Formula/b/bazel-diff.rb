class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/7.2.3/bazel-diff_deploy.jar"
  sha256 "9a21fbd1322c731f5b21270d6a2da776ac7d02e9c62d9a22b6e1737c9963e059"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d70d9463d52e49bb82a0389512111972d45be22ad1d4c341408c533a9a67e6ab"
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
