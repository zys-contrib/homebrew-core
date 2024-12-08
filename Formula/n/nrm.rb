class Nrm < Formula
  desc "NPM registry manager, fast switch between different registries"
  homepage "https://github.com/Pana/nrm"
  url "https://registry.npmjs.org/nrm/-/nrm-2.0.0.tgz"
  sha256 "8c295be621adbf110135dd6203d509a5f04d35285490cacf7c50bb697bf46fca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5ead4ca891de6d93c95dcf893a88232bf71e493096e7e2fc67a1e26aedd9ebf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5ead4ca891de6d93c95dcf893a88232bf71e493096e7e2fc67a1e26aedd9ebf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5ead4ca891de6d93c95dcf893a88232bf71e493096e7e2fc67a1e26aedd9ebf"
    sha256 cellar: :any_skip_relocation, sonoma:        "6433d8408e134553298348779a9d67f1362607e814797f71a4e5a5845aae7451"
    sha256 cellar: :any_skip_relocation, ventura:       "6433d8408e134553298348779a9d67f1362607e814797f71a4e5a5845aae7451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5ead4ca891de6d93c95dcf893a88232bf71e493096e7e2fc67a1e26aedd9ebf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "SUCCESS", shell_output("#{bin}/nrm add test http://localhost")
    assert_match "test --------- http://localhost/", shell_output("#{bin}/nrm ls")
    assert_match "SUCCESS", shell_output("#{bin}/nrm del test")
  end
end
