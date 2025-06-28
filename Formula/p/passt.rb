class Passt < Formula
  desc "User-mode networking daemons for virtual machines and namespaces"
  homepage "https://passt.top/passt/about/"
  url "https://passt.top/passt/snapshot/passt-2025_06_11.0293c6f.tar.xz"
  sha256 "347fa16b6a8c19291f690436198511886a995d62cb5d747a9550c12f66f4a49f"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "git://passt.top/passt", branch: "master"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "08c25216f4c1b793524315ff3d907193a17dd2707ea48bc0e5e70662f0351532"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5c6577f1b09a611eb23462d8ee50f93a134859891727526f8f02225896a43968"
  end

  depends_on :linux

  def install
    args = ["prefix=#{prefix}"]
    args << "VERSION=#{version}" if build.stable?
    system "make", "install", *args
  end

  test do
    require "pty"
    PTY.spawn("#{bin}/passt --version") do |r, _w, _pid|
      sleep 1
      assert_match "passt #{version}", r.read_nonblock(1024)
    end

    pidfile = testpath/"pasta.pid"
    begin
      # Just check failure as unable to use pasta or passt on unprivileged Docker
      output = shell_output("#{bin}/pasta --pid #{pidfile} 2>&1", 1)
      assert_match "Couldn't create user namespace: Operation not permitted", output
    ensure
      if pidfile.exist? && (pid = pidfile.read.to_i).positive?
        Process.kill("TERM", pid)
      end
    end
  end
end
