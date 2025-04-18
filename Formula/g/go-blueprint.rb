class GoBlueprint < Formula
  desc "CLI to streamline Go project setup with standardized structure"
  homepage "https://docs.go-blueprint.dev/"
  url "https://github.com/Melkeydev/go-blueprint/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "d07f607211bf8d99e3f018fce7385a17a914bede2d147f799ae199990de33b05"
  license "MIT"
  head "https://github.com/Melkeydev/go-blueprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0725f929c512a502432367fd1bb61d7e8fbaa389829b3e0fa311fe68a8f04345"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0725f929c512a502432367fd1bb61d7e8fbaa389829b3e0fa311fe68a8f04345"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0725f929c512a502432367fd1bb61d7e8fbaa389829b3e0fa311fe68a8f04345"
    sha256 cellar: :any_skip_relocation, sonoma:        "26d941f9f53d9ebfbcef0967598f28d83ca7882c7186f3b075af209a262e9adb"
    sha256 cellar: :any_skip_relocation, ventura:       "26d941f9f53d9ebfbcef0967598f28d83ca7882c7186f3b075af209a262e9adb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5f3e42ce70e307c0e00e9865bcd3363ad5be69fb185da43a3f90937f8f40162"
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
