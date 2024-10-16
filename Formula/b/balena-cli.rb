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
    sha256                               arm64_sequoia: "3b4f421ac06c2558c786aff4d533677b6743f5bd04868d2f9bf2f34eee82a95d"
    sha256                               arm64_sonoma:  "96c0a9174d8ba4499b72d8bba1c4e5d7e10e1c28a7443eb8aa8d2ee9f5b603f1"
    sha256                               arm64_ventura: "ef00ad52e5830e4fad74c1934e3ed526660d1183b41557253900239132800d63"
    sha256                               sonoma:        "b4331d39df89378bddb0b5e619abc47084273dd578f7425c977a4f13e542bd0e"
    sha256                               ventura:       "db231f404923eb8213558b052c8a1213c7a7cc35697fee487ab23ca54a7fce4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a6336abd526e3cb50b743e1dd509856537f6c6996ce3880b9315673485acaae"
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
