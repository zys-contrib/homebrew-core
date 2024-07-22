require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.73.1.tgz"
  sha256 "02a9ef57318d0229099f3eb01ed527962983fcf0d6a6d3883c6548f84db9ee4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74896cf75cfe6c97ac35ea438df4fb45c9a00ade8bc1d4f61a66ffa0b73b0416"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0231d434a3150ff3e7be2e29304db7570ed2023aa74d16959536f3aa2ae5e46c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e61a936119a5dd2b09bc3f20b93ddd8a9872a13c4841b695070617be054cc92"
    sha256 cellar: :any_skip_relocation, sonoma:         "0534b6c37bc8a7562092b73c938c48a3ce42466d3cdedf7916fd617c1b0b86fd"
    sha256 cellar: :any_skip_relocation, ventura:        "8f5d18c70690dd96ca60bff01e5e1bee8173797fe0fc09945e87a6199e423cf0"
    sha256 cellar: :any_skip_relocation, monterey:       "6d8bd9c29c44985a34c5aeace31873ae785d0e22f0d6e388dba1a98779751eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13c30be7c9dc23d692fde31490996ca37875f73c8aee825401f59e41f670429d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
