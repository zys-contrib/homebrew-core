class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.22.3/gitea-src-1.22.3.tar.gz"
  sha256 "226291c16bc750c5d8953a7c16858ec5e8d87751308d25ffbbe75210f45215c2"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1d903ee587706764e32512c64c37888d4293e73c28dfb4a0a2c0ee274f47e702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16cf197b131178919dcec319b1b87708ba9e59788c97027ad51de9bac166b955"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a86c680306aa40c3f70fee172c3c5b9ef17886ddd132c6db0b8023b81780968"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b09289b1c04a17ca817974bd2799d3a4737e97de248d870eb55ea2c66278ab1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c75ef5bf90ee3c2e0187d30b2c5c6ac1043f809f21af10560b5749677bd4e08"
    sha256 cellar: :any_skip_relocation, ventura:        "834e21d8e893618a0e3a6c11dcf25be9767e29e761e8b2a8488f4098775d2277"
    sha256 cellar: :any_skip_relocation, monterey:       "5fbc15deb88378967dc8dde6038746644a7fea06d096dea876dcebe3b2802714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "359bb20a11ed58edfe9dfd547474e0a635bc1be63b0283b7edcc05813a183ec0"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "sqlite"

  def install
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea"
  end

  service do
    run [opt_bin/"gitea", "web", "--work-path", var/"gitea"]
    keep_alive true
    log_path var/"log/gitea.log"
    error_log_path var/"log/gitea.log"
  end

  test do
    ENV["GITEA_WORK_DIR"] = testpath
    port = free_port

    pid = fork do
      exec bin/"gitea", "web", "--port", port.to_s, "--install-port", port.to_s
    end
    sleep 5

    output = shell_output("curl -s http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl -s http://localhost:#{port}/")
    assert_match "Installation - Gitea: Git with a cup of tea", output

    assert_match version.to_s, shell_output("#{bin}/gitea -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
