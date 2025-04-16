class Cortexso < Formula
  desc "Drop-in, local AI alternative to the OpenAI stack"
  homepage "https://jan.ai/cortex"
  url "https://registry.npmjs.org/cortexso/-/cortexso-0.1.1.tgz"
  sha256 "48efc16761eebfdd60e50211049554e7b781b30e56461042c6bf100e84d8d244"
  license "Apache-2.0"
  head "https://github.com/janhq/cortex.git", branch: "dev"

  bottle do
    rebuild 1
    sha256                               arm64_sequoia:  "c5b000f80754025ef2e26c62a74172b0b70dbde1217544f602d29e933f221b6e"
    sha256                               arm64_sonoma:   "5a40692000193b98c8274e0f4b6cd366558fc464e91fbc9222af2e16b4238b2b"
    sha256                               arm64_ventura:  "e505143e5417668b3027c83e923871bacbbaf5ac0a86bde0e0b156bfad7e0c36"
    sha256                               arm64_monterey: "0d30abe3e770dc4596348ba52c39bdeadbc270d61213a563c8f655c694858362"
    sha256                               sonoma:         "33d3271364280efa43bdf39ff61532e4e6f1ec5e1d0a2c3e9c70695cd6f5977f"
    sha256                               ventura:        "9dc575f5fcdb463e7fd8e00159329fe29080b76e3c563de647c90b2affaf9141"
    sha256                               monterey:       "30aa7c29ce75ef1429af1393073d4970a6b101bad2ddc638164e9b22cbb6b54e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f02d924016dcab7dce2faecaac5a77ba04ad4ba20dcac3e0fcc753d248364264"
  end

  depends_on "node"
  depends_on "sqlite" # needs sqlite3_enable_load_extension

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
  end

  conflicts_with "cortex", because: "both install `cortex` binaries"

  def install
    system "npm", "install", "--sqlite=#{Formula["sqlite"].opt_prefix}", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace pre-built binaries
    rm_r(libexec/"lib/node_modules/cortexso/node_modules/cpu-instructions/prebuilds")
    cd libexec/"lib/node_modules/cortexso/node_modules/cpu-instructions" do
      system "npm", "run", "build"
      Pathname.glob("prebuilds/*/cpu-instructions.node").map { |f| f.rename(f.dirname/"cpuinfo.node") }
    end
  end

  test do
    port = free_port
    pid = fork { exec bin/"cortex", "serve", "--port", port.to_s }
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    begin
      assert_match "OK", shell_output("curl -s localhost:#{port}/v1/health")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
