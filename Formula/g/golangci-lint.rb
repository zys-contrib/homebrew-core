class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.63.1",
        revision: "29809283a2eba3fb77007a50d76668998d13f0ab"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9ef681b7e3afdd636d5a89ced9bbd2d50de26af0ed8e3502775a091bd296ccb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0d8316a96811a655b55ce438cb6120004174c50b8e5a1026e6673366de2d411"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fabadce9b5e240b829c6db7fe1bd7501d8e65dde6953ea7dc9eaa69be2fe1c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdcd93bef31415aa87f5e483a2ea6489f3684d837427f95580932cc43fbe5090"
    sha256 cellar: :any_skip_relocation, ventura:       "7824566fc5f83acaf2083ae83957de82c851663ef16cb211d1abf0bc781ce8a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "041d59a36bc371a1fb5e479db51088301e489b4119bc843d5a9f046e2808d15b"
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
