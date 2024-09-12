class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-19.0.9.tgz"
  sha256 "04071955981b2c15155a4d1957e12cf56a3e643f91c179ce0fa974efa2ad656e"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "f184c11e9dc082140c65ce833b54374df77e2a8b7e427546dfc76d911344a88d"
    sha256                               arm64_ventura:  "8b1701c8e270c8b98196ac2e5d11d891deccc00acecb80059bc0e39cf6acdb6d"
    sha256                               arm64_monterey: "6a1b70ada689fbeb46400e3427d8ef6885175542bf2e6d8b922e55fb5560b082"
    sha256                               sonoma:         "91285eb8494a35d16114ec661627a5c27bc32053f36de576ee68f339603c7d31"
    sha256                               ventura:        "dff383f42eb892aa84e669a7327d08e93533e5054397c0c29b9d0ca3696ffd92"
    sha256                               monterey:       "9e2877d2a0801a7bd6c31f7ec81e3d8a84d1c8b0ffc9a0c52994469e72ce0816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c71885226254680bc55e6fc47dc383d0520657782a43230e5e9cfddfc184121"
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
