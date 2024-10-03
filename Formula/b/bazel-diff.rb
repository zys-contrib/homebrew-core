class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/7.2.5/bazel-diff_deploy.jar"
  sha256 "13fdde1ec55015f51a77f6a96f7e5c5a52f2a4023dab395e52381bb14b782944"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83fe9957a0ffa44797753d7f10058ae4def8c4151d61085abe1472255279f5bc"
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
