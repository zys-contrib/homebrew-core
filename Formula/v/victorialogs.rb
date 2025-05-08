class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.22.1-victorialogs.tar.gz"
  sha256 "f4ecd43d942490370b437d709712159a1c6f7228dcd66c143f8034f75be0a84c"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]victorialogs$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3060e406c55ba9370bf7ea9d58b58129c96a4334ba1e386af3ef398e7419a44b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b8052fc019fcd725a3967a3cff955ea134e01387e1bd4462ad6273ed08775f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3516d87ed1ae0987c634c18c39be8a6f6037bd509254cd0163f57057cae35cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b319212821c17f8c73b21852a8374c376456a52c70a439ef939c3eeeb2712d70"
    sha256 cellar: :any_skip_relocation, ventura:       "48a9f74a1c1df3bc40394cf4f563bfb6076580cb7030dfa772e201ab7260ac59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0f20cb8c3b3a0ec2f437639dab54795cfd149adeef887bc4896ae5bbe593ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bace3e5742c05d3271daa9888db202b1ae501dbdfbe99d4fc3dc22a85ff4774f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"victoria-logs"), "./app/victoria-logs"
  end

  service do
    run [
      opt_bin/"victoria-logs",
      "-httpListenAddr=127.0.0.1:9428",
      "-storageDataPath=#{var}/victorialogs-data",
    ]
    keep_alive false
    log_path var/"log/victoria-logs.log"
    error_log_path var/"log/victoria-logs.err.log"
  end

  test do
    http_port = free_port

    pid = fork do
      exec bin/"victoria-logs",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-storageDataPath=#{testpath}/victorialogs-data"
    end
    sleep 5
    assert_match "Single-node VictoriaLogs", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-logs --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
