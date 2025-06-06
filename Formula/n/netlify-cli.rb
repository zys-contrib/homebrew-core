class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-22.1.2.tgz"
  sha256 "6e09f7ad4ca677ab44dae5a00721291d9a37b44e5128a65f7625562962c47dcd"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "37776f23a61c7fdc69bb5130dfddbeb4d314b09827c7a534058d6d6a006b0297"
    sha256                               arm64_sonoma:  "57e58c24b57de64136de1214e2ec86f90be76cdceaab072ef6e59f42634cbe40"
    sha256                               arm64_ventura: "2b854d553cd8d2c8a7ba6f70a6b83e78cb4c8028604e19befd55c6934ddfdd3f"
    sha256                               sonoma:        "7ea88a9c1827775ef5633ca8c451278a97a2cf5e0479b44c5637f807da0c2979"
    sha256                               ventura:       "bcca7c1b67223a1bd4f4db0b000a721a6fd6b115fd999029fe08550ba21a69cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1df4d4ac5d2010e05abd7c9de67191cf68eacfbcc029b0be87c57d2cf3261ca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6164dab8f21ca1062bf27157e07b6fcc568c7911bc3884908e645f918bf71f02"
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
