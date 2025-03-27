class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-19.1.3.tgz"
  sha256 "7e09ab198cefb32d6e32b1f15e9200da0faa460d6fab61c976ae7abb712e5f29"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "bfb39a5e61ecb7d34cf8aa0b69f38b806bb904a9b16d3622db8f680c57058fda"
    sha256                               arm64_sonoma:  "6b0c0dbdfc08f260259dd3e50ff626e61e8f08833c40dd074498b2065d0c5c3f"
    sha256                               arm64_ventura: "398d7f346f4602390aa752de2706b078c6ff9fad8dad9bbf0f6dd7a22d02f2c2"
    sha256                               sonoma:        "1a072b0911d9faf917ceee48865488cc133db2ded1157814089497ae70848402"
    sha256                               ventura:       "7486ddc6430716c1a8433ff8b7ac74434a6eb177cd82f05f80fbbbc95e6206c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65395e8cfeb9fb53ddd4529573109b7fb656b9cc35f001400fbaa600abcf6d65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf72eaaccffe2309d5dbe730a19d4b074b730d40e16da7d1ed3d7f3c8d02902a"
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
