class Repopack < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repopack"
  url "https://registry.npmjs.org/repopack/-/repopack-0.1.40.tgz"
  sha256 "a1244266568f637f8f132ec566d4922cbd2fd3f95163a2b9576b12d1fe9e4162"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repopack --version")

    (testpath/"test_repo").mkdir
    (testpath/"test_repo/test_file.txt").write("Test content")

    output = shell_output("#{bin}/repopack #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match <<~EOS, (testpath/"repopack-output.txt").read
      ================================================================
      Repository Structure
      ================================================================
      test_file.txt

      ================================================================
      Repository Files
      ================================================================

      ================
      File: test_file.txt
      ================
      Test content
    EOS
  end
end
