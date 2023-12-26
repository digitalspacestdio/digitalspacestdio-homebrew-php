require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php72Mongodb < AbstractPhp72Extension
  init
  desc "MongoDB driver for PHP."
  homepage "https://pecl.php.net/package/mongodb"
  url "https://github.com/mongodb/mongo-php-driver/releases/download/1.9.0/mongodb-1.9.0.tgz"
  sha256 "1a9e7117b749c2dd63bd3493bf38c24a9acd11646ec96a0d92ba6380eee0ab9a"
  head "https://github.com/mongodb/mongo-php-driver.git"
  version "1.9.0"
  revision 3

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a422cfd945e644e44d757f937e771fccf6294c72fb4edf61f91c31986c59b39b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4c129c718a8c8809c59ccd0b5372a8ac497ea8f880da8302b521855565d8450"
    sha256 cellar: :any_skip_relocation, ventura:       "4cbaf3ba001bd8a3a82a5f3250a663fab0b74cdf3650cd91f651ddaae79dbaac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b31b958d7beb399471fc0168772ac4a96b72afbef31733c1aa64e28f35cb9f0"
  end

  depends_on "openssl"
  depends_on "digitalspacestdio/common/icu4c@67.1"

  def install
    Dir.chdir "mongodb-#{version}" unless build.head?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--with-mongodb-ssl=openssl --with-mongodb-icu=#{Formula["digitalspacestdio/common/icu4c@67.1"].opt_prefix} --with-openssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make"
    prefix.install "modules/mongodb.so"
    write_config_file if build.with? "config-file"
  end
end
