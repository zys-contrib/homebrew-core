require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.34.0.tgz"
  sha256 "0cab27ed0cb415cd7411f1ad32fb539202755a0ad7e8496033f4448011e5ccad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c213666a60d7dc6a477f0552396589fbe6d0e02410a4965e5ea8e8489d8b547"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c213666a60d7dc6a477f0552396589fbe6d0e02410a4965e5ea8e8489d8b547"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c213666a60d7dc6a477f0552396589fbe6d0e02410a4965e5ea8e8489d8b547"
    sha256 cellar: :any_skip_relocation, sonoma:         "7bb601a5739e84d72bed8f67c6984cdfc08d1bb637f814832418421d530ad279"
    sha256 cellar: :any_skip_relocation, ventura:        "7bb601a5739e84d72bed8f67c6984cdfc08d1bb637f814832418421d530ad279"
    sha256 cellar: :any_skip_relocation, monterey:       "7c213666a60d7dc6a477f0552396589fbe6d0e02410a4965e5ea8e8489d8b547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc84653091f7513901f4e41388e5383b03399fe5da3f09a4ef9cc9997723daa2"
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
