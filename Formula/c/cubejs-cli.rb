class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.36.1.tgz"
  sha256 "a8c3d96f7e22c88d58a12474afe6841da9b68ff9bc2a1112eeec56cf64fc014b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f19a147bc3b7b98e4e02f4be0e8b0dbb44bf3a79cb0ea5ab09bb6f52414bfe30"
    sha256 cellar: :any,                 arm64_sonoma:  "f19a147bc3b7b98e4e02f4be0e8b0dbb44bf3a79cb0ea5ab09bb6f52414bfe30"
    sha256 cellar: :any,                 arm64_ventura: "f19a147bc3b7b98e4e02f4be0e8b0dbb44bf3a79cb0ea5ab09bb6f52414bfe30"
    sha256 cellar: :any,                 sonoma:        "44257b2ff62d87b2e4a22924bdf9ef10f86539469803b3e3c22705a454642b1f"
    sha256 cellar: :any,                 ventura:       "44257b2ff62d87b2e4a22924bdf9ef10f86539469803b3e3c22705a454642b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a179108673d03d4082b8e99ff693f4a577f71c8662940a078b47fd2c9ec4506"
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
