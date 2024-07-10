require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-18.2.23.tgz"
  sha256 "3b5b753ac860ac9d2a2b69b4439b60ac83683785afa2522ae5fad6fdb1fdf649"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "267b0c099d90422cc8d7da6853f61eb9b458767f6185751c2e02ae003c3f55f3"
    sha256                               arm64_ventura:  "22437afe7990430e790b262b4967180a82f55ebc3e46c378085de1da254f5323"
    sha256                               arm64_monterey: "54b4039a8baf2e1c0034a3ca2f3b2e0764552552899c53867b13acf4c5334b8e"
    sha256                               sonoma:         "0bb5c9686d580522c7f4c726dea13b730680b5668e8c89322afbf9de4b03f004"
    sha256                               ventura:        "b47b05a5e7a74491ce8c19f2f05736b60c24088ea600ed2a41d664964aa33236"
    sha256                               monterey:       "ad3eb5525798ff4492a319235a456cb752992a47f24fb53526c700d4cbf36574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "680f2ce4b480fd4a2fe3dbf118ea7b7732f4f93242d8bc91c52694ac87aeac5b"
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
