class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.69.0.tgz"
  sha256 "fa20a4a95bd9ca7143187d7958a47f0a087a78e4e89d0c592a9cf78fa363a91e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c316392bdb7ddd56e0e86a339823f02c7950f60f7c504de56fbcd82d8b4f0ac4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c316392bdb7ddd56e0e86a339823f02c7950f60f7c504de56fbcd82d8b4f0ac4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c316392bdb7ddd56e0e86a339823f02c7950f60f7c504de56fbcd82d8b4f0ac4"
    sha256 cellar: :any_skip_relocation, sonoma:         "422f465804f4bdc367b8852aa8fc3807c20ba7cbba5b4280a7b7c552a1c4aefb"
    sha256 cellar: :any_skip_relocation, ventura:        "422f465804f4bdc367b8852aa8fc3807c20ba7cbba5b4280a7b7c552a1c4aefb"
    sha256 cellar: :any_skip_relocation, monterey:       "422f465804f4bdc367b8852aa8fc3807c20ba7cbba5b4280a7b7c552a1c4aefb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c316392bdb7ddd56e0e86a339823f02c7950f60f7c504de56fbcd82d8b4f0ac4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["DOCKER_HOST"] = "/dev/null"
    # Modified .devcontainer/devcontainer.json from CLI example:
    # https://github.com/devcontainers/cli#try-out-the-cli
    (testpath/".devcontainer.json").write <<~EOS
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.com/devcontainers/rust:0-1-bullseye"
      }
    EOS
    output = shell_output("#{bin}/devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end
