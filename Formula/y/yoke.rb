class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.12.0",
      revision: "d4281b098763669987c5923532951b7a1a2c963e"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7d2a97e3557685a1bd9e5ac14c91dd7e1bbf1a504b8ce784166b4a7b30f4657"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7c5ab8b20cf752ff5af306ad8647f896ad8627b71cfc45be7e22f514a00f095"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7de0ac8840678980e15cbda98cc935097846f629b183a3307721edb7a352728a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d77aa7b4a6ab169a749df1dba23d4cdd20d44c5ac8badfff879bfe12be61db37"
    sha256 cellar: :any_skip_relocation, ventura:       "faf392f2782cbfc01c203989ee9044d64231f745a2333afe757ddfc5ad318cb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fc69d0ee4ab70c3d742eb6a9818c0192664e7128e725fedee0a9ed08d2c1833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "292f525776a4e8854bf3a86089b50a770bdbf2234a8bb4f42fc4d526a225ea0a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
