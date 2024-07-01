require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.9.tgz"
  sha256 "53e8c9ec26c7e1d6cb703ded3e4477c1586e9c324d024ed55375ff80b161bcae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ffd07c883232e3ab21ea85d7ed45384103ffc1f83a1684f217bfcafbc950b46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ffd07c883232e3ab21ea85d7ed45384103ffc1f83a1684f217bfcafbc950b46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ffd07c883232e3ab21ea85d7ed45384103ffc1f83a1684f217bfcafbc950b46"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ffd07c883232e3ab21ea85d7ed45384103ffc1f83a1684f217bfcafbc950b46"
    sha256 cellar: :any_skip_relocation, ventura:        "6ffd07c883232e3ab21ea85d7ed45384103ffc1f83a1684f217bfcafbc950b46"
    sha256 cellar: :any_skip_relocation, monterey:       "6ffd07c883232e3ab21ea85d7ed45384103ffc1f83a1684f217bfcafbc950b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d30dc5ad4ef32176ae2b10948c0129c02d47b25ba2b0569b626ffa383ee7e9e4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end
