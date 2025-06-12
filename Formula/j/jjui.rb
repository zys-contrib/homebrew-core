class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.8.10.tar.gz"
  sha256 "a4c9a20d781e42da4cb44dd198159fdadcabfa37e3caadc5521d3d03a89ea952"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54e7a15721fb267acdaeb43aa73068361593666de8219496e1f19043547662b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54e7a15721fb267acdaeb43aa73068361593666de8219496e1f19043547662b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54e7a15721fb267acdaeb43aa73068361593666de8219496e1f19043547662b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "60186d9a662096c177aea03a42b2fc7b17045f8f04b6a250d39003d6cd0350b5"
    sha256 cellar: :any_skip_relocation, ventura:       "60186d9a662096c177aea03a42b2fc7b17045f8f04b6a250d39003d6cd0350b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c619c378089dea967033ea1e753b09eed71dd8807e4dd10fb505547fdbeb3327"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "Error: There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end
