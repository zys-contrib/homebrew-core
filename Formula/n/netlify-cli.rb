class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-22.1.4.tgz"
  sha256 "92ed79475eb9264cc606dddceeca29af58b6b6b88e51596667c11408c2d30c7c"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "6d90cbcfabbd7bd3f7bc7efd96979c5cae6fb4ab614e96bb653ad25704e3526a"
    sha256                               arm64_sonoma:  "434e70090f0115f2c30b531c5108549031c09892ff04f8b13896c9ff63c04d41"
    sha256                               arm64_ventura: "2d0d7bd4cbbaad7bb0225fab4abb28b4b4c14e774338c40e0a83a2c5bbeb2d85"
    sha256                               sonoma:        "4e0ceac499a72ca8bcf34074d32d9435a432065dc3753b0aa3df9b37b5c72d3d"
    sha256                               ventura:       "b28bf61874b2a608cb488ac917f95c70410716b4e365062fa1fa32af6d9c1efe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58091096835dc9156907a664c6fd4ff8a3972d9ecdb5047db73f9f7bef7d38d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0199380a60669df78c658fab6492d585e5414189a8f9e22b08be74fab6c4c00"
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
