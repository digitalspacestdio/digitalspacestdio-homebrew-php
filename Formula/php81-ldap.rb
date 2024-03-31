require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php81Ldap < AbstractPhp81Extension
  init
  desc "LDAP Support"
  homepage "https://php.net/manual/en/book.ldap.php"
  revision PHP_REVISION


  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "545e0f20e90718925fa432e8f11d14d252a0df58556b60ede3d0a1219b92a941"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ccd78427a18edda302898f4912879f67b6a2a0328a680c44d6551f2a32322da"
    sha256 cellar: :any_skip_relocation, sonoma:        "243b53702131a14b550c3387f7bcf50312866aab4418283ee35747d5689fc737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "238c88b54002f465ef013232b57688170ac637cbb7193fea5fce6b79aa839644"
  end

  depends_on "openldap"

  def install
    Dir.chdir "ext/ldap"
    safe_phpize

    if OS.mac?
      headers_path = "=#{MacOS.sdk_path_if_needed}/usr"
      system "./configure", "--prefix=#{prefix}",
                            phpconfig,
                            "--disable-dependency-tracking",
                            "--with-ldap=#{Formula["openldap"].opt_prefix}",
                            "--with-ldap-sasl#{headers_path}"
    else
      system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-dependency-tracking",
                          "--with-ldap=#{Formula["openldap"].opt_prefix}"
    end
    system "make"
    prefix.install "modules/ldap.so"
    write_config_file if build.with? "config-file"
  end
end
