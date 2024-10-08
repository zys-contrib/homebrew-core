class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/7.2.16/bazel-diff_deploy.jar"
  sha256 "5d447e3f71d1d1e253bd78233c9989e1078b0fd6c453a6d594a4fda7f6fd483f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a475afd5b51cc9dedd075a324771290fe12be0b8dc4952dc1d3507b68b447ab"
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
