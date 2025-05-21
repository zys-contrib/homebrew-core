class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-21.1.14.tgz"
  sha256 "96e25003751cb6c72a44ded3b410303ffcb51d8a6f3b06b55718bc8bf7df07fa"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "a3921edb50348136bd9fe201f547185014aeac4aab2a01808dcd4c535198af32"
    sha256                               arm64_sonoma:  "faa2564060d72d3d39078dbfe7ab2a9052647189b5b10aca79aef93582b766eb"
    sha256                               arm64_ventura: "a8185b8bfec255048cef8fe5c8e066342f16841f10c6a626d945fcb8101f3d21"
    sha256                               sonoma:        "bd09dd55968540e6104789e4d8573220004a486bc847f3f03d681da2931618ce"
    sha256                               ventura:       "c17d5f07db6d2a135bec4f54eecf9919eb4eaf119590ade2ae4354bf4e0b40d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d4cec88d553e5880783600048c866e84cad20763916e08ade13f3c970ea7e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94d65784151c7f8589aa9bb2491d0c5b26bc6b2f87f078078114f726ea7b5679"
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
