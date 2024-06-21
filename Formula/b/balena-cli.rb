require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-18.2.6.tgz"
  sha256 "21c85a365dce96ef7a21fa476a76c5f38e33227590d94ca47c67fbf8eb2d275c"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "8924355456bafb0025de7efa2299c6e238f9a055cd1b7bec130696218f56a10c"
    sha256                               arm64_ventura:  "aed000c5676d4f913abd86ec403b962fb0228e6bdd00e56518c7b6e74c018578"
    sha256                               arm64_monterey: "94e59cc738d3959489d6cf99ba370fd946d3161726a1378cf4e6947e3a3aae6a"
    sha256                               sonoma:         "a8e9c9a98d89cb64e5925c7d3ff96622fe92c40cb855e26a49588a47f5b4fbba"
    sha256                               ventura:        "30ff495c3fa372f0131ffb8d3fd7431975d50d6cef51df124b7cecc95a7b6fba"
    sha256                               monterey:       "80e9f33d31fe395f1f675b504c7430b6e9152b66badf1c2e5c09ac1b8db53a4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fea231e832b3f0c195d0fc70b7aec1411c2d9887a333dcb4ea4c0a568cbafe45"
  end

  # need node@20, and also align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@20"

  on_macos do
    depends_on "macos-term-size"
  end

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    (node_modules/"lzma-native/build").rmtree
    (node_modules/"usb").rmtree if OS.linux?

    term_size_vendor_dir = node_modules/"term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir

      unless Hardware::CPU.intel?
        # Replace pre-built x86_64 binaries with native binaries
        %w[denymount macmount].each do |mod|
          (node_modules/mod/"bin"/mod).unlink
          system "make", "-C", node_modules/mod
        end
      end
    end

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    ENV.prepend_path "PATH", Formula["node@20"].bin

    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
