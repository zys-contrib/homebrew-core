class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.2.8.tgz"
  sha256 "02d809b348f86544a1eefdfab542d706076ff3dd0fa4ca8005466e77b95c861b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e18b6658b95ab0af250557f3c8ee468ff1cc517773b9662acfce94da1a6ab25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e18b6658b95ab0af250557f3c8ee468ff1cc517773b9662acfce94da1a6ab25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e18b6658b95ab0af250557f3c8ee468ff1cc517773b9662acfce94da1a6ab25"
    sha256 cellar: :any_skip_relocation, sonoma:        "b81980d4fd24835ccfa20fd4f4bb8b9df8c056c2f6143884848eafa81d2876fe"
    sha256 cellar: :any_skip_relocation, ventura:       "b81980d4fd24835ccfa20fd4f4bb8b9df8c056c2f6143884848eafa81d2876fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75deb09f00d5f5c18a97d35ce283573032d858e776f8054b0d87dbf3d13aadcd"
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
