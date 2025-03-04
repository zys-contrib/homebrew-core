class Yutu < Formula
  desc "Fully functional CLI for YouTube"
  homepage "https://github.com/eat-pray-ai/yutu"
  url "https://github.com/eat-pray-ai/yutu.git",
      tag:      "v0.9.8",
      revision: "9c6e73e0ab60f427587295b9360ce32e09451a4b"
  license "MIT"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  depends_on "go" => :build

  def install
    mod = "github.com/eat-pray-ai/yutu/cmd"
    ldflags = %W[-w -s
                 -X #{mod}.Os=#{OS.mac? ? "darwin" : "linux"}
                 -X #{mod}.Arch=#{Hardware::CPU.arch}
                 -X #{mod}.Version=v#{version}
                 -X #{mod}.Commit=#{Utils.git_short_head(length: 7)}
                 -X #{mod}.CommitDate=#{time.iso8601}]
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    version_output = shell_output("#{bin}/yutu version 2>&1")
    assert_match "yutu🐰 version v#{version}", version_output
    auth_output = shell_output("#{bin}/yutu auth 2>&1", 1)
    assert_match "Please configure OAuth 2.0", auth_output
  end
end
