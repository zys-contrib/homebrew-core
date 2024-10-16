class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-19.3.0.tgz"
  sha256 "5b2b65477dee63d9589084a17a6aaf3eece5548afae267d8f290322d01e5a36e"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "a2deed1bb4ee7b21067e71069403cb6f3d60c3e46ddcbc8187c2d99656d7364e"
    sha256                               arm64_sonoma:  "22de1b9ea4a0090ef018a5f0601d565637975419e1705e9de942be128d920243"
    sha256                               arm64_ventura: "c2a71498433d6dab0f4997a5853c9d3c0e360082b0f8ca300796a9581a133193"
    sha256                               sonoma:        "e4528b8b6df23ef7698d6d04444299dc530979df2d849b1f526bdbd87f6517fd"
    sha256                               ventura:       "b0a9963c8f58742ccf7abc3220285c2cfd9755c8f5c678ab2d6332032d9b20eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c76335cc2d023750447450b5d81fa8cc1fcc0f9740006c562deda446fbceeef"
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
