class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.0.tgz"
  sha256 "f280de290ad1292cda66ad5d678d65c90c9684b4a2969830b048573d2148fea3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "42a9bbce4c80b9beb07739347f30112237ce4d25c2ee2a8562ff5307e9a66e65"
    sha256 cellar: :any,                 arm64_sonoma:  "42a9bbce4c80b9beb07739347f30112237ce4d25c2ee2a8562ff5307e9a66e65"
    sha256 cellar: :any,                 arm64_ventura: "42a9bbce4c80b9beb07739347f30112237ce4d25c2ee2a8562ff5307e9a66e65"
    sha256 cellar: :any,                 sonoma:        "5215c733b7050f58598a285e02636cdefbf9679573fffb9d33905474ca9727a2"
    sha256 cellar: :any,                 ventura:       "5215c733b7050f58598a285e02636cdefbf9679573fffb9d33905474ca9727a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25c98f2d6fe57e9c63ec2fbd5e3b9c54b0a0aebc67dd839e83bc0c6fe342df2c"
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
