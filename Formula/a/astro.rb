class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "96e83b74a23001268c3ae567ea45cc794164f8cc839b65cd6fad1283447d0c95"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a0638b9dfff44818ae11438a036c2da643da1f5fc7c70e57cc3963404d680ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a0638b9dfff44818ae11438a036c2da643da1f5fc7c70e57cc3963404d680ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a0638b9dfff44818ae11438a036c2da643da1f5fc7c70e57cc3963404d680ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "054066b19b79ff8088d26498a8463d4ec3a9815d0ef5eb3a9acc25f8e7c0f0bc"
    sha256 cellar: :any_skip_relocation, ventura:       "054066b19b79ff8088d26498a8463d4ec3a9815d0ef5eb3a9acc25f8e7c0f0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cde35be597f90f75aa6758ee94eecff08f5ab1bf7891c4689bbd38724d6b92c6"
  end

  depends_on "go" => :build
  on_macos do
    depends_on "podman"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", "completion")
  end

  test do
    version_output = shell_output("#{bin}/astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    mkdir testpath/"astro-project"
    cd testpath/"astro-project" do
      run_output = shell_output("#{bin}/astro dev init")
      assert_match "Initialized empty Astro project", run_output
      assert_path_exists testpath/".astro/config.yaml"
    end

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io --token-login=test", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
