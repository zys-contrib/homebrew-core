class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.2.5.tgz"
  sha256 "f75b11255d654f0edbc976bfd3078920191a65c70bb04a1c5b6da084ab0f3ee7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce7f19dfecf7248418ce3bfa4aeb65577fe5b8dbbda46975711e0137e7f389e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce7f19dfecf7248418ce3bfa4aeb65577fe5b8dbbda46975711e0137e7f389e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce7f19dfecf7248418ce3bfa4aeb65577fe5b8dbbda46975711e0137e7f389e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c19a5131800dbef3a9079e7519a8c5096e0d326d83caaeee08be7ad65b3fb42"
    sha256 cellar: :any_skip_relocation, ventura:       "0c19a5131800dbef3a9079e7519a8c5096e0d326d83caaeee08be7ad65b3fb42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bd2acbdcaf0e30d86b9fa4af2241acf2d121a3eae0e55970a1a5d946c8a883d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83c0702c5b36bd8653a0dd2abca64c3dc971237985cf91317dbdf0baeaa76567"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
