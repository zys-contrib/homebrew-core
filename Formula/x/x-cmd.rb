class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "5142bc8572200191ed1698ee0678dcc87f97190ed435c44345aaa9ad6342b969"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9e9d45759eb975546409d87239bc4dc4481bfcf5ede5c671a41847d4e95179b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9e9d45759eb975546409d87239bc4dc4481bfcf5ede5c671a41847d4e95179b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9e9d45759eb975546409d87239bc4dc4481bfcf5ede5c671a41847d4e95179b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4412b5da947a0c7fdb8c2a29b931bbf6653a94d924c303532864d4649196673e"
    sha256 cellar: :any_skip_relocation, ventura:       "4412b5da947a0c7fdb8c2a29b931bbf6653a94d924c303532864d4649196673e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9e9d45759eb975546409d87239bc4dc4481bfcf5ede5c671a41847d4e95179b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9e9d45759eb975546409d87239bc4dc4481bfcf5ede5c671a41847d4e95179b"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end
