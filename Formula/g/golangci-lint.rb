class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v2.0.1",
        revision: "e8927ce25c6178656a803d1edf35c9f3abf384ac"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69bafb867ab4f84c4218ce5b70a31761a660c63737ce1be7387bd26b17eb7e7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f698c4fff3e3ee7e3632da42410289e12caaea2c32c15f1cf6dbe80ff7cfebfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6af4de275c54cb51da8517912ab3f2516e23efe80db2e66536884ea1639b209"
    sha256 cellar: :any_skip_relocation, sonoma:        "87daf456e2c2a7eb170b2b1365021c07c16a5a520e0e3e9240692e3531211a6a"
    sha256 cellar: :any_skip_relocation, ventura:       "96cda0ae1662c1aab7b86736a71362c0c54ac557c67f9e803f180c99635192d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24ee643a0c6c9a77b61c65a18fb29b6687857290e3a6a853b9fe46057f814bb8"
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
