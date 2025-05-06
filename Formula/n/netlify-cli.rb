class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-21.0.1.tgz"
  sha256 "b915b091927c9884b860d10ce2c8940846c2a4f168886bf975c364a2f5f70f1d"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "34cf6d5b876345e787c16fb16c78f44ac35b82e5a064d36f07e39ee193f6dab9"
    sha256                               arm64_sonoma:  "f615e51cbc4978b53c08142bcf8ac2e5186d948dbe45f9408434bfb6d58a1d0e"
    sha256                               arm64_ventura: "bb4e2a2dd63441ab41579631e8fa27ea5a1870f03cb9c3abba6331a27bb638fd"
    sha256                               sonoma:        "b5df01d3c02bc1f05f9fa2391edc5c8796fb021fb57cc4f7f129f1e32fdfa73a"
    sha256                               ventura:       "e50e966db90598de580349b0111b07eb42dc118368b7d34502dc9a3b4ab7e590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26b4775a6ec19840ac49069c8bce088016553101eaa3adb4212951f4d9ff2adc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72c1490d10dc7106e072707d8c48a0c1483841ddcaff3f4230a8244b3a6fbfe4"
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
