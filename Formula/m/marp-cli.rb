class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.0.2.tgz"
  sha256 "68fc87f159b13e2a4c0910ccb2d7abea08028e6738fa3da709fd1d78c9699f10"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3eaaff943910ed984fc62b77c0b394dd6fc13048e3c99a61d8c414682575bb65"
    sha256 cellar: :any,                 arm64_sonoma:  "3eaaff943910ed984fc62b77c0b394dd6fc13048e3c99a61d8c414682575bb65"
    sha256 cellar: :any,                 arm64_ventura: "3eaaff943910ed984fc62b77c0b394dd6fc13048e3c99a61d8c414682575bb65"
    sha256 cellar: :any,                 sonoma:        "54ddb5fa883c988061fec80a18b6a62a8fe227cfc8cfe6dc9935bc4ce3f62681"
    sha256 cellar: :any,                 ventura:       "54ddb5fa883c988061fec80a18b6a62a8fe227cfc8cfe6dc9935bc4ce3f62681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6083fa389e9f5382ed91ff29d1c1c8b931dcae88744b186b40ecd9f9ab079cd4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@marp-team/marp-cli/node_modules"
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    (testpath/"deck.md").write <<~EOS
      ---
      theme: uncover
      ---

      # Hello, Homebrew!

      ---

      <!-- backgroundColor: blue -->

      # <!--fit--> :+1:
    EOS

    system bin/"marp", testpath/"deck.md", "-o", testpath/"deck.html"
    assert_predicate testpath/"deck.html", :exist?
    content = (testpath/"deck.html").read
    assert_match "theme:uncover", content
    assert_match "<h1 id=\"hello-homebrew\">Hello, Homebrew!</h1>", content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end
