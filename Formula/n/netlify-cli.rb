class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.35.0.tgz"
  sha256 "3769ebff7b6a0e43685f9b08cc83802f85a4871d7a83723c1f1f3eabcc2626c5"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "899092e293492ad330e7d94881a84526aced9f533ff2772290c7310383464a4f"
    sha256                               arm64_ventura:  "473d9eda6f7336a239025e89a44aa03c010c3a23fda2af234b462e6c285159d8"
    sha256                               arm64_monterey: "4fd199d8f6c87ac6787eb5e2d89238b147fac5110171ce55edfd34a6d30ba5c1"
    sha256                               sonoma:         "3268457c06027cb7e85b2e16bfd0255e71072876163031ef8908216dc8eefa68"
    sha256                               ventura:        "74700f8137f6c8e732568c787b45082a86d32cd78fab93d850edf93bdec6cefb"
    sha256                               monterey:       "93f60d537e68450b65d93ad7e5558fa22adf08ebbec624f1cbf73903feb2b367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31e849402d8a42a13088cc092fd74002743c4bc3bcf347395dbced9112c0bdf1"
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
