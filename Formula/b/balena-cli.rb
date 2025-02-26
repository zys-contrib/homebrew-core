class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-20.2.8.tgz"
  sha256 "3dd04d098be2260648a6ae50227a3be2c205f9ee1df1630848457b2f993a5f4d"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "2bd64fc3663ba81556c5a74a1a33e3c0d9d5f31b2a19e26d96f208a2699ef29e"
    sha256                               arm64_sonoma:  "1362aee6f2e266bb8ec7dd11e9e6449f62277024aa8202c8f1bff91b00999c53"
    sha256                               arm64_ventura: "d9f13af3e24f26fcb35c2154baaf138aecda723650d210c5edd2cbcc72b2ee02"
    sha256                               sonoma:        "aacdb800f33c19685a393d60dc8d945b3e885334fbaeba75f427f8e4ae840e0b"
    sha256                               ventura:       "30a65e3302846a3b1597f21166a7a5c53db9afb687225bac0fa54d1325bf14bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e00acfe1e2657ddf2a4f1b0b0d512dcbe06c08096d51bffc6c75cc0897adc50c"
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
