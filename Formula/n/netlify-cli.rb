class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-21.4.1.tgz"
  sha256 "0956ccb01d1e591f944f01978916b00676ee3d4d70ce2a694eeeb587dc8f2acb"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "474c20ac2b5df78f85d95b617d21ff7c5118612e33ab2bc7e4649b43a4ef89f9"
    sha256                               arm64_sonoma:  "49bfbbb049018c33472bff5879f31c31bb39d03ce9dc7fb90f91f9df0d10e082"
    sha256                               arm64_ventura: "5703b83b6ff963c4ba15aefd68a378a56e22bcb41dc2cc58c8518416ec1c9ad2"
    sha256                               sonoma:        "afffe86692357110d3bb24acf9d0bb048926ca9d9c94c241566e7a10f20d9f17"
    sha256                               ventura:       "0463491aa424ace23bdc975a051cee59d357b348be610714f708e0fb14d78c95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53098f520dea023c47f8a7a94708995c9bee6077e5b8fa696b5f7487ad32640f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12220a556ca3f03dafb3eb2fedbb146247d042125d3582c83678dcb90eaa147e"
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
