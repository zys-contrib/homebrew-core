class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.7.1",
      revision: "5bf53dc168693c8640e3de4420295e28d6c9fb57"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3a1cac95f8c4113fe1af7ae8a05b4fc5a0a9ed9d0fd17a6a0e68db40c4a07f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "634f43503447aa835c949c9618ccc864ee6ec67a8dabd1a7150aa3196d682df4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11ad76aee659b8da6b6f9fe16151c0a324b7555822e5b71fde6b3d665053dc0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ac83f3ab8cc54fe6662429a2dbedeee54a565c57c3107f1bdda5c827239cf34"
    sha256 cellar: :any_skip_relocation, ventura:       "b6d0c2e450d1fcbe552908e716d7c9ad89e14484c6c2551da285b896836761ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e1da61a1ad151af1830f848761f347138cf27bf623ea4f836fdf5067d47ea6f"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
