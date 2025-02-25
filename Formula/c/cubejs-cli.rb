class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.11.tgz"
  sha256 "6d1521eeb55f44d7a28664756bd773417c7716c0b9bbd5d99f1b538922b9bff3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7c8bb52113ca1e996f10eaa91f92e247a427e1460ae45e75b3af221e0ec0c446"
    sha256 cellar: :any,                 arm64_sonoma:  "7c8bb52113ca1e996f10eaa91f92e247a427e1460ae45e75b3af221e0ec0c446"
    sha256 cellar: :any,                 arm64_ventura: "7c8bb52113ca1e996f10eaa91f92e247a427e1460ae45e75b3af221e0ec0c446"
    sha256 cellar: :any,                 sonoma:        "aeb3ada61eb2bf62ef8a4822f2ce760524a46c53755a0ae9f5db4b62adcf1e4e"
    sha256 cellar: :any,                 ventura:       "aeb3ada61eb2bf62ef8a4822f2ce760524a46c53755a0ae9f5db4b62adcf1e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "affd45c13c02425741dd5e2296998f5417433c4ec8592ab888b4ec784cb63d6a"
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
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
