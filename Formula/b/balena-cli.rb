class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-19.15.0.tgz"
  sha256 "8e221793db2e6460cddf6648c083263e5cd1a801f6a09937df5f7d54dd0efa6d"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "03105f71fa0151ca453d660cf408a43d47ef074fb645f0e62c2f16d978958c03"
    sha256                               arm64_sonoma:  "dce5eefaabf8ea691e5ab13477f1fdd1a1dfc504d62ad8bb223a3ace96d03a4f"
    sha256                               arm64_ventura: "152b9f792f23f46d2f631df7670bea76d620854aa561b5d1c5494e4c27f92ffe"
    sha256                               sonoma:        "7e7da67c4ac9e3fbbae6608e232b64b52bbf845e6e5b33862a499d9e339a5733"
    sha256                               ventura:       "b31d3c87db4194f2ded79dad790f18214691f54ab698f7929d93366af07fe640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc0499ab4b541c455ce9e9f7edefd494296fa46ae81dae076acc459f21610be6"
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
