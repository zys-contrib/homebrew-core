require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.5.tgz"
  sha256 "bdf5b82543f630c9ef92b91c145e07af1ee72de4e294d1fe67025c6b3d8b4f56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec5db3fd94fb066c524751b92b772994b1c4c835e09163a422da96d84ef5174c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec5db3fd94fb066c524751b92b772994b1c4c835e09163a422da96d84ef5174c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec5db3fd94fb066c524751b92b772994b1c4c835e09163a422da96d84ef5174c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec5db3fd94fb066c524751b92b772994b1c4c835e09163a422da96d84ef5174c"
    sha256 cellar: :any_skip_relocation, ventura:        "ec5db3fd94fb066c524751b92b772994b1c4c835e09163a422da96d84ef5174c"
    sha256 cellar: :any_skip_relocation, monterey:       "ec5db3fd94fb066c524751b92b772994b1c4c835e09163a422da96d84ef5174c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "873580ce9d6f76254e30486fca667f0dcfc6449e30f9893a6f13fa4569e8bf44"
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
