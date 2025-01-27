class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.17.tgz"
  sha256 "48162dcc2135632012a85e6d152d1fdb4e117c7efdd9496bbd9e0b902faf6844"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "94cf5593b22b64fc2c403b08d8b22792bec3126f90bbb53b73f8df0c999cc9f0"
    sha256 cellar: :any,                 arm64_sonoma:  "94cf5593b22b64fc2c403b08d8b22792bec3126f90bbb53b73f8df0c999cc9f0"
    sha256 cellar: :any,                 arm64_ventura: "94cf5593b22b64fc2c403b08d8b22792bec3126f90bbb53b73f8df0c999cc9f0"
    sha256 cellar: :any,                 sonoma:        "e57d060e52ef5006537b78a59d1213a4e09eb7bd727892137ba5499fc1e50dcb"
    sha256 cellar: :any,                 ventura:       "e57d060e52ef5006537b78a59d1213a4e09eb7bd727892137ba5499fc1e50dcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3942b5b6342208b883932007dfb6a2cc3493db0abe0f2758a1e71b809f19ab4"
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
