class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.42.0.tar.gz"
  sha256 "8d3cd23ce03a40fd40d37ffb5c36ec2b4be5f4e01ca110e719297d1c75c42d65"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60c4ece4727ffca2fed8bb7fdce1d7f3ddf33a49af7cd664d95ef9ae1d18aaf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60c4ece4727ffca2fed8bb7fdce1d7f3ddf33a49af7cd664d95ef9ae1d18aaf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60c4ece4727ffca2fed8bb7fdce1d7f3ddf33a49af7cd664d95ef9ae1d18aaf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6963214ac6da799bed119b37a7aa5ecb46d6a1afadd1b2a25a531cc9cdd4310"
    sha256 cellar: :any_skip_relocation, ventura:       "d6963214ac6da799bed119b37a7aa5ecb46d6a1afadd1b2a25a531cc9cdd4310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db129a42a74db2751a677dd62b414629db65d7882c65b8c795ca2c08e1db7de1"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  # version report patch, upstream pr ref, https://github.com/go-task/task/pull/2105
  patch do
    url "https://github.com/go-task/task/commit/44cb98cb0620ea98c43d0f11ce92f5692ad57212.patch?full_index=1"
    sha256 "78861415be4e9da4f40ecff7b50300926f70fc4d993c3d83cd808040d711b35e"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/go-task/task/v3/internal/version.version=#{version}
      -X github.com/go-task/task/v3/internal/version.sum=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"task"), "./cmd/task"
    bash_completion.install "completion/bash/task.bash" => "task"
    zsh_completion.install "completion/zsh/_task" => "_task"
    fish_completion.install "completion/fish/task.fish"
  end

  test do
    output = shell_output("#{bin}/task --version")
    assert_match "Task version: #{version}", output

    (testpath/"Taskfile.yml").write <<~YAML
      version: '3'

      tasks:
        test:
          cmds:
            - echo 'Testing Taskfile'
    YAML

    output = shell_output("#{bin}/task --silent test")
    assert_match "Testing Taskfile", output
  end
end
