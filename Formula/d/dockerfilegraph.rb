class Dockerfilegraph < Formula
  desc "Visualize your multi-stage Dockerfiles"
  homepage "https://github.com/patrickhoefler/dockerfilegraph"
  url "https://github.com/patrickhoefler/dockerfilegraph/archive/refs/tags/v0.17.12.tar.gz"
  sha256 "69023532265c701cfbde3e6eedc14c7119964e873fa4a0a812200ea45268ecd5"
  license "MIT"
  head "https://github.com/patrickhoefler/dockerfilegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d0798d500cb4af3cb36efeb6b06a9ff5dd678e5a882743463ce7d5a75a35204"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d0798d500cb4af3cb36efeb6b06a9ff5dd678e5a882743463ce7d5a75a35204"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d0798d500cb4af3cb36efeb6b06a9ff5dd678e5a882743463ce7d5a75a35204"
    sha256 cellar: :any_skip_relocation, sonoma:        "75f9716145a142a5c073dbe76e8fbf0c8dffd683c3dc65b5cc47ee89bdaa50fc"
    sha256 cellar: :any_skip_relocation, ventura:       "75f9716145a142a5c073dbe76e8fbf0c8dffd683c3dc65b5cc47ee89bdaa50fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8daef23fb06b8555dce020ba348e386e2be81ce864ca28545065622c4764ae0"
  end

  depends_on "go" => :build
  depends_on "graphviz"

  def install
    ldflags = %W[
      -s -w
      -X github.com/patrickhoefler/dockerfilegraph/internal/cmd.gitVersion=#{version}
      -X github.com/patrickhoefler/dockerfilegraph/internal/cmd.gitCommit=#{tap.user}
      -X github.com/patrickhoefler/dockerfilegraph/internal/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerfilegraph --version")

    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine AS base
      RUN echo "Hello, World!" > /hello.txt

      FROM base AS final
      COPY --from=base /hello.txt /hello.txt
    DOCKERFILE

    output = shell_output("#{bin}/dockerfilegraph --filename Dockerfile")
    assert_match "Successfully created Dockerfile.pdf", output
    assert_path_exists testpath/"Dockerfile.pdf"
  end
end
