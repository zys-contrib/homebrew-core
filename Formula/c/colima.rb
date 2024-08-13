class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.7.3",
      revision: "a66b375e8df84ff2860797efc683e66632bcbce3"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a9b62e068326742de2c2949d71a99e8baff3516d7cb54876a9a4a8058669049"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f496bd4293aec26efe4d5c1732ea1daa11a453c029724f2a46098c96d7d9afb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85b569d42ac60727ec18f2a3578df7f0c4fd83892c1b8288028f61c0737623e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "05fd801fbec2e6630a7d594018bed1cfeae78a57390f7ffca2cbf533a86c1e31"
    sha256 cellar: :any_skip_relocation, ventura:        "31e7df56334af27005cee28c95e529937440f93d3b1124fb5ff4d499c5b31362"
    sha256 cellar: :any_skip_relocation, monterey:       "e61051b0ca058fbfa290c5d1982ea870e30cdfeaed408991f7526ce0287ae498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b9be9833f6e8a7b602bf21d2fbb4b1635469dd5deb8ddf47a5071f278103ace"
  end

  depends_on "go" => :build
  depends_on "lima"

  def install
    project = "github.com/abiosoft/colima"
    ldflags = %W[
      -s -w
      -X #{project}/config.appVersion=#{version}
      -X #{project}/config.revision=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/colima"

    generate_completions_from_executable(bin/"colima", "completion")
  end

  service do
    run [opt_bin/"colima", "start", "-f"]
    keep_alive successful_exit: true
    environment_variables PATH: std_service_path_env
    error_log_path var/"log/colima.log"
    log_path var/"log/colima.log"
    working_dir Dir.home
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/colima version 2>&1")
    assert_match "colima is not running", shell_output("#{bin}/colima status 2>&1", 1)
  end
end
