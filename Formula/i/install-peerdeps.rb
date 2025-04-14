class InstallPeerdeps < Formula
  desc "CLI to automatically install peerDeps"
  homepage "https://github.com/nathanhleung/install-peerdeps"
  url "https://registry.npmjs.org/install-peerdeps/-/install-peerdeps-3.0.7.tgz"
  sha256 "b161e9e3e497cd492e571393784232a9ac9e4518044cda909f7e1d09c4fb5ea7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "679fc964017ac26ac7bea5d6662dcce74a754e608725b92e0e0ee73124638f28"
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
