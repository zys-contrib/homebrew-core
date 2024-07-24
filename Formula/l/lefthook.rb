class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "c00bb14f8644156cc4d22b8fad6d502b4dc66e0eacceab196ab3017fca936560"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edd68b6938649c0b2eba37be3d9682584a55bba574f6eff8e742f78e90322969"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db7089376018405c49746b5dc9af06a8c86991986d8b4087fff05b2cbb635ce9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e551881de62a5c07f8c0a5d28497121d1c2c8b873790c275a0b87709e6ba8567"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc57dce3829875067267a0d55288470a563a7aa3d695328ac83b50ad8e6da375"
    sha256 cellar: :any_skip_relocation, ventura:        "1268f8e86072e85c1978a4b2dc61d9aac5611d695868ac5210e26fa3e5aeb795"
    sha256 cellar: :any_skip_relocation, monterey:       "063c5fbdb3ebda3996cf99b3c66c4d1c56f794ae3210b04801b833d72aca3144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e3a93d0474cfcb067b5ffecd417c988e53afc5eaf7279b4c8831140d75e913"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
