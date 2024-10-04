class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/7.2.9/bazel-diff_deploy.jar"
  sha256 "1648d34ccef5aa65dc54fc6390b1acfa1bc5e678264e014f6ae669ca102e1bb8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "da6835537e38737d17723c86bf35575a79841f569c5fab9d75b1fe01c66457f8"
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
