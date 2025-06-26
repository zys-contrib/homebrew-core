class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/3.0.0.tar.gz"
  sha256 "88a0a6d04d6fae32ae7fe699c265b9ad9bfa04d11b69fd7aa50a83a2ff0a3dfb"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50906e317222d31946be69ec91f37015ac1148824be86699c0c0d3c4598f857f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e2b54f50292d3c3c1b8b252f7e292c92b54b69fe322ffc6c4800d561c6e9068"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e27dd96633d5a6f34ae32e4f6e7c2cf9e233bd46f5190b753abab8d5f699913b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6aed8c6844b6b0c68bd861166cfde23bd386bdedc04944aa9fb5dc19c6000091"
    sha256 cellar: :any_skip_relocation, ventura:       "65f8956c17815fc446238818ce7bf8f56531a32a96bd53866bff5e7d679c0586"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39160edb505676139437c89a81f18e5c00fda454041ed3968a543b7867a826c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76204d7e9e7e07e13f1da936729b1c41d04707421cea40fe5e399fbe22538a7c"
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
    assert_match "Invalid configuration", output
  end
end
