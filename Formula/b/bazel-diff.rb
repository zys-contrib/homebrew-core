class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/8.0.0/bazel-diff_deploy.jar"
  sha256 "b4d4f70efdc345620c8baed77307cb90c8ae568b9f7ae4bcb70263d3fe591793"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5b46b4552ccf794f14e230529856429122836c80d8b4303a463251a276f25ff0"
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
