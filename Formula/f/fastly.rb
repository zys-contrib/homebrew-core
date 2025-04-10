class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v11.2.0.tar.gz"
  sha256 "42e79c7059050baaed8b9b506962d98d29142ba26cf899e82a94f5bb72c04c90"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "167ae0bb6b2be0a17e14cfe6c27eef5a273fc0093b7f92ca3e32d8008b58f221"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "167ae0bb6b2be0a17e14cfe6c27eef5a273fc0093b7f92ca3e32d8008b58f221"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "167ae0bb6b2be0a17e14cfe6c27eef5a273fc0093b7f92ca3e32d8008b58f221"
    sha256 cellar: :any_skip_relocation, sonoma:        "af9e8df9f1f355a4f17063b353f38ba512c53c784add26f6024582da196b0d77"
    sha256 cellar: :any_skip_relocation, ventura:       "af9e8df9f1f355a4f17063b353f38ba512c53c784add26f6024582da196b0d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd8c92bb7af92d595b9cacc91261de787e200ca9e98259800e0da83d917c5d23"
  end

  depends_on "go" => :build

  def install
    mv ".fastly/config.toml", "pkg/config/config.toml"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip

    ldflags = %W[
      -s -w
      -X github.com/fastly/cli/pkg/revision.AppVersion=v#{version}
      -X github.com/fastly/cli/pkg/revision.GitCommit=#{tap.user}
      -X github.com/fastly/cli/pkg/revision.GoHostOS=#{os}
      -X github.com/fastly/cli/pkg/revision.GoHostArch=#{arch}
      -X github.com/fastly/cli/pkg/revision.Environment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/fastly"

    generate_completions_from_executable(bin/"fastly", shell_parameter_format: "--completion-script-",
                                                       shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastly version")

    output = shell_output("#{bin}/fastly service list 2>&1", 1)
    assert_match "Fastly API returned 401 Unauthorized", output
  end
end
