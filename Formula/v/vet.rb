class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "fd54b08430bdcf59a0ed396778995deae76ec1f5c301e9229c47f9cf6d580c60"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "249444c7f38b8256abd0adf0fd4e2c3b13cbf76c5411e97f255053b091b6fb5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e6f2195f07424f129b460e45bb04e6280d649e81aaf4843c22458e776e94a97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff4206c9216e64c1d981f6a0990a3dc2dda168185c141064c7b7938c3bf39204"
    sha256 cellar: :any_skip_relocation, sonoma:        "a78066b782a25c2e53a17e94575ed45a65c2f43cd619b5327019228d81aad4a3"
    sha256 cellar: :any_skip_relocation, ventura:       "97845182c5d9b25c1c51e2059807ac9f3c3ea318afbcd0c5abcaa1dd0c11af56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e39010f452931fbba4a6e5073b1bd3a93fc60bcf39234a0da13fdb4453159b82"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1", 1)

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
