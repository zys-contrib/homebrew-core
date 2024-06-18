class Kor < Formula
  desc "CLI tool to discover unused Kubernetes resources"
  homepage "https://github.com/yonahd/kor"
  url "https://github.com/yonahd/kor/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "52c9930ed136339f359143a6ceac97333d2bbd7e0ecc2d65067a6edf87eeb6f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2381d470bef2cb8c3babae6ef47c114fe197e3d90d5c8b3f82440c2c21475b36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dede682dd92cc87a494ad9fb42b000716914417b1019a56b575c234da5d16538"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88199c65b7b8b38df7fb1be0679511b302efd77e594aeda4c3595130a94d062d"
    sha256 cellar: :any_skip_relocation, sonoma:         "05222216cdc7db22d6e183c33c306c042c628a551a659ddcd299e86149bf2723"
    sha256 cellar: :any_skip_relocation, ventura:        "591a884f06d9a6b07895f5287d1948eddb29815ee73d4a6ffbfe7a01e648c30b"
    sha256 cellar: :any_skip_relocation, monterey:       "72c6b239ef7c1f468f53253d38beccdfdd43383cd8e91b545d588e6f3bcca045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff736049546472015bd04cba044629d349fa0b952c4b805c1d205931658fc6ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"mock-kubeconfig").write <<~EOS
      apiVersion: v1
      clusters:
        - cluster:
            server: https://mock-server:6443
          name: mock-server:6443
      contexts:
        - context:
            cluster: mock-server:6443
            namespace: default
            user: mockUser/mock-server:6443
          name: default/mock-server:6443/mockUser
      current-context: default/mock-server:6443/mockUser
      kind: Config
      preferences: {}
      users:
        - name: kube:admin/mock-server:6443
          user:
            token: sha256~QTYGVumELfyzLS9H9gOiDhVA2B1VnlsNaRsiztOnae0
    EOS
    out = shell_output("#{bin}/kor all -k #{testpath}/mock-kubeconfig 2>&1", 1)
    assert_match "Failed to retrieve namespaces: Get \"https://mock-server:6443/api/v1/namespaces\"", out
  end
end
