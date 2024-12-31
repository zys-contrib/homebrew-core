class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.2.12.tgz"
  sha256 "c9d9f71c82ef4e8c90948f87634c3d70ccb43c80111100478c9ad8cbe7acc412"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd89dd088d0900fb85cdab5c223032333e4b8677a16f0f2c8403ff8a8f59fdce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd89dd088d0900fb85cdab5c223032333e4b8677a16f0f2c8403ff8a8f59fdce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd89dd088d0900fb85cdab5c223032333e4b8677a16f0f2c8403ff8a8f59fdce"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2f2be44c756169e788bc0915c27aa89dacdd8d61a7c030050456ac9e2de78ec"
    sha256 cellar: :any_skip_relocation, ventura:       "d2f2be44c756169e788bc0915c27aa89dacdd8d61a7c030050456ac9e2de78ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3d21d16a9dda085543ab794bef13781b7f3207656b3c675c94c2b3750fd616d"
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
