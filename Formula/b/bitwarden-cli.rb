class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://github.com/bitwarden/clients/archive/refs/tags/cli-v2025.6.1.tar.gz"
  sha256 "73d620b95e3554ed980a582f36e5f8a62d7a5839841179281470bc2b973ad96c"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "d2007a2032466be109f0acf7802dc0237c7a6bf03a92b6d23c5eb2b02ffa3756"
    sha256                               arm64_sonoma:  "8985c6ea8a83776a70997cc7c7e96260f0e5d354f8967554f1b278727ebf58ee"
    sha256                               arm64_ventura: "3f28b82270b8e9bcfe4880f233f9fd94b03ffcb744254b1881e0e7cd7aec8f41"
    sha256                               sonoma:        "36d8ea40367dc6eb09e7b26123cfd9750e17f2206d1bf6458c8a7d706d248f3c"
    sha256                               ventura:       "9f50e99b1a362aa2eadc10ba03d8bcb97370d11c12dea04fb42882074a9be979"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90adfb554518bb6170381942d7ef0bab7a81157cad2970b37ec560917e073c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bd8e54938679e62b53b08297efb94b2fd73f45148f37a37ee9fa7fc79df35b2"
  end

  depends_on "node"

  def install
    system "npm", "ci", "--ignore-scripts"

    # Fix to build error with xcode 16.3 for `argon2`
    # Issue ref:
    # - https://github.com/bitwarden/clients/issues/15000
    # - https://github.com/ranisalt/node-argon2/issues/448
    inreplace "package.json", '"argon2": "0.41.1"', '"argon2": "0.43.0"'
    inreplace "apps/cli/package.json", '"argon2": "0.41.1"', '"argon2": "0.43.0"'

    # Fix to Error: Cannot find module 'semver'
    # PR ref: https://github.com/bitwarden/clients/pull/15005
    system "npm", "install", "semver", "argon2", *std_npm_args

    cd buildpath/"apps/cli" do
      # The `oss` build of Bitwarden is a GPL backed build
      system "npm", "run", "build:oss:prod", "--ignore-scripts"
      cd "./build" do
        # Fix to Error: Cannot find module 'semver'
        # PR ref: https://github.com/bitwarden/clients/pull/15005
        system "npm", "install", "semver", "argon2", *std_npm_args
        bin.install_symlink Dir[libexec/"bin/*"]
      end
    end

    # Remove incompatible pre-built `argon2` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    base = (libexec/"lib/node_modules")

    universals = "{@microsoft/signalr/node_modules/utf-8-validate,bufferutil,utf-8-validate}"
    universal_archs = "{darwin-x64+arm64,linux-x64}"
    base.glob("@bitwarden/clients/node_modules/#{universals}/prebuilds/#{universal_archs}/*.node").each(&:unlink)

    prebuilds = "{,@bitwarden/cli/node_modules/,@bitwarden/clients/node_modules/}"
    base.glob("#{prebuilds}argon2/prebuilds") do |path|
      path.glob("**/*.node").each(&:unlink)
      path.children.each { |dir| rm_r(dir) if dir.directory? && dir.basename.to_s != "#{os}-#{arch}" }
    end

    generate_completions_from_executable(bin/"bw", "completion", shells: [:zsh], shell_parameter_format: :arg)
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
