class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.9.tgz"
  sha256 "8456e1947da93d4c44857faa01ec05435ba739d4ab06d7bea1e737485dc9cb7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "446dd69ec7ce43ae01345c13058a3a4d452fe8acf7ffb494c2cd5c6be8bc4743"
    sha256 cellar: :any,                 arm64_sonoma:  "446dd69ec7ce43ae01345c13058a3a4d452fe8acf7ffb494c2cd5c6be8bc4743"
    sha256 cellar: :any,                 arm64_ventura: "446dd69ec7ce43ae01345c13058a3a4d452fe8acf7ffb494c2cd5c6be8bc4743"
    sha256 cellar: :any,                 sonoma:        "88be314996f8be2f856db335084d46d87e082c126b1ba667d37a66a00122bac7"
    sha256 cellar: :any,                 ventura:       "88be314996f8be2f856db335084d46d87e082c126b1ba667d37a66a00122bac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "472aeb1df007e171442f740cdccea520f462a5925873bc63504ca0b81e0371ca"
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
