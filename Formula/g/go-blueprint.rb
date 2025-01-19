class GoBlueprint < Formula
  desc "CLI to streamline Go project setup with standardized structure"
  homepage "https://docs.go-blueprint.dev/"
  url "https://github.com/Melkeydev/go-blueprint/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "92d3f157297efeb7f16cba2496ea12e497c3c3db86f751a65597791a5a14a5a0"
  license "MIT"
  head "https://github.com/Melkeydev/go-blueprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1495c597dd43eba4ed804b3b1f7439935d57c9743a8c3c515e1d8632869fd265"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1495c597dd43eba4ed804b3b1f7439935d57c9743a8c3c515e1d8632869fd265"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1495c597dd43eba4ed804b3b1f7439935d57c9743a8c3c515e1d8632869fd265"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1ba633129a69bbdcfbfab47f7ce4f227864ecd9d3fba0d6c500f91fccc256a2"
    sha256 cellar: :any_skip_relocation, ventura:       "a1ba633129a69bbdcfbfab47f7ce4f227864ecd9d3fba0d6c500f91fccc256a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ddec9f865e204aec679d7e5ed1e8147f8c370b775ffdbb70676c1d2ee8951a8"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/melkeydev/go-blueprint/cmd.GoBlueprintVersion=#{version}")

    generate_completions_from_executable(bin/"go-blueprint", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-blueprint version")

    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    module_name = "brew.sh/test"
    system bin/"go-blueprint", "create", "--name", module_name,
               "--framework", "gin", "--driver", "sqlite", "--git", "skip"

    test_project = testpath/"test"
    assert_path_exists test_project/"cmd/api/main.go"
    assert_match "module #{module_name}", (test_project/"go.mod").read
  end
end
