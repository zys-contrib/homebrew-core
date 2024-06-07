class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https://github.com/soulspace-org/overarch"
  url "https://github.com/soulspace-org/overarch/releases/download/v0.20.0/overarch.jar"
  sha256 "ac9f3ad6024c74831f9ca5e7542ffcb54e8d028bba96508baa34a24b1068984e"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a468c7206e5b963ed8636373a837b6572c01bb883593abc92db4834bbb8ba66c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a468c7206e5b963ed8636373a837b6572c01bb883593abc92db4834bbb8ba66c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a468c7206e5b963ed8636373a837b6572c01bb883593abc92db4834bbb8ba66c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a468c7206e5b963ed8636373a837b6572c01bb883593abc92db4834bbb8ba66c"
    sha256 cellar: :any_skip_relocation, ventura:        "a468c7206e5b963ed8636373a837b6572c01bb883593abc92db4834bbb8ba66c"
    sha256 cellar: :any_skip_relocation, monterey:       "a468c7206e5b963ed8636373a837b6572c01bb883593abc92db4834bbb8ba66c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42f220cc7e17865c5d388eb7561fdc2b12486ee5d9691419ecad63d12f6abc1f"
  end

  head do
    url "https://github.com/soulspace-org/overarch.git", branch: "main"
    depends_on "leiningen" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "lein", "uberjar"
      jar = "target/overarch.jar"
    else
      jar = "overarch.jar"
    end

    libexec.install jar
    bin.write_jar_script libexec/"overarch.jar", "overarch"
  end

  test do
    (testpath/"test.edn").write <<~EOS
      \#{
        {:el :person
         :id :test-customer}
        {:el :system
         :id :test-system}
        {:el :rel
         :id :customer-uses-system
         :from :test-customer
         :to :test-system}
        {:el :context-view
         :id :test-context-view
         :ct [
              {:ref :test-customer}
              {:ref :test-system}
              {:ref :customer-uses-system}]}
        {:el :container-view
         :id :test-container-view
         :ct [
              {:ref :test-customer}
              {:ref :test-system}
              {:ref :customer-uses-system}]}}
    EOS
    expected = <<~EOS.chomp
      Model Warnings:
      {:unresolved-refs-in-views (), :unresolved-refs-in-relations ()}
      Model Information:
      {:namespaces {nil 3},
       :relations 1,
       :views-types {:container-view 1, :context-view 1},
       :external {:internal 3},
       :nodes-types {:person 1, :system 1},
       :nodes 2,
       :synthetic {:normal 3},
       :relations-types {:rel 1},
       :views 2}
    EOS
    assert_equal expected, shell_output("#{bin}/overarch --model-dir=#{testpath} --model-info").chomp
  end
end
