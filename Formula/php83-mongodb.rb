require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php83Mongodb < AbstractPhp83Extension
  init PHP_VERSION, true
  desc "MongoDB driver for PHP."
  homepage "https://github.com/mongodb/mongo-php-driver"
  url "https://github.com/mongodb/mongo-php-driver/releases/download/1.15.1/mongodb-1.15.1.tgz"
  sha256 "b2038e778d71f45cadb8c93a30eb548e5c2c1e4f832807a775ed516b7816b749"
  head "https://github.com/mongodb/mongo-php-driver.git"
  revision PHP_REVISION

  bottle do
    root_url "https://pub-7d898cd296ae4a92a616d2e2c17cdb9e.r2.dev/php/8.3.14-106"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63b0e60fd3e422c5c6fade9ee56778657532f79600ab13e395c6db39e123104d"
    sha256 cellar: :any_skip_relocation, ventura:       "457dd2dbe7acd431660e11399c6ed147417de0b32d8085ac5bcc10aa4a6e2da2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "002684f3a619d08540125314376eacbaf69fe5b9459713352b5caf3fc51f574b"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "566d35bec0a210e2b12b1ee8426b8cffe5d0865c73465b2a8c477cb9b87bc28c"
  end

  depends_on "openssl"
  depends_on "digitalspacestdio/common/icu4c@74.2"

  def install
    Dir.chdir "mongodb-#{version}" unless build.head?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--with-mongodb-ssl=openssl --with-mongodb-icu=#{Formula["digitalspacestdio/common/icu4c@74.2"].opt_prefix} --with-openssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make"
    prefix.install "modules/mongodb.so"
    write_config_file if build.with? "config-file"
  end
end
