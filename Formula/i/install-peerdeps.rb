class InstallPeerdeps < Formula
  desc "CLI to automatically install peerDeps"
  homepage "https://github.com/nathanhleung/install-peerdeps"
  url "https://registry.npmjs.org/install-peerdeps/-/install-peerdeps-3.0.6.tgz"
  sha256 "b40952d6add99d566db6eb427b313054dc4edfe1c541a801a6bf49062f162451"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "8b8235bb0d694175e47f0dd39cb14fdc1cf9474c25516f37b7f01a216db0d022"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"install-peerdeps", "eslint-config-airbnb@19.0.4"
    assert_path_exists testpath/"node_modules"/"eslint" # eslint is a peerdep
  end
end
