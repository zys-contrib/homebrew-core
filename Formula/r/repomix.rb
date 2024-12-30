class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.2.10.tgz"
  sha256 "72cb819188c6e828ced895b1b9af507ec93d0d09fde27d2d49277b252e2466b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00e65b40df840ed19635acbedf686d7d45e363f4170579694877aca7a0102895"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00e65b40df840ed19635acbedf686d7d45e363f4170579694877aca7a0102895"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00e65b40df840ed19635acbedf686d7d45e363f4170579694877aca7a0102895"
    sha256 cellar: :any_skip_relocation, sonoma:        "060c655c38636802361b862f75713efd675fb80232267994642d359f25e7777e"
    sha256 cellar: :any_skip_relocation, ventura:       "060c655c38636802361b862f75713efd675fb80232267994642d359f25e7777e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92adc1e787afc772c82c9d820c061695a0478cf4a27c36b9e56db63bbb1eb0f8"
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
