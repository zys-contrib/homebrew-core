class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.4.2/traefik-v3.4.2.src.tar.gz"
  sha256 "a30b7a70a7a7cfca4c87ebd73fe7d3726c83f84047ac3ee997e7d4ca42446de6"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "195ff71ed7294b0d9c3a0059572720076d78e8751fbc8a393656c692c49bd3c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "195ff71ed7294b0d9c3a0059572720076d78e8751fbc8a393656c692c49bd3c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "195ff71ed7294b0d9c3a0059572720076d78e8751fbc8a393656c692c49bd3c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "91f62f5c562908a1885f51fde90ad8e21e2b015b556315286dcc6283df31f21e"
    sha256 cellar: :any_skip_relocation, ventura:       "91f62f5c562908a1885f51fde90ad8e21e2b015b556315286dcc6283df31f21e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07ef81cdcdf65663ac5b2e8ef52bfda81b8a5b0576549e11ba104cfcb03d3af3"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    cd "webui" do
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end
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

      # Make sure webui assets for dashboard are present at expected destination
      cmd_ui = "curl -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "<title>Traefik</title>", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
