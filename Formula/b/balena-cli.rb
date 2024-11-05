class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-20.0.4.tgz"
  sha256 "d70acfabc1807a0ab4cb4249a7b95dfe4d5e165214a98fadd3e7d46c3ea55b28"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "d253de2c2809bbc2e6d27f9a52d1f6a16982bbf84ae270bea6f59e3ca2c86fd7"
    sha256                               arm64_sonoma:  "e7e55f9fa2f2dcb5086d10af9fc70d661924c35aaccce00212dd91a418da9a46"
    sha256                               arm64_ventura: "1fa87c786f8a16101c3b51fb80931d7bf0a4155265800caf10175b0100c90f3b"
    sha256                               sonoma:        "7aef830e3aa97cfb4c49d451ce0fdfc321b0378ec3f9c940703eaa5a9f709e6d"
    sha256                               ventura:       "1f13c736a19f6f491d7ca54c6278012ac5e96ef9ee0f882da58cf30267eb7203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "555d515e1d0ac461332dc6d8567b322e237d038ac57dc02079a0e16550e0aafc"
  end

  # need node@20, and also align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@20"

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules/"lzma-native/build")
    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
