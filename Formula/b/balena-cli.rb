class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-19.0.17.tgz"
  sha256 "960fe28932b466ad8972a80f1ac3e2b95c493f51beedd30f105f59b4a3a68524"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "ccfdaab6b15cd9976da61a688db0c4d1e55a15081906ae3621822c23cba40f21"
    sha256                               arm64_sonoma:  "dfca4aad6c612e6dae6a34478d175018056386dd8fe4851e08e525f72a5eb206"
    sha256                               arm64_ventura: "05d4792b6d847be16ad1b7de0fa2fe344b2566bb68af0f277c36b3cbe24b0520"
    sha256                               sonoma:        "22e8ba93cc4464cc510f672f581b82a343830d2de792fa43d8e01be19257efae"
    sha256                               ventura:       "778a508c58a7bfde28d3dccf2ff57a3b507fbb6c8c530968d77c7da614332b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e220e48dbbbcc0ac587f668582498186d616026b619f217b9b1248154350029d"
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
