class Lazyjournal < Formula
  desc "TUI for logs from journalctl, file system, Docker, Podman and Kubernetes pods"
  homepage "https://github.com/Lifailon/lazyjournal"
  url "https://github.com/Lifailon/lazyjournal/archive/refs/tags/0.7.8.tar.gz"
  sha256 "64b23ee8a4d2c0588f0ffc372f8aa0a4841cc9bc2ec7b5d6a4cd0603b4feb687"
  license "MIT"
  head "https://github.com/Lifailon/lazyjournal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89e0fadc36f69b0cc75bd6531a50a9d551181a809337f48d1970b03e330cf68b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89e0fadc36f69b0cc75bd6531a50a9d551181a809337f48d1970b03e330cf68b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89e0fadc36f69b0cc75bd6531a50a9d551181a809337f48d1970b03e330cf68b"
    sha256 cellar: :any_skip_relocation, sonoma:        "03ccef65a4930e9259b72141fdc65d8ee330a340902b4adc01198855356ae551"
    sha256 cellar: :any_skip_relocation, ventura:       "03ccef65a4930e9259b72141fdc65d8ee330a340902b4adc01198855356ae551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "923333f9272f14a024a51cb4a0d28eed8bdbdcf9698d9a7815b899d757046306"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.buildSource=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjournal --version")

    require "pty"
    PTY.spawn bin/"lazyjournal" do |_r, _w, pid|
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
