require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.2.13.tgz"
  sha256 "314792d2c86a216451f8abc4a992f8e9c0b1f1963ce77a6ec8b93d628bc25508"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0f2c47247d0f4e627d4e923e0cc079ca9f74edc482b2d1c593e7e0170dd5fcfc"
    sha256 cellar: :any,                 arm64_ventura:  "0f2c47247d0f4e627d4e923e0cc079ca9f74edc482b2d1c593e7e0170dd5fcfc"
    sha256 cellar: :any,                 arm64_monterey: "0f2c47247d0f4e627d4e923e0cc079ca9f74edc482b2d1c593e7e0170dd5fcfc"
    sha256 cellar: :any,                 sonoma:         "7ef414665180cccacf2e52166da2047d6814e4167c08e09fda723752acfe844c"
    sha256 cellar: :any,                 ventura:        "7ef414665180cccacf2e52166da2047d6814e4167c08e09fda723752acfe844c"
    sha256 cellar: :any,                 monterey:       "7ef414665180cccacf2e52166da2047d6814e4167c08e09fda723752acfe844c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f352ceda2769abbcea1e3edbb2bec0af85fa3371c020237b44351be87c4b99ab"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
