class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-21.1.0.tgz"
  sha256 "5dc536aa47514bed0186fc92697ecfffd7519411f7cd6615c0bcb4978e8188e1"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "12d238a82fdf362ea2f0fbae90f78cb331cfa1fbcd03558e47999538c6b08bb8"
    sha256                               arm64_sonoma:  "27f01f2791a72a0190c361ce319a5b9c8afe819b63afa1dd5627bf37c1ad20d6"
    sha256                               arm64_ventura: "83d227ef6aa73fb1a542b38ff78cfc8789b691652e53f1f63ecbf3a44b2c8364"
    sha256                               sonoma:        "69b91c2c810308c6f38393243678505bc850a8ef37f9c71316f42c1e63695753"
    sha256                               ventura:       "6c4852d09edcb665adefe5d6c1050cfad56228c5c8c4ab2b864fa163ae60fdd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "143826c8848d696482fafb0acd595e71f940e0eba35dd66cd1d2334a1ec32fa0"
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
