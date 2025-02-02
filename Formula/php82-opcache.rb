require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php82Opcache < AbstractPhp82Extension
  init PHP_VERSION, false
  desc "OPcache improves PHP performance"
  homepage "https://php.net/manual/en/book.opcache.php"
  revision PHP_REVISION

  url PHP_SRC_URL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://pub-7d898cd296ae4a92a616d2e2c17cdb9e.r2.dev/php/8.2.26-106"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28511969783021fa8de99a7f253f6937dc2e01d84a85eb10e68467aa1a1a2734"
    sha256 cellar: :any_skip_relocation, ventura:       "5e7a26d0b794c4d8052d7dc8cfccf3fcd6769714493d7c6248d6a78ea3816371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10117ee176800f5027ffbc4431a42f2eb79d35053c3af7cea441622689f19f14"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "76c6fcf6434bc3fee34739f59fb96df178d05f18131e299b529c98302bc3980b"
  end

  depends_on "pcre2"

  def extension_type
    "zend_extension"
  end

  def install
    Dir.chdir "ext/opcache"

    ENV.append "LDFLAGS", "-L#{Formula["pcre2"].opt_prefix}/lib"
    ENV.append "CPPFLAGS", "-I#{Formula["pcre2"].opt_prefix}/include"

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig
    system "make"
    prefix.install "modules/opcache.so"
    write_config_file if build.with? "config-file"
  end
end
