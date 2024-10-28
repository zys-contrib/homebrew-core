class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.2.0/traefik-v3.2.0.src.tar.gz"
  sha256 "2c9a788a6207350999a49cc086e456f1287233df3000a25e1147d7b935dc99f2"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7158155f7336491b25879759d994f0f12ed134b296a2d291a4001986eb030ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7158155f7336491b25879759d994f0f12ed134b296a2d291a4001986eb030ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7158155f7336491b25879759d994f0f12ed134b296a2d291a4001986eb030ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "defc5a0d1115defa27c04576ba9cb7e5fd8098f0b1900db9019098f9c9da1541"
    sha256 cellar: :any_skip_relocation, ventura:       "defc5a0d1115defa27c04576ba9cb7e5fd8098f0b1900db9019098f9c9da1541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eab2903f4c4ad76b790e704acf21794aca2b1aba6089459339d457441d8d829"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:), "./cmd/traefik"
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc}/traefik/traefik.toml"]
    keep_alive false
    working_dir var
    log_path var/"log/traefik.log"
    error_log_path var/"log/traefik.log"
  end

  test do
    ui_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~TOML
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    TOML

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 8
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
