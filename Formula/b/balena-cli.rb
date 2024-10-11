class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-19.0.20.tgz"
  sha256 "a2c817a4e4d60c229457b6efd6b23f84e94917c64e99db2ea40709c0534a3760"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sequoia: "ea803e4ff1546653f9921eb009e19034367b0f71bec0a5943683dd6a2e7279ec"
    sha256                               arm64_sonoma:  "6b29263c05fa9ba6057977d283f36d84fd9f2e65375bcdd2576d9a485e14b302"
    sha256                               arm64_ventura: "8cdd1c5da0faa20fc0b4b92fe64e677ba0d0c3fe0c8211354ac4a5c0e1853003"
    sha256                               sonoma:        "b59c3d82458fc346b912a3a79596420efe5fe3206abebf281aad5fb4124f3834"
    sha256                               ventura:       "71e977c3ae289700966d8658cfc9fb627f1081f679d081c7bd4b4ce6beca339d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa2144e7df9996762966f1616d777f9738c45e3fac4bb2ca7bee5e1d5c709eb9"
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
