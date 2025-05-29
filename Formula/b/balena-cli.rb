class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.0.4.tgz"
  sha256 "f2d3af9ec7f8d3b71eb8444f00b154159310cfa559154fa0e7e1b33b82ef91c1"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "743dde167a5e8a6cc5d25c5252c793424f2fa4338a89bd19b53372eb19fcd0c1"
    sha256                               arm64_sonoma:  "e69c22e323be2099a6aa7cf195c034bd27f9842b45e7e651b7b4ab5af8d34251"
    sha256                               arm64_ventura: "73b3add980233a3acfc4a1b745eb69878e81cf0add183900a3d94dbdf0c5995f"
    sha256                               sonoma:        "6a29b42eddc4fe09712f216c4b162d9e369fb9b1cb99660be382facfbbb9bd5c"
    sha256                               ventura:       "0cdd69028ce375e41becb03e23f16ee6092345b8adc074552a7291846b49b97e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "729f4a4ffd7dc546b0de395ecb8a1c34f2de8d70995ef214745b1e69e03a9d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e8f328837cc22ac31663672b33aae0cfab7778b7002d251b1ded6f392c061f2"
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
