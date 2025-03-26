class JvmMon < Formula
  desc "Console-based JVM monitoring"
  homepage "https://github.com/ajermakovics/jvm-mon"
  url "https://github.com/ajermakovics/jvm-mon/archive/refs/tags/1.2.tar.gz"
  sha256 "5bc23aef365b9048fd4c4974028d4d1bbd79e495c9fa2d57446fc64a515d9319"
  license "Apache-2.0"
  head "https://github.com/ajermakovics/jvm-mon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "88c2a99416c6bd4c33480769b5e47f9f4964d28d0f04fbcb1821e2fda0e891b7"
    sha256 cellar: :any_skip_relocation, ventura:      "c20d541a04a08a0282c90ed1968fbc03d5be5012f9a73e22b52d2ded67c9a880"
    sha256 cellar: :any_skip_relocation, monterey:     "c20d541a04a08a0282c90ed1968fbc03d5be5012f9a73e22b52d2ded67c9a880"
    sha256 cellar: :any_skip_relocation, big_sur:      "c20d541a04a08a0282c90ed1968fbc03d5be5012f9a73e22b52d2ded67c9a880"
    sha256 cellar: :any_skip_relocation, catalina:     "c20d541a04a08a0282c90ed1968fbc03d5be5012f9a73e22b52d2ded67c9a880"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0c83187b28705971793ac3f89c385a07edd958d20d3d30e0c133b77bc5fc0ac0"
  end

  depends_on "go" => :build
  depends_on "openjdk" => :build

  def install
    ENV["GOBIN"] = buildpath/"bin"
    ENV.prepend_path "PATH", buildpath/"bin"

    cd "jvm-mon-go" do
      system "./make-agent.sh"
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jvm-mon -v 2>&1")

    require "pty"
    ENV["TERM"] = "xterm"
    PTY.spawn(bin/"jvm-mon") do |_r, w, _pid|
      sleep 1
      w.write "q"
    end
  end
end
