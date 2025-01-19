class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.14.5.tar.gz"
  sha256 "3f3c8b3e3cb783a354b08eb53656fa82ca83cfd1eb833f1fdc075a94627f02ff"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dafd6a49b6e79ccc946671078f50f14cbb1d4c44682742bb9b96ef271bd20877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dafd6a49b6e79ccc946671078f50f14cbb1d4c44682742bb9b96ef271bd20877"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dafd6a49b6e79ccc946671078f50f14cbb1d4c44682742bb9b96ef271bd20877"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8aa6742657bf8cfcb1734a94d036c6a350bd9c489ff33151ea267e12bbfdb65"
    sha256 cellar: :any_skip_relocation, ventura:       "d8aa6742657bf8cfcb1734a94d036c6a350bd9c489ff33151ea267e12bbfdb65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "384c295bfd719f37599329389ec61307fa0bf3aac6989b8421acd14c3e19be54"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
