class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.30.4.tar.gz"
  sha256 "1f6cd79458585d28f4458473dfa1c1aad73f5ac8d31b4946e8d89308ada2c3e6"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4420731677738d229d074f0148f0069935b82f669d8e8f80f00c72a9aa89c741"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4420731677738d229d074f0148f0069935b82f669d8e8f80f00c72a9aa89c741"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4420731677738d229d074f0148f0069935b82f669d8e8f80f00c72a9aa89c741"
    sha256 cellar: :any_skip_relocation, sonoma:        "28aebc8d97521e2a2f65d71b9e921a18dbbb66d5c66f3cbcf78f41a9ebb9a06f"
    sha256 cellar: :any_skip_relocation, ventura:       "28aebc8d97521e2a2f65d71b9e921a18dbbb66d5c66f3cbcf78f41a9ebb9a06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fd52be5a315830ab0f85121115ac606e3d67f5f4241cbcacfe0650e36f83f3b"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"bitrise.yml").write <<~YAML
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    YAML

    system bin/"bitrise", "setup"
    system bin/"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
