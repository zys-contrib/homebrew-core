class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.64.3",
        revision: "09167d709ffc36a06517334ed4af8766c858de51"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f3b7fcb19ef2acb37ff3929ca9b0e9563465f4b44564f198d12f6ceeec80dd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2dae99aace62ebd4690d6fd467a9ad05da33ca13970d9da66951d3378bfb969"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b52f2de2fe406198527fcf229c7ee2753ac7cceb25641fb9ffe1beeca62f74ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bcafbd04caedb1c205a448243b8ef52a4c95622e5397b40f090f9724c1c30d5"
    sha256 cellar: :any_skip_relocation, ventura:       "bdc3f14e8e7afe85042668f77af010bbd1d608a5a569f84c278e27b0e1be7538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97f8013c30f034a7e6d47ef54930e81e2bc3c4ac5a352457c0d299bc4e8dee7b"
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
      --disable-all
      --issues-exit-code=0
      --print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func `add` is unused (unused)"
    assert_match expected_message, ok_test
  end
end
