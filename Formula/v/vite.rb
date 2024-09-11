class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.4.4.tgz"
  sha256 "b2385f966f345223d894a34aca9ab46ce0764a34d80d00f2ac81abe3fa0516e8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8b98ca833876b1c56dbd34c4a4ff46d2cadc5ed95ee73f50410dbe38c264fbb4"
    sha256 cellar: :any,                 arm64_sonoma:   "4879bb91d4809c4885c3bcd2e4bd858191657e5281fca6b63686a2697454116b"
    sha256 cellar: :any,                 arm64_ventura:  "4879bb91d4809c4885c3bcd2e4bd858191657e5281fca6b63686a2697454116b"
    sha256 cellar: :any,                 arm64_monterey: "4879bb91d4809c4885c3bcd2e4bd858191657e5281fca6b63686a2697454116b"
    sha256 cellar: :any,                 sonoma:         "410ab2140af2e4f1d56acd7766eaf659ac7d97ab225e06b7408782be765bf034"
    sha256 cellar: :any,                 ventura:        "410ab2140af2e4f1d56acd7766eaf659ac7d97ab225e06b7408782be765bf034"
    sha256 cellar: :any,                 monterey:       "410ab2140af2e4f1d56acd7766eaf659ac7d97ab225e06b7408782be765bf034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c7b3fe9cc2b036b52b86a7b47359b32f82703fd1dda37a50511f557ac4653a6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
