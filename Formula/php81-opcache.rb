require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php81Opcache < AbstractPhp81Extension
  init
  desc "OPcache improves PHP performance"
  homepage "https://php.net/manual/en/book.opcache.php"
  revision 1


  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de714c4a12a9aee3e220430a888b35ad829e489c0c0ece1a5d8da7d4c7ef182a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cda95c19e9e0e6517ad6bb1195c067ca300ecc64eb0d51e3d17955f315cf1fd"
  end

  depends_on "pcre"

  def extension_type
    "zend_extension"
  end

  def install
    Dir.chdir "ext/opcache"

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/opcache.so"
    write_config_file if build.with? "config-file"
  end
end
