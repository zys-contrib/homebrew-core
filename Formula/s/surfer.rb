class Surfer < Formula
  desc "Waveform viewer, supporting VCD, FST, or GHW format"
  homepage "https://surfer-project.org/"
  url "https://gitlab.com/surfer-project/surfer.git",
      tag:      "v0.2.0",
      revision: "2d8dfae1e11aa9b843a3ee94ea99194417b36c59"
  license "EUPL-1.2"
  head "https://gitlab.com/surfer-project/surfer.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    (testpath/"test.vcd").write <<~EOS
      $timescale 1ns $end
      $scope module logic $end
      $var wire 3 # x $end
      $var wire 1 $ y $end
      $upscope $end
      $enddefinitions $end
      $dumpvars
      b000 #
      1$
      $end
      #0
      b001 #
      0$
      #250
      b110 #
      1$
      #500
    EOS

    token = "tokentoken"
    pid = fork { exec bin/"surfer", "server", "--file", "test.vcd", "--port", port.to_s, "--token", token }

    sleep 2

    output = shell_output("curl -S http://localhost:#{port}/#{token}")
    expected = "Surfer Remote Server"
    assert_includes output, expected
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
