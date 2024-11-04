class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/8.1.4/bazel-diff_deploy.jar"
  sha256 "725e4012d8f68ecbe967138bc973bf0bca22b2b219a34cafbd3e392fb451b2e6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "59438feaf0ce17fdb0ae5f9f639ec1f7cd1fb4ce0a326e6000bc1c754b2fb8f4"
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
