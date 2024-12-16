class GoBlueprint < Formula
  desc "CLI to streamline Go project setup with standardized structure"
  homepage "https://docs.go-blueprint.dev/"
  url "https://github.com/Melkeydev/go-blueprint/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "2bdceb5946f4b08cdd98e29e50404a48fc47967cb3ef0f0e66f8b5ec3b7e07e0"
  license "MIT"
  head "https://github.com/Melkeydev/go-blueprint.git", branch: "main"

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
