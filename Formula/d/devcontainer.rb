class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.74.0.tgz"
  sha256 "d5c822c317cd011622cefe9b003c6a342db1693ae28d67022e408f8114e72d9e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5352493a74dc7a89777091ae39903f8ef313397abac483dd65cb17b5107ab7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5352493a74dc7a89777091ae39903f8ef313397abac483dd65cb17b5107ab7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5352493a74dc7a89777091ae39903f8ef313397abac483dd65cb17b5107ab7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd3464b98ea15f368fb5cbf2f3e818eb18d67fc39c75a1be64e3e997955fb17a"
    sha256 cellar: :any_skip_relocation, ventura:       "dd3464b98ea15f368fb5cbf2f3e818eb18d67fc39c75a1be64e3e997955fb17a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5352493a74dc7a89777091ae39903f8ef313397abac483dd65cb17b5107ab7d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["DOCKER_HOST"] = File::NULL
    # Modified .devcontainer/devcontainer.json from CLI example:
    # https://github.com/devcontainers/cli#try-out-the-cli
    (testpath/".devcontainer.json").write <<~JSON
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.com/devcontainers/rust:0-1-bullseye"
      }
    JSON
    output = shell_output("#{bin}/devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end
