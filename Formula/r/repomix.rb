class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.2.7.tgz"
  sha256 "4706a6dd8391dda26bbd98e750a283b2a461d23bbeb439a32835735c7e2cd5b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70ce7324dbee72c3b5b90eeb7068dcac4701966615f474f392e09206029cebd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70ce7324dbee72c3b5b90eeb7068dcac4701966615f474f392e09206029cebd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70ce7324dbee72c3b5b90eeb7068dcac4701966615f474f392e09206029cebd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "639b6c1ace70ad9ab9f127d87031513dd4119619c39b1db49aab8083e12da585"
    sha256 cellar: :any_skip_relocation, ventura:       "639b6c1ace70ad9ab9f127d87031513dd4119619c39b1db49aab8083e12da585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e7431c1fd7649e29aa06df34a714a6a6b8b7dd6457cdb102fcde088ef0e02c2"
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
    assert_match <<~EOS, (testpath/"repomix-output.txt").read
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
