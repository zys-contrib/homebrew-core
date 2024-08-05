class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.9.1.tgz"
  sha256 "7b9402a7d3a11c2cd4f1893057bd33771c603a845f66702733d713d6e48a38c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05f0795cb3322706e2fb4cc8dd506f42b22c357a046b62582cdb9d7c0b6d2609"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79c0d902c39c8ee808ed14b7d6c8e8c122292241d8a2c8e47c9dabe2be0ef272"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47c6c74bc0279db34df30a9c73a1471e567a05b27470536ccdcbb709b6208db4"
    sha256 cellar: :any_skip_relocation, sonoma:         "d17e82a0cb6b5d833788c0b8416a291b232f97b3d9fe219973cb30971f565716"
    sha256 cellar: :any_skip_relocation, ventura:        "59f24712692fca6f96c4f3bb54179c2ae3f19326e389c293822098eb14422306"
    sha256 cellar: :any_skip_relocation, monterey:       "a23545a965a8b73560c93bfec22692a88dcf06b28df517fb6b708483148f2bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b2a2c9c40a7cd62757a382131de198a6f9a51017b581a15dbe4663897dcfc40"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@cyclonedx/cdxgen/node_modules"
    cdxgen_plugins = node_modules/"@cyclonedx/cdxgen-plugins-bin/plugins"
    cdxgen_plugins.glob("*/*").each do |f|
      next if f.basename.to_s.end_with?("-#{os}-#{arch}")

      rm f
    end
  end

  test do
    (testpath/"Gemfile.lock").write <<~EOS
      GEM
        remote: https://rubygems.org/
        specs:
          hello (0.0.1)
      PLATFORMS
        arm64-darwin-22
      DEPENDENCIES
        hello
      BUNDLED WITH
        2.4.12
    EOS

    assert_match "BOM includes 1 components and 2 dependencies", shell_output("#{bin}/cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end
