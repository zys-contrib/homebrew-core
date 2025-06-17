class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "3b6c7ca5efb42a20f89a52df48c40804e718b8b9c298de4fc45bf7a5a0d6ffe8"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c024e92a2cf84a339f2f4c5e161f3d4fedab26549e5727b0018646dbd4aa726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c024e92a2cf84a339f2f4c5e161f3d4fedab26549e5727b0018646dbd4aa726"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c024e92a2cf84a339f2f4c5e161f3d4fedab26549e5727b0018646dbd4aa726"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cd6288aa8ca3f0a5863e011b3bf52cec591c2a391278afaa8ca811e2c8a3abe"
    sha256 cellar: :any_skip_relocation, ventura:       "4cd6288aa8ca3f0a5863e011b3bf52cec591c2a391278afaa8ca811e2c8a3abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ab56c497fad4378cb894af4652167aba6cf898a7720d76cfa729a81c0a2f17"
  end

  depends_on "go" => :build

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/name), "./cmd/#{name}"
    end

    generate_completions_from_executable(bin/"buf", "completion")
    man1.mkpath
    system bin/"buf", "manpages", man1
  end

  test do
    (testpath/"invalidFileName.proto").write <<~PROTO
      syntax = "proto3";
      package examplepb;
    PROTO

    (testpath/"buf.yaml").write <<~YAML
      version: v1
      name: buf.build/bufbuild/buf
      lint:
        use:
          - STANDARD
          - UNARY_RPC
      breaking:
        use:
          - FILE
        ignore_unstable_packages: true
    YAML

    expected = <<~EOS
      invalidFileName.proto:1:1:Filename "invalidFileName.proto" should be \
      lower_snake_case.proto, such as "invalid_file_name.proto".
      invalidFileName.proto:2:1:Files with package "examplepb" must be within \
      a directory "examplepb" relative to root but were in directory ".".
      invalidFileName.proto:2:1:Package name "examplepb" should be suffixed \
      with a correctly formed version, such as "examplepb.v1".
    EOS
    assert_equal expected, shell_output("#{bin}/buf lint invalidFileName.proto 2>&1", 100)

    assert_match version.to_s, shell_output("#{bin}/buf --version")
  end
end
