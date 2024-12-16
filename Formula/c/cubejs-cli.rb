class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.11.tgz"
  sha256 "de9741469970053017835db7fe23486cd40f6f59ba4dafa875dda7ffcd640d2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e6a67db99664fd9a0b1c101149bb350809cd2a96457545a67fa70fd9d32a7a6a"
    sha256 cellar: :any,                 arm64_sonoma:  "e6a67db99664fd9a0b1c101149bb350809cd2a96457545a67fa70fd9d32a7a6a"
    sha256 cellar: :any,                 arm64_ventura: "e6a67db99664fd9a0b1c101149bb350809cd2a96457545a67fa70fd9d32a7a6a"
    sha256 cellar: :any,                 sonoma:        "8842ac2edc01625fc3e5f9f8b67449cd6d73c7528992ad7a10e9579278ca5e44"
    sha256 cellar: :any,                 ventura:       "8842ac2edc01625fc3e5f9f8b67449cd6d73c7528992ad7a10e9579278ca5e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "136e33d73646e30cfd5cc4d60ddeb477c39e1063c04ef120a76b51b498c63269"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
