class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.219.tgz"
  sha256 "95449e680da17a800763ba0fe9e62aea6aca1b08077739f0d58ed1243792613c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb97c4f87a2f7e632bb424e497de73b397378b624076512c26591f346125f97c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb97c4f87a2f7e632bb424e497de73b397378b624076512c26591f346125f97c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb97c4f87a2f7e632bb424e497de73b397378b624076512c26591f346125f97c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bb1b5d42e782037f06309b4c6a31835065e5fb65a64bc9859ef4ba5b0995bfc"
    sha256 cellar: :any_skip_relocation, ventura:       "7bb1b5d42e782037f06309b4c6a31835065e5fb65a64bc9859ef4ba5b0995bfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb97c4f87a2f7e632bb424e497de73b397378b624076512c26591f346125f97c"
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
