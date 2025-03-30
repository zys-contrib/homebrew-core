class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "698c65b1696b4344dc5f05638a9cfd426b2990f43f22b497ebb70f5eb708b16d"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eabaa816117f62d6e5dff1812a5ced0934c7401ccbdf967c307a032a218a4c8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eabaa816117f62d6e5dff1812a5ced0934c7401ccbdf967c307a032a218a4c8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eabaa816117f62d6e5dff1812a5ced0934c7401ccbdf967c307a032a218a4c8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "55a31bdfb0fe01fe23cff6cecd96f5c27a0a1f8c532fa516feb516c973ce034e"
    sha256 cellar: :any_skip_relocation, ventura:       "55a31bdfb0fe01fe23cff6cecd96f5c27a0a1f8c532fa516feb516c973ce034e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0660bfaa8231eb14be13bdb8eaf69b9646710ea3e391d8eba90ce13618cc3f08"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"), "./cmd/vals"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vals version")

    (testpath/"test.yaml").write <<~YAML
      foo: "bar"
    YAML
    output = shell_output("#{bin}/vals eval -f test.yaml")
    assert_match "foo: bar", output

    (testpath/"secret.yaml").write <<~YAML
      apiVersion: v1
      kind: Secret
      metadata:
        name: test-secret
      data:
        username: dGVzdC11c2Vy # base64 encoded "test-user"
        password: dGVzdC1wYXNz # base64 encoded "test-pass"
    YAML

    output = shell_output("#{bin}/vals ksdecode -f secret.yaml")
    assert_match "stringData", output
    assert_match "username: test-user", output
    assert_match "password: test-pass", output
  end
end
