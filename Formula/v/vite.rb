class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.0.9.tgz"
  sha256 "b6a35a42d91e605df10380bd0bd3987487b3ddb27820aa06bf2cf37796e31c3d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15848b9d56b2dea74fbdbb23cd7c3a8c43ee8c9ff7fae779a12e405462e12953"
    sha256 cellar: :any,                 arm64_sonoma:  "15848b9d56b2dea74fbdbb23cd7c3a8c43ee8c9ff7fae779a12e405462e12953"
    sha256 cellar: :any,                 arm64_ventura: "15848b9d56b2dea74fbdbb23cd7c3a8c43ee8c9ff7fae779a12e405462e12953"
    sha256 cellar: :any,                 sonoma:        "7f43d723d6952b530c49b9f9aed69f8398e6ff8a55da5be4075c1d6341bec6f2"
    sha256 cellar: :any,                 ventura:       "7f43d723d6952b530c49b9f9aed69f8398e6ff8a55da5be4075c1d6341bec6f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26c20be7da9dd8096e2f9b79bdc846545ff4569a2db665bfc822e709a5d5340c"
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
