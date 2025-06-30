class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.78.0.tgz"
  sha256 "db82d07b9f4fcef30377e05c5f652344bdf8b122343ceb643ff921b0323835c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f04fa1a37d05ec038060b3d5d4aa9ae0822cc7e9a883978811b30611fca05223"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f04fa1a37d05ec038060b3d5d4aa9ae0822cc7e9a883978811b30611fca05223"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f04fa1a37d05ec038060b3d5d4aa9ae0822cc7e9a883978811b30611fca05223"
    sha256 cellar: :any_skip_relocation, sonoma:        "f860afe43f47fa80cfd8329bd837a61c362259b65451507a40bad066d2b2f149"
    sha256 cellar: :any_skip_relocation, ventura:       "f860afe43f47fa80cfd8329bd837a61c362259b65451507a40bad066d2b2f149"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f04fa1a37d05ec038060b3d5d4aa9ae0822cc7e9a883978811b30611fca05223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f04fa1a37d05ec038060b3d5d4aa9ae0822cc7e9a883978811b30611fca05223"
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
