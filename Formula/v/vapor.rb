class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/refs/tags/19.0.0.tar.gz"
  sha256 "30bc592c82748459794be67b457a328f93afc9f6ecbd4ed9e267d1ff16456bf6"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b457b119c396cd83259510166ddf9d9cccf7b699052baf04ab94b63b19ac53f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2192519ec8d2181f08f86d0b735b9ce722612659e068481415c7483f4e1616a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28fab09761f167d57d34130f67925049db4bdb5002c0f3dbd75cb1027c4353d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b811fd0499f54a6fa4dd3397d608f2daabba985bdb68d88a6670ad50de149b5"
    sha256 cellar: :any_skip_relocation, ventura:       "839f36608641d08575dddcf5614850ffc9125459bb67c2560f52f70c990e0607"
    sha256                               x86_64_linux:  "421fd857c04941c7c5443faac4183e79cf919db6b2066668022a40fb57d0c78b"
  end

  uses_from_macos "swift", since: :sequoia # Swift 6.0

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "-Xswiftc", "-cross-module-optimization"
    bin.install ".build/release/vapor"
  end

  test do
    system bin/"vapor", "new", "hello-world", "-n"
    assert_path_exists testpath/"hello-world/Package.swift"
  end
end
