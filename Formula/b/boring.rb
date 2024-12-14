class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://github.com/alebeck/boring"
  url "https://github.com/alebeck/boring/archive/refs/tags/0.9.0.tar.gz"
  sha256 "d260f3285d850f41945d6760f0b1147fa1e0dab339a8ff9cbcf693911973d71f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f1535d54c08e5704412485bbe340894b4be38cf42362b3cfee36cd99236227d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f1535d54c08e5704412485bbe340894b4be38cf42362b3cfee36cd99236227d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f1535d54c08e5704412485bbe340894b4be38cf42362b3cfee36cd99236227d"
    sha256 cellar: :any_skip_relocation, sonoma:        "56983107e47e4e9da688c8fc3aa2abdd4fffba4942cbe6990f7993bed243aec0"
    sha256 cellar: :any_skip_relocation, ventura:       "56983107e47e4e9da688c8fc3aa2abdd4fffba4942cbe6990f7993bed243aec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "601d2506c354e0ceaa4baba58b9ad03cb6bc3b40616ed5bd3bdc1a97dc655fa8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/boring"
  end

  def post_install
    quiet_system "killall", "boring"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/".boring.toml").write <<~TOML
      [[tunnels]]
      name = "dev"
      local = "9000"
      remote = "localhost:9000"
      host = "dev-server"
    TOML

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"boring", "list", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "dev   9000   ->  localhost:9000  dev-server", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
