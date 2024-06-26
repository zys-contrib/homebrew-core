class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://github.com/Macmod/godap/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "71cac1aaedc08ea2831ebc756e0277425000a9f7949b7ff80d9f38dc38d539f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b838faed1f39aa934aef887bf74b323384ef7fa51dfa57a3c2eea5d162b58bb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82ad27862569916d54b77dd530ae5517ced77e57bee695092b954f3fddd6afe7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d544f55d795e6ab9a4d640668c66ad90f3cf257dbdfac33c40d4cb24b6006736"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0fbbe2be9840a058ac84b6ed889b14b43a509e60df5c22c3f4d68ac4e85ba55"
    sha256 cellar: :any_skip_relocation, ventura:        "0fd1f12b7ed8eef84fc8e85ecf60d691a2bf5458aecedffe732cfe4d70c88b95"
    sha256 cellar: :any_skip_relocation, monterey:       "200a16d5b0bd1174ee9205b134f4aa5068d1db54841b3619d3aaaa384000337d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f01a3de351570cba29ef1979b07bcc107b91f8a2f48120cafb1d661c932c3c0"
  end

  depends_on "go" => :build

  # release version patch, upstream pr ref, https://github.com/Macmod/godap/pull/9
  patch do
    url "https://github.com/Macmod/godap/commit/db329a75cc801b5b524ba5fdc303b7b2eb917003.patch?full_index=1"
    sha256 "885de4f2dc192a3b16871ea7821b6e8638b8401b2ca3857c3ba69fa9a5987635"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"godap",  "completion")
  end

  test do
    output = shell_output("#{bin}/godap -T 1 203.0.113.1 2>&1", 1)
    assert_match "LDAP Result Code 200 \"Network Error\": dial tcp 203.0.113.1:389: i/o timeout", output

    assert_match version.to_s, shell_output("#{bin}/godap version")
  end
end
