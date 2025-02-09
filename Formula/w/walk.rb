class Walk < Formula
  desc "Terminal navigator"
  homepage "https://github.com/antonmedv/walk"
  url "https://github.com/antonmedv/walk/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "81db744bbd36d55bde26f7fafce8a067baa6d1d81ae59aa090f48c93023a2bd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a405889469fcbd8cce9c0d13d9f31323f0ff559325564d17797f1367a9ac7bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a405889469fcbd8cce9c0d13d9f31323f0ff559325564d17797f1367a9ac7bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a405889469fcbd8cce9c0d13d9f31323f0ff559325564d17797f1367a9ac7bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "547da225cb6b32881127d6005eb154acb0028c2cb73ca7297ec40a7cb4604eba"
    sha256 cellar: :any_skip_relocation, ventura:       "547da225cb6b32881127d6005eb154acb0028c2cb73ca7297ec40a7cb4604eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0f696756182d25b35a4e7e97d5a375965ba9f3824957fd23059fe023d27e431"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"

    PTY.spawn(bin/"walk") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "\e"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
