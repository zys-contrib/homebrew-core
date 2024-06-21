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
    sha256                               arm64_sonoma:   "3673855134e6ee266f909448775f307cc3156ab8ca239a86ba87e4dfc7d330f2"
    sha256                               arm64_ventura:  "bcc1b6e770065db4b6c3dd05dc3e3cbbd4e8b85d69318f0e740a0d74b2e1b48d"
    sha256                               arm64_monterey: "d4def8fb36afff6ecb137d69f93f09c9aaf4fe38d2cb853e24f356a0865bcbbe"
    sha256                               sonoma:         "38a6de927bb84a3f8903e9852e6428638383ddb7057e1e4de8b93030c8c3765d"
    sha256                               ventura:        "7765ea435130ffc359b1dbeea917e8342b56e2479ab299154f513b3ae19974d4"
    sha256                               monterey:       "e813271dec0cc8824a7f80a919ef11fa933e0caa4c94becf58f8b41fd124680e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2d211cdc0ed0c8c3f1872b76deb581ae4d1162c6e762abbd1366be9d69df68f"
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
