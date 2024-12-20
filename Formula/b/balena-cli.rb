class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-20.1.3.tgz"
  sha256 "e759a7f75e2558582553c5ceb7848af548b7e7e8e38fb6aed964f5d59a2b4826"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "1b54bc683dae52a8b7db63ce21b081db1053dc0d621c6b726de38e73942bdc45"
    sha256                               arm64_sonoma:  "981cee22a7c48714a2979f62f702c21b3a3b3738567fa6343551c46ee29977eb"
    sha256                               arm64_ventura: "48e72dbbbcf18e1e62e6c8c09cd47dbb6bf66c4ebc910be73fc983f608d074d6"
    sha256                               sonoma:        "b7a494fded200ac9a6aa0777a4f75d5d17281bda1d862df92690175fa69715bd"
    sha256                               ventura:       "c82efece3faaaad842ae001b877cb12522b42ad737c19069c495e49928d1674c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "053ed11a77bcc8d46b1c916f19c504e509b0cbd38cc2bdc593a1a0116ed25de6"
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
