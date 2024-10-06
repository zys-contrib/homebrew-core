class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.0.0.tgz"
  sha256 "702bd87d608ac9a7fb7c1e728a51392f4210b0b0b64e8a3f9e37130bce7ced48"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "267a3263230daae41cba738d7ef6ecd3318cca4d9678c6d65bfa67589792d1c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "053d8f7070f38272319fc1511e1c54658202dcea894554672b56cb594f5a7fe1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "053d8f7070f38272319fc1511e1c54658202dcea894554672b56cb594f5a7fe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "053d8f7070f38272319fc1511e1c54658202dcea894554672b56cb594f5a7fe1"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf72d0b39d9c95a68ef4295f6b34a20371b9c87a28034006dac62ca91ba4a2a5"
    sha256 cellar: :any_skip_relocation, ventura:        "cf72d0b39d9c95a68ef4295f6b34a20371b9c87a28034006dac62ca91ba4a2a5"
    sha256 cellar: :any_skip_relocation, monterey:       "cf72d0b39d9c95a68ef4295f6b34a20371b9c87a28034006dac62ca91ba4a2a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73873bdd8ac8c7c485b023b292095eb410acacef4b1c0db5a6678889078914b0"
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
