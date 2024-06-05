class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.4.5.tar.gz"
  sha256 "e0d5ffb3ddd5e98092f29e908edb64468b1d8b40af78281cc0054b26f542a48b"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3719a08cef21fe4fea8fdbd5fbc4249503bf846614a9a8cbecc641fa443fc0e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5f6a9ffd7d44c711558c96e1ff69a2edc3df3ff98be6e389588c725b054ff3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d616e85d10861c28b86fa6f1e5fa3f42deaeb56644150aaa440ed31d3f258f73"
    sha256 cellar: :any_skip_relocation, sonoma:         "8505b7e303f440e7f9892091713a9bdd2be3e09df7a65b5963b34d0058189c0d"
    sha256 cellar: :any_skip_relocation, ventura:        "b807e785f5e7f06a5ff19fdea37049fc182c473d4561a9454bb500cea1e5ebdf"
    sha256 cellar: :any_skip_relocation, monterey:       "8a135de70cca62b8f75b5d61f47366c5e4a6fb1aa7137b70eca0e8d87b707dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6bb4ef62e09ec123e18cc059603a537b1c13a2ed1348de5140031f23beddac6"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/apernet/hysteria/app/v2/cmd"
    ldflags = %W[
      -s -w
      -X #{pkg}.appVersion=v#{version}
      -X #{pkg}.appDate=#{time.iso8601}
      -X #{pkg}.appType=release
      -X #{pkg}.appCommit=#{tap.user}
      -X #{pkg}.appPlatform=#{OS.kernel_name.downcase}
      -X #{pkg}.appArch=#{Hardware::CPU.arch}
    ]
    system "go", "build", *std_go_args(ldflags:), "./app"

    generate_completions_from_executable(bin/"hysteria", "completion")
  end

  service do
    run [opt_bin/"hysteria", "--config", etc/"hysteria/config.yaml"]
    run_type :immediate
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"config.yaml").write <<~EOS
      listen: :#{port}
      acme:
        domains:
          - your.domain.com
        email: your@email.com

      obfs:
        type: salamander
        salamander:
          password: cry_me_a_r1ver
    EOS
    output = shell_output("#{bin}/hysteria server --disable-update-check -c #{testpath}/config.yaml 2>&1", 1)
    assert_match "maintenance	started background certificate maintenance", output

    assert_match version.to_s, shell_output("#{bin}/hysteria version")
  end
end
