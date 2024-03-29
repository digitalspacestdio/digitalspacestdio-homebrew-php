require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php82Mongodb < AbstractPhp82Extension
  init
  desc "MongoDB driver for PHP."
  homepage "https://github.com/mongodb/mongo-php-driver"
  url "https://github.com/mongodb/mongo-php-driver/releases/download/1.15.1/mongodb-1.15.1.tgz"
  sha256 "b2038e778d71f45cadb8c93a30eb548e5c2c1e4f832807a775ed516b7816b749"
  head "https://github.com/mongodb/mongo-php-driver.git"
  version "1.15.1"
  revision PHP_REVISION

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d825399985f981f856d746b546107c2085420f4c49084ca79558682292fb6c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c93a2e265bfe5083aa995c56893320c6076920f017bb34278f3fe1148d96c411"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ae4f577433fedea81deabb9bd1ceb047dd1703ddd497f24d72f08e4462cb8a1"
    sha256 cellar: :any_skip_relocation, ventura:       "afecea0ac70909a6c026b4a5ed6ba5a0160a39e382cadf6b9c75ab98745c6e63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc2fb4af21611ab289641b614ed138e248135b1381a8a11d226b868178cb90e8"
  end

  depends_on "openssl"

  def install
    Dir.chdir "mongodb-#{version}" unless build.head?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--with-mongodb-ssl=openssl --with-mongodb-icu=#{Formula["digitalspacestdio/common/icu4c@72.1"].opt_prefix} --with-openssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make"
    prefix.install "modules/mongodb.so"
    write_config_file if build.with? "config-file"
  end
end
