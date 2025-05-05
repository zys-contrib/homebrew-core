class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.3.5.tgz"
  sha256 "083dfbda7d984ea8884c23fc4e9778a0ef647442ecffb599026109d578753c0e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3153775f672c56034763602745fb3331840215456fbc662eca665e7c8e978f0a"
    sha256 cellar: :any,                 arm64_sonoma:  "3153775f672c56034763602745fb3331840215456fbc662eca665e7c8e978f0a"
    sha256 cellar: :any,                 arm64_ventura: "3153775f672c56034763602745fb3331840215456fbc662eca665e7c8e978f0a"
    sha256 cellar: :any,                 sonoma:        "fea78f9e627489dc093a313f137449eb82e21ab9cf7bbe87ac7afa8b6f62e593"
    sha256 cellar: :any,                 ventura:       "fea78f9e627489dc093a313f137449eb82e21ab9cf7bbe87ac7afa8b6f62e593"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2071d39667fcd04028b8d98a84478a0337bad9d3b15464b6a494e9f365237fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ceab0eaed67e713163e43d6cece7904ddc14dae4527cca7e6f6010770da56d9"
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
