class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-20.2.6.tgz"
  sha256 "81a0fa9521399cb0a1a8706c47b6ab651ecb79ff5bd4f609d459d052cedc1594"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "9be05972044d25cf29cf6c231da2a433556b241ff1ddce5283dab55b0593c3f3"
    sha256                               arm64_sonoma:  "423b2380fb332c3327194867621398dc651a045548ecabfba0a0959cc5bc3dc7"
    sha256                               arm64_ventura: "482b80bcface03be88d6d773fb72bce722338b1256afc623e5b0147a68721c5a"
    sha256                               sonoma:        "90d83743191c2b43e97f3a57012b380bb44eeaf353d35d36a753bdc9188c11e1"
    sha256                               ventura:       "39d8b58a4b7c01eb3a87bb4e9680ba40a750a8ac469ee0fac35670c070d2f105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebecb04afa6c7055aa6d559e7cf501756f56ad9f17062607d9bfcd3bbd1ce614"
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
