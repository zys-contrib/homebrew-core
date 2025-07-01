class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "6be05ebfd0106c58d7e507053344bdda2f6a874e023c242c31821461818bcea0"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5701b42d590631056c475c0011947e5766897f3c41e6ea8165910662c6489c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3ce0053cfd43fc3b4a58a5ba2cbfb251e8b59060ab5c9046805095803850681"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adc2a585532a42a79b330fb94bfbfc6bcc09210dc62a6a45ca3ea5005da9fcdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2470f10b54d64c733a4835a42fe291882af20fe6fa8d8fe4a9c5942360d44a2a"
    sha256 cellar: :any_skip_relocation, ventura:       "de28951edaea27cf0eca7fbea60158a04975ead255e3512a2fb7a475e1190993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b73eb9bbe628a16046c75ac7c030a6dbb826550f9796be9f64b4d365eb9ac50e"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "podman"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", "completion")
  end

  test do
    version_output = shell_output("#{bin}/astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    mkdir testpath/"astro-project"
    cd testpath/"astro-project" do
      run_output = shell_output("#{bin}/astro config set -g container.binary podman")
      assert_match "Setting container.binary to podman successfully", run_output
      run_output = shell_output("#{bin}/astro dev init")
      assert_match "Initialized empty Astro project", run_output
      assert_path_exists testpath/".astro/config.yaml"
    end

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io --token-login=test", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
