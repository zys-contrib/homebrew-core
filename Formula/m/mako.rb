class Mako < Formula
  desc "Production-grade web bundler based on Rust"
  homepage "https://makojs.dev"
  url "https://registry.npmjs.org/@umijs/mako/-/mako-0.8.2.tgz"
  sha256 "5b56daaa12db6671321ddc7b7fd788d76a1d675b5ff11919d33b99bda3173dc6"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "6e01c5ee3ce20c3a07d1aff5ac7b3458e95a4977d1f90c012c0457ac5daa6962"
    sha256                               arm64_ventura:  "b071ff9e04849bf2fe120986f1bd82cbaee9166ded398bd0ae87c4ab036452f1"
    sha256                               arm64_monterey: "817152a1544625049560d57cd58f084aceb92f95634ebf0fbdcc3aec406190fd"
    sha256                               sonoma:         "471b9247a1c46ac3c890a860044b10d0e2122b14e123308b816d9c1aec471d3b"
    sha256                               ventura:        "5a3a54d088464afb6cee9dfedaadd78c17cf76ade553280838fa3ceaaf560009"
    sha256                               monterey:       "f003036f2f2a859aea0a0b16277b90e7809f6d062576b23cae2e7213052eb8b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5854728976f2c200f670a421b35b40705abea85ef495b85692c44c5a44c96a6b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/@umijs/mako/node_modules/nice-napi/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mako --version")

    output = shell_output("#{bin}/mako build 2>&1", 1)
    assert_match(/Load config failed/, output)
  end
end
