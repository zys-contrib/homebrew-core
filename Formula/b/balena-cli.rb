class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-21.1.5.tgz"
  sha256 "601400527704419ff8d6eb7c3cb4bb806b0f389b22f46a40848857f8f97a50f1"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "684af83bee3841408a77979df20e05ce9911a0abdf84703f430a43b03d78fa5e"
    sha256                               arm64_sonoma:  "4229c487146e83cf1749d69f8313f694ee6792b333d97934d54c8f7e973c4e20"
    sha256                               arm64_ventura: "cca11713c869c6402f322f5f22598536348ea0769e06ac1443be847d377c57d7"
    sha256                               sonoma:        "97b5afaa86d46ced18e2538d3717359b667d86324c35f579cbd9e9685167e4a3"
    sha256                               ventura:       "5abf3274cd1c0b6d92586fc50ade90962ea1d8c1ebc95b02007521725b49346f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b96930b9a3b17c1fe7e87eaa35284910c48748c4505ec4c23fa22a45c4e551b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f01c510d92226de947cb98b70408ae06635c7d5fc30c30118dc7d3d93065a08"
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
