require "language/node"

class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-9.0.1.tgz"
  sha256 "497e578ba8f0865d640d5fe3fd6c4e3b9b0426cd1daf09683d827a26474be932"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "32840d431b367ac94561c6c804eeab74b0260a7f67231f3d13d4aaec64d43627"
    sha256 cellar: :any,                 arm64_ventura:  "32840d431b367ac94561c6c804eeab74b0260a7f67231f3d13d4aaec64d43627"
    sha256 cellar: :any,                 arm64_monterey: "32840d431b367ac94561c6c804eeab74b0260a7f67231f3d13d4aaec64d43627"
    sha256 cellar: :any,                 sonoma:         "e96625a2adef6b8573d26f95ca3b3e275cca77c9a23c1ec5d2d7e0e51c373e0c"
    sha256 cellar: :any,                 ventura:        "e96625a2adef6b8573d26f95ca3b3e275cca77c9a23c1ec5d2d7e0e51c373e0c"
    sha256 cellar: :any,                 monterey:       "e96625a2adef6b8573d26f95ca3b3e275cca77c9a23c1ec5d2d7e0e51c373e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "806ed9efe6d45cc01e7eab29adbfc55825b33a86197c4e800d7a68dbbc335cbf"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/dicebear/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/dicebear avataaars")
    assert_match "Avataaars by Pablo Stanley", output
    assert_predicate testpath/"avataaars-0.svg", :exist?

    assert_match version.to_s, shell_output("#{bin}/dicebear --version")
  end
end
