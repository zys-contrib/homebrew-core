class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-11.1.4.tgz"
  sha256 "46e4e3886b408ce147f5aaa48dc511054257ecc58d207b8c302205fc42c34b67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16524e1372de7dc5b5198dae04a4be19d8092d51f18f93e6a118fe193dd7c2ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63222b6333a0c41bab12a90dc58dc2686b99ffe039ae1ebf3cba2bc43fa71ec1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85a33691494ca9e9378f4452523a168e5cabc1a401f2759be612b23a32bf234a"
    sha256 cellar: :any_skip_relocation, sonoma:        "786f8a0e1025eeb9856b20416cef03fba4025813e57ede0c0ab8b62ec99d4555"
    sha256 cellar: :any_skip_relocation, ventura:       "fd8b54b5d7738e38e072d35c4f61bce6e979e974eb5a3325346e1f2f179c511b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "448984d803d3b94059ff46b9cb85b5340a9f260ca35f8cc6b95b1a8a2042ac54"
  end

  depends_on "node"

  uses_from_macos "ruby"

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

    # Remove pre-built osquery plugins for macOS arm builds
    osquery_plugins = node_modules/"@cyclonedx/cdxgen-plugins-bin-darwin-arm64/plugins/osquery"
    rm_r(osquery_plugins) if OS.mac? && Hardware::CPU.arm?
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
