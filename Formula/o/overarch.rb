class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https://github.com/soulspace-org/overarch"
  url "https://github.com/soulspace-org/overarch/releases/download/v0.29.0/overarch.jar"
  sha256 "d91142150604aafe8a7f45edf6496a12ab5e32be314fb0b461b789ea304c3de8"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6f29ccbfb5489e0885ca80adadc915654bff61a4710c4ca208e2f5738cb21b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6f29ccbfb5489e0885ca80adadc915654bff61a4710c4ca208e2f5738cb21b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6f29ccbfb5489e0885ca80adadc915654bff61a4710c4ca208e2f5738cb21b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6f29ccbfb5489e0885ca80adadc915654bff61a4710c4ca208e2f5738cb21b3"
    sha256 cellar: :any_skip_relocation, ventura:        "f6f29ccbfb5489e0885ca80adadc915654bff61a4710c4ca208e2f5738cb21b3"
    sha256 cellar: :any_skip_relocation, monterey:       "f6f29ccbfb5489e0885ca80adadc915654bff61a4710c4ca208e2f5738cb21b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c431519e3287d346f1e12e51080801e9cb2e8f3945255419c27e74627c68883"
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
      {:nodes-by-type-count {:person 1, :system 1},
       :nodes-count 2,
       :views-by-type-count {:container-view 1, :context-view 1},
       :relations-by-type-count {:rel 1},
       :views-count 2,
       :elements-by-namespace-count {nil 3},
       :relations-count 1,
       :synthetic-count {:normal 3},
       :external-count {:internal 3}}
    EOS
    assert_equal expected, shell_output("#{bin}/overarch --model-dir=#{testpath} --model-info").chomp
  end
end
