class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/7.2.7/bazel-diff_deploy.jar"
  sha256 "b9b35538aeb94b4a4e52a68e6f6c4b93c8bbc4d590084a6d44b447d810ad2b7b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "38064346bb5c34d1d529662299d52bd35a8fbb8d2d5068ad641f52ad5e716b10"
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
