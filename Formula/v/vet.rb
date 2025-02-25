class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "39f091f7b1438b3405511d9388b02efdfb9c8bd4b35c43923263bcca283f2f1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "320fb9626a8f9e95531d32d08b8b6633b2ee7c1773ff254711152cc52b4d3d43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "876d4d400c62c15b4e5d2058bc4f8704004306d1e3ddc8cf4a70f5787fef3b47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5aa0f19a2bc1ac97e720c49b345e2148975f779fc562283682d5fbe95c0e39f"
    sha256 cellar: :any_skip_relocation, sonoma:        "37273a610da129f26d35aff87943101c026dc31f55d080c33ca292782c92cd42"
    sha256 cellar: :any_skip_relocation, ventura:       "6a0bbf988b41d592be50d32e069f84a2ad0380e77110a651b13272e61a9994c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e220c2c1882588d88a64520c0dd1b13e7cf6bf52cfd6cf591e2397bcd81ca49e"
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
