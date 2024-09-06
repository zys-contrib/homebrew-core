class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.209.tgz"
  sha256 "339fcbc736b137613964da5dd5431c1639046e61bfaf8160be0772d3c6920720"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51db8c42615d7a84a76b442e303435f9f0ebdfcbc4bff78dbc8497e4d8d6e11d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51db8c42615d7a84a76b442e303435f9f0ebdfcbc4bff78dbc8497e4d8d6e11d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51db8c42615d7a84a76b442e303435f9f0ebdfcbc4bff78dbc8497e4d8d6e11d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3292753bd9a7a1cb823d56b30d728d8af188ae8fde4aefe9c2268ed57f3967fc"
    sha256 cellar: :any_skip_relocation, ventura:        "3292753bd9a7a1cb823d56b30d728d8af188ae8fde4aefe9c2268ed57f3967fc"
    sha256 cellar: :any_skip_relocation, monterey:       "3292753bd9a7a1cb823d56b30d728d8af188ae8fde4aefe9c2268ed57f3967fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51db8c42615d7a84a76b442e303435f9f0ebdfcbc4bff78dbc8497e4d8d6e11d"
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
