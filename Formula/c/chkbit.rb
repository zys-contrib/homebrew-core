class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https://github.com/laktak/chkbit"
  url "https://github.com/laktak/chkbit/archive/refs/tags/v6.2.0.tar.gz"
  sha256 "faaf2d26d44a5a74855c40aabe07d6a41030c3fdfe1181993290ed04e9f62bb9"
  license "MIT"
  head "https://github.com/laktak/chkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5124a342100712f819c81a41df32a9bd3161e811661c0d86588c1b36096f7015"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5124a342100712f819c81a41df32a9bd3161e811661c0d86588c1b36096f7015"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5124a342100712f819c81a41df32a9bd3161e811661c0d86588c1b36096f7015"
    sha256 cellar: :any_skip_relocation, sonoma:        "e99e3920f1c496daf9c0553f091d4d503ff063cf1ba9e6f657bbb45587d05f1e"
    sha256 cellar: :any_skip_relocation, ventura:       "e99e3920f1c496daf9c0553f091d4d503ff063cf1ba9e6f657bbb45587d05f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03548b3d8f8a4b045184eb817a280ea02d541f28c6455d58ae6e8d45bfaff318"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/chkbit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chkbit version").chomp
    system bin/"chkbit", "init", "split", testpath
    assert_path_exists testpath/".chkbit"
  end
end
