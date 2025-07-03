class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.0.1.tgz"
  sha256 "81a2aa975fc8e55491711048a0f73932863bf286b4f137f84b609b74cb73cfa1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d1b3adf00b0d63f9b5bb30212cfa48ca2cbf2500b474ff853a7550be0952c860"
    sha256 cellar: :any,                 arm64_sonoma:  "d1b3adf00b0d63f9b5bb30212cfa48ca2cbf2500b474ff853a7550be0952c860"
    sha256 cellar: :any,                 arm64_ventura: "d1b3adf00b0d63f9b5bb30212cfa48ca2cbf2500b474ff853a7550be0952c860"
    sha256 cellar: :any,                 sonoma:        "5ec2e13b8cf7c71473206d13af924cfb83330dc9fd9a8c6d67892ce082fe66c4"
    sha256 cellar: :any,                 ventura:       "5ec2e13b8cf7c71473206d13af924cfb83330dc9fd9a8c6d67892ce082fe66c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dee6d4eb8a1ea03640babb62cc31fdc64aa9d7ed664fe718ded28a422878113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed073fba1837ebc7d09f13e28c25018b13547426b202af736f3ed2a4076d10c1"
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
