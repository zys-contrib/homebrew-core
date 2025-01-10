class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.2.19.tgz"
  sha256 "a30903fae40f95936229d0f385810865a40ac8e393ce476fdc75d5165979576f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f523e817c01dda2968d98eff67a930fa9cdd1e61a8fd6cb5360a46508432af36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f523e817c01dda2968d98eff67a930fa9cdd1e61a8fd6cb5360a46508432af36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f523e817c01dda2968d98eff67a930fa9cdd1e61a8fd6cb5360a46508432af36"
    sha256 cellar: :any_skip_relocation, sonoma:        "12d8c58f698d02054ce4cec77bfcacb2c4e6773ed04cc395ce2225aaba531011"
    sha256 cellar: :any_skip_relocation, ventura:       "12d8c58f698d02054ce4cec77bfcacb2c4e6773ed04cc395ce2225aaba531011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a98429a19cd9d1801e2338cfd768fef2a5ea505b79c5bb77053c3c18d444cb5a"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repomix --version")

    (testpath/"test_repo").mkdir
    (testpath/"test_repo/test_file.txt").write("Test content")

    output = shell_output("#{bin}/repomix #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath/"repomix-output.txt").read
  end
end
