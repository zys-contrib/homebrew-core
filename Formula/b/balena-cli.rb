class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-19.12.0.tgz"
  sha256 "f70a5e30320380bcb700258221cc7fd1cf8cf97cdbf25622bc96469ad5742bd6"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "4afe539463e5121e61f2b9bebc1721ea7b18ab034f3207d56592b87fee8da40b"
    sha256                               arm64_sonoma:  "c6c7affc5f5eb141529e6707a63b11dd197b93c5176b91abd549b19f37e51d72"
    sha256                               arm64_ventura: "1e8f3a49502665babaa02d7ee3e7d52a522289e0689258d093afda813307568c"
    sha256                               sonoma:        "2eb705eb8c39d3182545fc48e84b9c5f2461a58bd5c1e325b2283239c69b05f0"
    sha256                               ventura:       "16a7f3ef0492f0eccf9c1a2357780a9dfd9fa2917c7b5053ae9bb923475a962a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80bb673d674a41f79a49ae6b2625d227cbdf35558428d13e26e66be4d8c8d8a7"
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
