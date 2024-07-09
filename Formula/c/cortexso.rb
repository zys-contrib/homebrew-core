require "language/node"

class Cortexso < Formula
  desc "Drop-in, local AI alternative to the OpenAI stack"
  homepage "https://jan.ai/cortex"
  url "https://registry.npmjs.org/cortexso/-/cortexso-0.1.1.tgz"
  sha256 "48efc16761eebfdd60e50211049554e7b781b30e56461042c6bf100e84d8d244"
  license "Apache-2.0"
  head "https://github.com/janhq/cortex.git", branch: "dev"

  bottle do
    sha256                               arm64_sonoma:   "603541444d5e2c2c49057a3f847d5b5138f83ec14e9048743636ab598f0f0835"
    sha256                               arm64_ventura:  "016e6b942350f1712ae95152bd74178b51297b45b6ab5737f5fde0f4d6bfee75"
    sha256                               arm64_monterey: "36ae8f2a9b21aacaf97c24ddb11eba0be72fcfd1d136b04d06aa9601076c7103"
    sha256                               sonoma:         "236a3bfc8d6d5f9d04336b3ae30c2a9d0f17edc1b5e3f90c209c746972c5fda6"
    sha256                               ventura:        "57c9518227cbc44e3723f66f54d7794863310905635eb182ff02c0954b3cb8cb"
    sha256                               monterey:       "6e40acad0fed2c2e9122dfab590a62f7d689176fcd804af4181469027e3341f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "771ea24e5640bf6eba8fd81a4499acc2b2fea6db7912abbff406dd28c2943b25"
  end

  depends_on "node"

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/cortexso/node_modules/cpu-instructions/prebuilds"
    node_modules.each_child do |dir|
      dir.rmtree if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    port = free_port
    pid = fork { exec bin/"cortex", "serve", "--port", port.to_s }
    sleep 10
    begin
      assert_match "OK", shell_output("curl -s localhost:#{port}/v1/health")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
