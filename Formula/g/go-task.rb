class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.39.1.tar.gz"
  sha256 "5c3678fca7fe260b5e9082a134590fb770a96784297c8d79617abf3b82aa8858"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c7cf3bc21eb3d5f9c72d75f28d6fff30f06f5c0df28e3dc813b2545585886bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c7cf3bc21eb3d5f9c72d75f28d6fff30f06f5c0df28e3dc813b2545585886bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c7cf3bc21eb3d5f9c72d75f28d6fff30f06f5c0df28e3dc813b2545585886bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3696beaf036277325589aa6c2383b3c42cda529ece914984aa05e42879b1893e"
    sha256 cellar: :any_skip_relocation, ventura:       "3696beaf036277325589aa6c2383b3c42cda529ece914984aa05e42879b1893e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caaed515b697e822af676c3a891860a894cb4f5db870f6611ea1d4ba0c3b913c"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/go-task/task/v3/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"task"), "./cmd/task"
    bash_completion.install "completion/bash/task.bash" => "task"
    zsh_completion.install "completion/zsh/_task" => "_task"
    fish_completion.install "completion/fish/task.fish"
  end

  test do
    output = shell_output("#{bin}/task --version")
    assert_match "Task version: #{version}", output

    (testpath/"Taskfile.yml").write <<~EOS
      version: '3'

      tasks:
        test:
          cmds:
            - echo 'Testing Taskfile'
    EOS

    output = shell_output("#{bin}/task --silent test")
    assert_match "Testing Taskfile", output
  end
end
