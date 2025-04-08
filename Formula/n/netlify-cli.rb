class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-19.1.6.tgz"
  sha256 "7049d8dd03ba6b99c0a0577c417b029d14e3011fe371a4abdcc196b47512cbd9"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "c7efd8c91cac633ba528e59c57b50ba77ba77df53d903c2291e4c09996b14e3c"
    sha256                               arm64_sonoma:  "4ff9cd9b95e9771f02bcdbf21e6b80ca635d9b870f60a1a4f61de2c43e84a564"
    sha256                               arm64_ventura: "9303b668e3b0d517b5cfd038a146bd691f3a1d605f3ecd01e3540e863ab68427"
    sha256                               sonoma:        "fb2add2b1ca2a76e1d0e5653300d2c0ce2a879eae524dc2662c411ed94b298ac"
    sha256                               ventura:       "8dde934a848920fa9ad02666f23754f374eb5014c7855f2e4aae119ef6ec1277"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf584153d6f6616be95bf91b8d0c6607856647e567a5e4492f0e4488ed307c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ef0f98f16ffd1af5d59dc5fb9caa6f2bec6a42de0c474d16aba613cbef32d69"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
