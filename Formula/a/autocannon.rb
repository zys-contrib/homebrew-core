class Autocannon < Formula
  desc "Fast HTTP/1.1 benchmarking tool written in Node.js"
  homepage "https://github.com/mcollina/autocannon"
  url "https://registry.npmjs.org/autocannon/-/autocannon-8.0.0.tgz"
  sha256 "470ac762b261d8eca3d8069be8776b25fc111e4caa962bc144a85e9631fd07fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c7a7bf16826e0b08b168b93a5d73fc798bf1e5e02ab8b7dffa05d3bd767c207"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    output = shell_output("#{bin}/autocannon --connection 1 --duration 1 https://brew.sh 2>&1")
    assert_match "Running 1s test @ https://brew.sh", output

    assert_match version.to_s, shell_output("#{bin}/autocannon --version")
  end
end
