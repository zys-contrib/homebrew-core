require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-18.2.20.tgz"
  sha256 "1130dc754bf07e5df2231b2b9a59b950d045110028bad4f55f03bc7e8d5fb5c5"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "7b9e905558d7bb0fad66d06584112fae522d4e3e42901eccd6b5b837ae642064"
    sha256                               arm64_ventura:  "5ae7dd6bfd403186c5649cf2a81ba023cb546a77b387acdaa156f1f1811e1ec8"
    sha256                               arm64_monterey: "4399988c8f4e2029ace83c779dab94e7cfb233438244af7bb651315c85e498cf"
    sha256                               sonoma:         "ab41bbdb235798c28305b01403fdf6b40894788d949fd6130a39cb0e17ac0af6"
    sha256                               ventura:        "1e2fdd64c981f66105b7a52df79ebbc3bb685c70d8e4c6cbed86719ccc4bcac5"
    sha256                               monterey:       "d93da5af98c9f2e9f82c99461fcdb13991ee1dee62135275bc3ccddd3535ab5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fc23e228cfe1b56e48f6a897b928f51c8bf7d0bdbc969dcbeb72709554dff3b"
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
