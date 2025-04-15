class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/2.6.0.tar.gz"
  sha256 "fd53a83a0ba6dd9fffa4ef0e16a0b4ffbe8bb2e6ff0045d8d5425b6847ffc4e1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c5a5cc96a514acdac913dc255ab7f220a710e5c7b8adafbb4b0952f377359e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fee2508b228a6f59e20ffc58b58260a144daf51c9fbc502ebe0a8d35d0a6adcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ab1e4887225b8bde4dbc993aff1e05e26ad200a4b0fa1118c1f862c3173ed02"
    sha256 cellar: :any_skip_relocation, sonoma:        "90d088ec9fc360b3cbf9eba91ecf757a0b2d2a78e6f198a62cdc03613f1d1366"
    sha256 cellar: :any_skip_relocation, ventura:       "7a7f0979008123fc07bdd8b59ad1462e7546a2d7830dcd9f4f137ea626275476"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58b4fdf49b1c8938f2830e2ad2f7fcef90432008029f7ee601513062e3af9640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "341d3c856ad81ccf0cfa8cc6036ca6205e50255697e3d730be8b96de327d864a"
  end

  depends_on "rust" => :build

  def install
    # manifest set to 0.0.0 for some reason, matching upstream build behavior
    # https://github.com/ReagentX/imessage-exporter/blob/develop/build.sh
    inreplace "imessage-exporter/Cargo.toml", "version = \"0.0.0\"",
                                              "version = \"#{version}\""
    system "cargo", "install", *std_cargo_args(path: "imessage-exporter")
  end

  test do
    assert_match version.to_s, shell_output(bin/"imessage-exporter --version")
    output = shell_output(bin/"imessage-exporter --diagnostics 2>&1")
    assert_match "Invalid configuration: Database not found", output
  end
end
