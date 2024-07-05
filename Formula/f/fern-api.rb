require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.14.tgz"
  sha256 "8db188f8306e8729483f19b819460bbe8848717e8466f09000882546a01701cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da25e84908616788062b0ab5f8673e97e2727cc867a6d6c8445b46212261d2d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da25e84908616788062b0ab5f8673e97e2727cc867a6d6c8445b46212261d2d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da25e84908616788062b0ab5f8673e97e2727cc867a6d6c8445b46212261d2d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f01f562ee2037cf1b2c73b3a0ebf7d995c3060300b48a0419997daea615d6a7"
    sha256 cellar: :any_skip_relocation, ventura:        "7f01f562ee2037cf1b2c73b3a0ebf7d995c3060300b48a0419997daea615d6a7"
    sha256 cellar: :any_skip_relocation, monterey:       "da25e84908616788062b0ab5f8673e97e2727cc867a6d6c8445b46212261d2d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6977c7d0613bfa593ce82b16ee03c5aad876496f6cf03dc9edd47a89ac5eae82"
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
