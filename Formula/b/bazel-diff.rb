class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/7.3.0/bazel-diff_deploy.jar"
  sha256 "4a49ddcfc42f90d49a7ad94d762ec8bbce56c33f8095adb925bde0d5c9e58eb1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "278943bb5fc54569ed9be5dcafda4c938d1a25771001db204e0afddd5b2e68e8"
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
