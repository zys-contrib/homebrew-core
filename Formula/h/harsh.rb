class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/v0.10.17.tar.gz"
  sha256 "05dbdc6c60582e190b4397ae9b3ce812cc6ddb2b8e87efa2377e1cd8d79895dd"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4054461ce4bdc8da93d5084106a5737340f6ca62b88be8c2e222625670ccb426"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4054461ce4bdc8da93d5084106a5737340f6ca62b88be8c2e222625670ccb426"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4054461ce4bdc8da93d5084106a5737340f6ca62b88be8c2e222625670ccb426"
    sha256 cellar: :any_skip_relocation, sonoma:        "444e12c8beef0c29b256a560df3440c18ba1d20882802adb1f18900a62ccbd68"
    sha256 cellar: :any_skip_relocation, ventura:       "444e12c8beef0c29b256a560df3440c18ba1d20882802adb1f18900a62ccbd68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43a526f113f2257ebd27380b8545ed672db7d4e29de7d598b0ea71a9b2e7bbd4"
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
