class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-20.0.1.tgz"
  sha256 "80becbb5cf2265f465920e9be470af414f1e7320a7b2f160a027451921d80eeb"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "1b41d08d6ac2d1a31ce2573d03b9c36b4983cedf54fc06594704a83b5f845530"
    sha256                               arm64_sonoma:  "d3957647dbedcbdf8699ef92c72ea19e887780873befe38b8448814f62897540"
    sha256                               arm64_ventura: "3e28f42c9e87a3268e09618f303d231a4e0b9e6d0ad42c7efc58fb1c2e1f5ee5"
    sha256                               sonoma:        "bd485a3128b86ce60f95ffbd5fb63a028f0e01acae02abcac4c1ed87e5eaed5f"
    sha256                               ventura:       "cab9ed8101ae54462b102bdda856f54c6ae4cfb4951c5cf2e8b814fd6cf5543c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9286e2b134c8f2b3485e482d2ee69a00228b567909e6b7109ec94440d2236cfb"
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
