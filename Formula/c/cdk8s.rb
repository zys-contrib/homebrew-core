class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.50.tgz"
  sha256 "b7f88e3e9fe00ef2c89869ccf100d8dd966dad1310490f5c44a1d034b23101f4"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cbe17202df88d394ee92bdb7a7a5876dda978c7044d274fc1ef961a089c682a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cbe17202df88d394ee92bdb7a7a5876dda978c7044d274fc1ef961a089c682a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cbe17202df88d394ee92bdb7a7a5876dda978c7044d274fc1ef961a089c682a"
    sha256 cellar: :any_skip_relocation, sonoma:        "89bc7bdf5f32caa2a804d5798c3007bbd9ab0492472d6a7c54c5ddd6cbc515a4"
    sha256 cellar: :any_skip_relocation, ventura:       "89bc7bdf5f32caa2a804d5798c3007bbd9ab0492472d6a7c54c5ddd6cbc515a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cbe17202df88d394ee92bdb7a7a5876dda978c7044d274fc1ef961a089c682a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cbe17202df88d394ee92bdb7a7a5876dda978c7044d274fc1ef961a089c682a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
