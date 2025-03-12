class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.2.37.tgz"
  sha256 "3b829128a3f907d7935c530bef60b248d1dee858583277d717c50d5c15825460"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5a98ecd572bbf424a88844358fec217ee00a45930e3a96d810f509b2775e025d"
    sha256 cellar: :any,                 arm64_sonoma:  "5a98ecd572bbf424a88844358fec217ee00a45930e3a96d810f509b2775e025d"
    sha256 cellar: :any,                 arm64_ventura: "5a98ecd572bbf424a88844358fec217ee00a45930e3a96d810f509b2775e025d"
    sha256 cellar: :any,                 sonoma:        "a2e24ba3213280bdd6ec58e28adb39272324674fd0afcf04ee89d0f4d53a6f95"
    sha256 cellar: :any,                 ventura:       "a2e24ba3213280bdd6ec58e28adb39272324674fd0afcf04ee89d0f4d53a6f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5669c97a9f18b929b3c55cad5cb67e6be325c5a72da1383c39d5513bc5a1b6e5"
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
