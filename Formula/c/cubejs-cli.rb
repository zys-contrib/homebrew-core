require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.49.tgz"
  sha256 "2b99c9bb2e24215ccca9655a0feb21cec10d078bf6dfce51878d9aab7d81c1d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d75a307568740965208bd8554ab88ad142a5e3b4bbde59bb156c9eaddb7f9d0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d75a307568740965208bd8554ab88ad142a5e3b4bbde59bb156c9eaddb7f9d0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d75a307568740965208bd8554ab88ad142a5e3b4bbde59bb156c9eaddb7f9d0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5613cec105c03b4d352d051fef6cbdb3cb0388f4b238db9dfbea55c24c4b32bd"
    sha256 cellar: :any_skip_relocation, ventura:        "5613cec105c03b4d352d051fef6cbdb3cb0388f4b238db9dfbea55c24c4b32bd"
    sha256 cellar: :any_skip_relocation, monterey:       "5613cec105c03b4d352d051fef6cbdb3cb0388f4b238db9dfbea55c24c4b32bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2b75d2a8a325167128081162f19b23c837759a935825fba9880a3b631253f1e"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
