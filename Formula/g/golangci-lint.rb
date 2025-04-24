class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v2.1.3",
        revision: "ce777622c61db6fbcc8c5d1c6c733eb97829bfa3"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b2672e5df5f2d1be64d5b90b8c70f23af21f24b2103cf95ceb7df19005ec74f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7020280c3f4e6c7ee0bf5e808f047df35578a0e429908f19a5c38c4da22efcea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78ff31b259eb391e20c8699b7cac9b3cf4f104fbf3aa0931d7b670da5a53382a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ba2fccbc883a9eec14669f961382cab5f6b1c6da58afc7580f296cec007f1ac"
    sha256 cellar: :any_skip_relocation, ventura:       "add6dc076a031cff74f9ab7ca5ee887b64b5748688d25974b1a7c16a4842608b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d55e6c65c62f7158711aa5369c1db93211c7c4667b6f68b662df1f3dd2fcd2a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ba07ce3c7535b00e769571e4c63e515bb30e7f4538179943f7b4bfae12035b6"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", "completion")
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output(bin/"golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~GO
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        clear(nums)
        return
      }
    GO

    args = %w[
      --color=never
      --default=none
      --issues-exit-code=0
      --output.text.print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func add is unused (unused)"
    assert_match expected_message, ok_test
  end
end
