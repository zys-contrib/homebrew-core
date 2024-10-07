class ProtocGenGo < Formula
  desc "Go support for Google's protocol buffers"
  homepage "https://github.com/protocolbuffers/protobuf-go"
  url "https://github.com/protocolbuffers/protobuf-go/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "7cead1a711d682796b343931a9b54b3b07dd83456baeda6c069432235de45437"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d0fcc47b3e8d35f322311d8845843ea030105c38112902a3ac2fd9186288673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d0fcc47b3e8d35f322311d8845843ea030105c38112902a3ac2fd9186288673"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d0fcc47b3e8d35f322311d8845843ea030105c38112902a3ac2fd9186288673"
    sha256 cellar: :any_skip_relocation, sonoma:        "c02ff346ec303a9509476b5a012b3ed182ec1e6d55591488d6f13afebddac340"
    sha256 cellar: :any_skip_relocation, ventura:       "c02ff346ec303a9509476b5a012b3ed182ec1e6d55591488d6f13afebddac340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49e9be945daf7528b0d15ab6981b1bb7e33c882c3034a090b26c33ebc9b4b749"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/protoc-gen-go"
  end

  test do
    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;
      option go_package = "package/test";
      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS
    system "protoc", "--go_out=.", "--go_opt=paths=source_relative", "proto3.proto"
    assert_predicate testpath/"proto3.pb.go", :exist?
    refute_predicate (testpath/"proto3.pb.go").size, :zero?
  end
end
