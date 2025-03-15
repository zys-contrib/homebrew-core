class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.98.2.tgz"
  sha256 "37d4ab6edfbefb5bbe4074cf3b6a3a5fa5cbd42eb273f324bf4bd70c3a801688"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db1ff6e44c669733800b8ab17ebb64f2c80556911845fdeaec87979654a9502a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4f718c68c8a4f7440e0d3db80bf0f199be4b8f2cbef0777a957447d67a9eaf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd3c58f35525381ccf262702ddc5775d50ccfb70b42a32ebdebf472d5674bfd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a7d9253f895b78e2382e909feab46aded4f1eb094b92f702d240537163314ba"
    sha256 cellar: :any_skip_relocation, ventura:       "275b54e51cee39cc2d2b6892528b0a1dcb52d329deb5321db9c84ac2ba4fdb2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb219a28578b17d019ea246242b0cf7bd427e4136934da6ee8454841ddfefa6"
  end

  depends_on "node@20"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "pkgconf" => :build
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
