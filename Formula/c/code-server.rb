class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.99.1.tgz"
  sha256 "88e48dff2a244786621fe82963f73f4c5b2e1dc19684cd5e26e8e3d4faf84341"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5afd8a6c7501822bda8f8a82c7336b5376051b962c14dbed16f532fa50e26ccf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1652f082f9be8c17e306eda9c0e382f093e2bce0dfc05bba67f44533c4d4de05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ed5ae6a2e7ce4c36f29f44273898b3c418da19c8fca5587ea52df24c9ccfca3"
    sha256 cellar: :any_skip_relocation, sonoma:        "106f4fa2ea5e64335f49df3f138f8d5555ae34037f467b4936145f2caf1fc5d9"
    sha256 cellar: :any_skip_relocation, ventura:       "ba1efaaf0a8e9c4741c2996b0d7d025d8a9930b207188de4536de409922d7cda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25e8cdddeb84cdaf65b3099a131caad5140dc94f0369908ea847018cc4f7c86b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a6c8f6e507c58d11f5d6791ccc738b04aca37ba25e0a6dca0ea08227e9596fa"
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
