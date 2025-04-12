class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v2.1.0",
        revision: "cab8d9b5c146a3f797b0511928c849d5fbd38824"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef70fb49ea5e91dc99638efe9df48f925e1224623d65224d7dccd841cb2f095f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e60d17031909fb4fe1694f647896b82161d5166e35190d30397df64cf7b0686f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61d4f3f668dcf62978edf297a8e111229d46e1a7b127b56a53ab0935057b0743"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3b9b242f2defe4e628b4ea0170cef97d7c3205ca5a5da62e95039655732308f"
    sha256 cellar: :any_skip_relocation, ventura:       "716a64ebc704ade83b19333e1f0dda6a0faaed8eeaf6abe61b4a6158acd9424a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad7821798d1383a555e1154d2e0ddc09dac42e36627d06875e88efa7f82127c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27c98d531aecf98ebad70037ad6fb312cf99097ca3b438b8249295ab89743d92"
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
