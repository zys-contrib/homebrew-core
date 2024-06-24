require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.40.2.tar.gz"
  sha256 "d99e9d764827897e3892d410c1bf9656df7bd148675fc9973ed35c7452d12d31"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3e921d28c3946431d8fdbf44f980525e42da7c9ecd77aa55e8f8cfec9238f93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1edf00326227cf6c19e7039e02953925dadfe0e35f803b9f4e17b700f7c8550e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcfb9c619d370be00529819428fdb4abc713acb72d134448c069ff42375bb895"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1a0946fffc7dd325849a88825950ad537aaab4cbd063dff7e44779b62b67465"
    sha256 cellar: :any_skip_relocation, ventura:        "af33b6205ed25183897e4fc7232964c690e044163f12ade325fd4ac11bd90b6c"
    sha256 cellar: :any_skip_relocation, monterey:       "29d54d944ea48fc76c2666992e139386871740e3c2aba81bedcf5061c01bdf8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11ed679d26d06544b84787ed50de3d5c35a737c369f294afb6e65d4f35d321be"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ]

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      # TODO: Remove `npm update pkg` when https://github.com/hasura/graphql-engine/issues/9440 is resolved.
      system "npm", "update", "pkg"
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "prebuild"
      system "./node_modules/.bin/pkg", "./build/command.js", "--output", "./bin/cli-ext-hasura", "-t", "host"
    end

    cd "cli" do
      arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
      os = OS.kernel_name.downcase

      cp "../cli-ext/bin/cli-ext-hasura", "./internal/cliext/static-bin/#{os}/#{arch}/cli-ext"
      system "go", "build", *std_go_args(output: bin/"hasura", ldflags:), "./cmd/hasura/"

      generate_completions_from_executable(bin/"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
