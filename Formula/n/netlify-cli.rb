class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-20.1.0.tgz"
  sha256 "32fedb26a444b0f6a1bf792b0d57545a659a83fd6995872d82155a413048f17e"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "479bc0ddfe2cb7915271d703c3e76e99c52e4c5e7775ab4186632ade3cfcb21d"
    sha256                               arm64_sonoma:  "ee799ee4b07bb13f4795462208e2ddde28ccb4a8e056786abf7e2158b7a1e74a"
    sha256                               arm64_ventura: "bc2ae709f7d22538231f0f9b99b7dc51772eb276ddfc9c71119a33aefbc928c8"
    sha256                               sonoma:        "29473b012d9866aa3b0b183f78e84907d0b610445d81e02931b08e26b1a07a67"
    sha256                               ventura:       "15fb0a437bc6cf197aabfa5f1cbc9e931f2323f45b7df36623e289cf8d3e6e05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "236a41ce272dc23908d04ee78202b411c28ea042402df4e6f8c7a15341dfc69e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d53897cccd54bc5a6876e739f859cb7ccf9fa834a6f823e3607694ecd117adc4"
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
