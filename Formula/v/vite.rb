class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.0.11.tgz"
  sha256 "88df3c0f91f81c0a70456ac46e82f84dc39d987a456fb640caa0640bc26e52ec"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c39b49a2df5ee445d80f160c9f9a0d28768d6f01093e721920944242d30ac21c"
    sha256 cellar: :any,                 arm64_sonoma:  "c39b49a2df5ee445d80f160c9f9a0d28768d6f01093e721920944242d30ac21c"
    sha256 cellar: :any,                 arm64_ventura: "c39b49a2df5ee445d80f160c9f9a0d28768d6f01093e721920944242d30ac21c"
    sha256 cellar: :any,                 sonoma:        "06ac9fc5947f16e6510a3eea7e24bc9f8b419220bdf15a7225125d3311db4480"
    sha256 cellar: :any,                 ventura:       "06ac9fc5947f16e6510a3eea7e24bc9f8b419220bdf15a7225125d3311db4480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5e4d2986581e5978834173c3f762c1ebcf765231ad7a1aa9dde27df5f7faf5b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
