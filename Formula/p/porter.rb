class Porter < Formula
  desc "App artifacts, tools, configs, and logic packaged as distributable installer"
  homepage "https://porter.sh"
  url "https://github.com/getporter/porter/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "927c88d7342439594b4f416f6d18d116afd2418bc48876efedeb1cc8e4716fda"
  license "Apache-2.0"
  head "https://github.com/getporter/porter.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31afcec22d4dd9f5fd1e659aa434e114cd7faad54eb78706d77437d8bf678497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31afcec22d4dd9f5fd1e659aa434e114cd7faad54eb78706d77437d8bf678497"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31afcec22d4dd9f5fd1e659aa434e114cd7faad54eb78706d77437d8bf678497"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ad4eeec835a2fd33908de7b1d103f8a85651b53acb890d70795cac58a16ffec"
    sha256 cellar: :any_skip_relocation, ventura:       "1ad4eeec835a2fd33908de7b1d103f8a85651b53acb890d70795cac58a16ffec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "524afbfbbaaf9936335ccf8ccfb290eaa181f415eacf550c23f4d6195b345da2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X get.porter.sh/porter/pkg.Version=#{version}
      -X get.porter.sh/porter/pkg.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/porter"
    generate_completions_from_executable(bin/"porter", "completion")
  end

  test do
    assert_match "porter #{version}", shell_output("#{bin}/porter --version")

    system bin/"porter", "create"
    assert_predicate testpath/"porter.yaml", :exist?
  end
end
