class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.195.tar.gz"
  sha256 "d4de84ea64f02a859d85cb5ae819602a393e94ac90a464ad6102d2132cb9e08e"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "908408144858c47a01ff43683a68263c2773ebfd7af2bc24f5279728a47ede91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "908408144858c47a01ff43683a68263c2773ebfd7af2bc24f5279728a47ede91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "908408144858c47a01ff43683a68263c2773ebfd7af2bc24f5279728a47ede91"
    sha256 cellar: :any_skip_relocation, sonoma:        "89261cb04eb9ac42011d6777559a14dba95ef3e369c4d9919617509349ccde90"
    sha256 cellar: :any_skip_relocation, ventura:       "89261cb04eb9ac42011d6777559a14dba95ef3e369c4d9919617509349ccde90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00e623e41aeb7de4b3a99c853c08121be379b9f538a823f5e3880abc78e0d130"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
