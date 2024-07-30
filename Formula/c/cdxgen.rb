require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.9.0.tgz"
  sha256 "4d4f393bd2eda52a2af3da12347ab4062313e033de4ff5073627cba31336fa16"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d314700d4c83a33efc3bef0c170d4c5b680c57c1ef1548100b6de2a2e6840c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78b16d5914ebd046a8a755de4a8b72b7a20c040b7dc6768f64bd5d9731a97ee0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40b45a5f01323ce050f5fe50e47cbba33cbd6232158591c899898e5727f6a6fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe159cdf6644957668e6226488c99b2b73504ee02bb41942c146e7c7fdd8951e"
    sha256 cellar: :any_skip_relocation, ventura:        "9819b87a78ea2d2923d1d62a7a10fc23bd18e8a7391ecb7b9bdc6b004524cea7"
    sha256 cellar: :any_skip_relocation, monterey:       "25597a8bb0457bb97f79beab2f00256d66a771c4e75755fcb7550dbd877fb2e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "445cbcba7dd799de8d3692a22c0a6d9ecb0f6193c740d6f901a8d88908da5ebb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
