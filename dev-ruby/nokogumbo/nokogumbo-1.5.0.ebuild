# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A Nokogiri interface to the Gumbo HTML5 parser"
HOMEPAGE="https://github.com/rubys/nokogumbo"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND+=">=dev-libs/gumbo-0.10"

ruby_add_rdepend ">=dev-ruby/nokogiri-1.6.5-r1"

all_ruby_prepare() {
	# Define rakehome in scope
	sed -i -e "1irakehome=File.expand_path('../../')" ext/nokogumboc/extconf.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/nokogumboc extconf.rb || die
	sed -i -e 's:-Wl,--no-undefined::' ext/nokogumboc/Makefile || die
}

each_ruby_compile() {
	emake -Cext/nokogumboc V=1
	cp ext/nokogumboc/nokogumboc.so lib/ || die
}

each_ruby_test() {
	${RUBY} -Ilib test-nokogumbo.rb || die
}
