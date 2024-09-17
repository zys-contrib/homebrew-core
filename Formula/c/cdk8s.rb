class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.220.tgz"
  sha256 "b5a656c14b34d42c08db75530d5cd727ae3052c5dc775ca8d0432e6df81179e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed070f352c70a217abe931425fdec62cfb11a91691999abf2a7972c7040d6577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed070f352c70a217abe931425fdec62cfb11a91691999abf2a7972c7040d6577"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed070f352c70a217abe931425fdec62cfb11a91691999abf2a7972c7040d6577"
    sha256 cellar: :any_skip_relocation, sonoma:        "a32c39b40c05bfeea22fadb8a11bc729e775f9c731554295dd0320f389756e3a"
    sha256 cellar: :any_skip_relocation, ventura:       "a32c39b40c05bfeea22fadb8a11bc729e775f9c731554295dd0320f389756e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed070f352c70a217abe931425fdec62cfb11a91691999abf2a7972c7040d6577"
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
