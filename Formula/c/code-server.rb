class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.101.0.tgz"
  sha256 "8dfbeef284313285e54e2a02608f90d83a35a20fa23120844b3f40c3f944d8d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f723acaa56b719eb0115a0fece6140f067234f815ee2fd1bc0e2a855da12f404"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7bd492cf7113271c5d7a594e926cf893a3dbc4c38d9ad0daef4914a7c61b701"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f0398e4ccc61c27fb64848fc0ccc536450110b43592559e38b02c5957da0102"
    sha256 cellar: :any_skip_relocation, sonoma:        "753423a6fb6c567ac0465ff43188453c2b0d14cea596bff8fdcb99e105b5b4ad"
    sha256 cellar: :any_skip_relocation, ventura:       "1793924c824540491f5b8b600d0d3601e57ec59b7e86ec7fe6f692392ceea41b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b39aa7c39cd1304ca9f67e9e9781683bd98f852cda7139e2a176b483441c4f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a12d6cab8914f3fa26a8c402cc34bba8249a33619bd9f8a7d1ae1df1dcd8f843"
  end

  depends_on "pkgconf" => :build
  depends_on "node@22"
  uses_from_macos "python" => :build

  on_linux do
    depends_on "krb5"
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    # Fix broken node-addon-api: https://github.com/nodejs/node/issues/52229
    ENV.append "CXXFLAGS", "-DNODE_API_EXPERIMENTAL_NOGC_ENV_OPT_OUT"

    system "npm", "install", *std_npm_args(prefix: false), "--unsafe-perm", "--omit", "dev"

    libexec.install Dir["*"]
    bin.install_symlink libexec/"out/node/entry.js" => "code-server"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    vscode = libexec/"lib/vscode/node_modules/@parcel"
    permitted_dir = OS.linux? ? "watcher-#{os}-#{arch}-glibc" : "watcher-#{os}-#{arch}"
    vscode.glob("watcher-*").each do |dir|
      next unless (Pathname.new(dir)/"watcher.node").exist?

      rm_r(dir) if permitted_dir != dir.basename.to_s
    end
  end

  def caveats
    <<~EOS
      The launchd service runs on http://127.0.0.1:8080. Logs are located at #{var}/log/code-server.log.
    EOS
  end

  service do
    run opt_bin/"code-server"
    keep_alive true
    error_log_path var/"log/code-server.log"
    log_path var/"log/code-server.log"
    working_dir Dir.home
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/code-server --version")

    port = free_port
    output = ""

    PTY.spawn "#{bin}/code-server --auth none --port #{port}" do |r, _w, pid|
      sleep 3
      Process.kill("TERM", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    ensure
      Process.wait(pid)
    end
    assert_match "HTTP server listening on", output
    assert_match "Session server listening on", output
  end
end
