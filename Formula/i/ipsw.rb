class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.599.tar.gz"
  sha256 "19b9cf03dfcb28e805e1adfb1445dfbc7abdd7082ea27947a27db80851ab694d"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb355c2d854793d385de0eb2030815db6a355febeaa41cd4f96844a5751cbdde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c104212273121a4a983c63ad884c4f8989f85eb625553aed665e5590749e84a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "748e2192a99708f7210350ed133a9360e985606fcd9870ccf6a8c15a5357c40d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c413dba150603814749b25cb92db33a4193f34d887a1e6c76437f24e0dc02b1"
    sha256 cellar: :any_skip_relocation, ventura:       "e45b13010eae369e0b07c8c28309fb416ebd00132cd89ac07e419edef0515a8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d8530df3ed6a18a18bd33774c18ef82d695097da02b2dffa3366f3f11e00ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5629511e8faf629dd95c886f94a92ea6adddde8f6a3050da665de337d2948e1b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
