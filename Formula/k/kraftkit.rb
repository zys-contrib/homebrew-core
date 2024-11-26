class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "919b86d44232ca443dee7b7be547fa6983036ac9dd3c11a0b744c1a6799af550"
  license "BSD-3-Clause"

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "btrfs-progs"
  end

  def install
    ldflags = %W[
      -s -w
      -X kraftkit.sh/internal/version.version=#{version}
      -X kraftkit.sh/internal/version.commit=#{tap.user}
      -X kraftkit.sh/internal/version.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"kraft"), "./cmd/kraft"

    generate_completions_from_executable(bin/"kraft", "completion", base_name: "kraft")
  end

  test do
    expected = if OS.mac?
      "could not determine hypervisor and system mode"
    else
      "found unikraft.org/helloworld:latest (qemu/x86_64)"
    end
    assert_match expected, shell_output("#{bin}/kraft run unikraft.org/helloworld:latest 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/kraft version")
  end
end
