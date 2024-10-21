class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-19.13.1.tgz"
  sha256 "0b5f22e8801339855bbd299d2d5588f18bb4736db2224da786359a9a2f7588d8"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "f7325ed115d5bfd2c24162fb8c655f05f2b1bfd7cce804bdc911e68bb33afd45"
    sha256                               arm64_sonoma:  "9674623c26c3b791b36f740d1a24f9bb1c841b85817f6e397494204a3a338377"
    sha256                               arm64_ventura: "dd5d91613f143694b01aeb56ff1e15ce901a4125cc3d7f0333fd75454ca2a636"
    sha256                               sonoma:        "577fea70d4a2dff0f94a2857624492a90c9a5522901453451c58d310ef4e9cc0"
    sha256                               ventura:       "7df41810245741e17a009c40f2ec02b4f14e6b3b7a0c803450ad8019e16ad9f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09a7ae8ec339d15a8e1a0ead09fbb0742a7874e8d361158d336335aaec0d0c2f"
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
