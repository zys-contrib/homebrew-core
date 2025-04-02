class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/v0.10.16.tar.gz"
  sha256 "5f9aa624ce5cd32a1e743f3ace6013f00be31f5b04dfe3ae63d48c5ac764c129"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e177987c659c5778c76ebc560b3c0be8c7c1b599b6ab0c4375ca469b31d4ef63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e177987c659c5778c76ebc560b3c0be8c7c1b599b6ab0c4375ca469b31d4ef63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e177987c659c5778c76ebc560b3c0be8c7c1b599b6ab0c4375ca469b31d4ef63"
    sha256 cellar: :any_skip_relocation, sonoma:        "df08ab27386a55b3da263d2ebb0172e9499ffb0b5abc0347eb46e2ff67e38111"
    sha256 cellar: :any_skip_relocation, ventura:       "df08ab27386a55b3da263d2ebb0172e9499ffb0b5abc0347eb46e2ff67e38111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f886079d7cfe3c054717edaa8bcc48bd92e788a249459a2b02bebc1c58a0438"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Harsh version #{version}", shell_output("#{bin}/harsh --version")
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
  end
end
