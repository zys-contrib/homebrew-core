class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-22.2.0.tgz"
  sha256 "fddd802349ff272ea07f04f45b6737ba80c2d208501f2ec410692c060a762293"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "ddb66d23a920ecc6227e9525e67822764046c91199793db95787fdce82b23ee3"
    sha256                               arm64_sonoma:  "7d239bea1bf883aa85c210833d116d9ed1ad1c26b8919c065c925e58f581933a"
    sha256                               arm64_ventura: "c6380cba10a85e0756eabfc276b0db7de3bea1a8138de2810886ee0cf61c7a18"
    sha256                               sonoma:        "ba8765916b453d6313a5c7aed11cfa5caf938ea540ecaf46b248281280f4d0d3"
    sha256                               ventura:       "090cf9d05719a44fc267395bc434cd4720c99cc2bcfd0ce6ea41408d9cbcd565"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "934e2356606911113f68194eebff95c002d2f5eddab767f74f97c5b3935c57bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70252d2c142dbf301728bedb36abdf21947e2a8dbe6cd4ff1765679d63e61889"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
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
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")
  end
end
