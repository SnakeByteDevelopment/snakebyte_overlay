# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils multilib python-any-r1 qmake-utils toolchain-funcs multilib-minimal

MY_PV=${PV/4.10/2.3}

DESCRIPTION="The WebKit module for the Qt toolkit"
HOMEPAGE="https://www.qt.io/ http://trac.webkit.org/wiki/QtWebKit"
SRC_URI="mirror://kde/stable/${PN}-2.3/${MY_PV}/src/${PN}-${MY_PV}.tar.gz"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="4"
KEYWORDS="~amd64"
IUSE="debug +gstreamer"

RDEPEND="
	>=dev-db/sqlite-3.8.3:3[${MULTILIB_USEDEP}]
	dev-libs/libxml2:2[${MULTILIB_USEDEP}]
	dev-libs/libxslt[${MULTILIB_USEDEP}]
	>=dev-qt/qtcore-4.8.6-r1:4[ssl,${MULTILIB_USEDEP}]
	>=dev-qt/qtdeclarative-4.8.6-r1:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtgui-4.8.6-r1:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtopengl-4.8.6-r1:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtscript-4.8.6-r1:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtsql-4.8.6-r1:4[sqlite,${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.10.2-r1[${MULTILIB_USEDEP}]
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	virtual/jpeg:0[${MULTILIB_USEDEP}]
	virtual/libudev:=[${MULTILIB_USEDEP}]
	>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXrender[${MULTILIB_USEDEP}]
	gstreamer? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
		media-libs/gst-plugins-base:1.0[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-lang/perl
	dev-lang/ruby
	dev-util/gperf
	sys-devel/bison
	sys-devel/flex
	virtual/perl-Digest-MD5
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

S=${WORKDIR}

PATCHES=(
	"${FILESDIR}/${PV}-gcc5.patch"
	"${FILESDIR}/${PV}-use-correct-icu-typedef.patch"
)

src_prepare() {
	# examples cause a sandbox violation (bug 458222)
	sed -i -e '/SUBDIRS += examples/d' Source/QtWebKit.pro || die

	# respect CXXFLAGS
	sed -i -e '/QMAKE_CXXFLAGS_RELEASE.*=/d' \
		Source/WTF/WTF.pro \
		Source/JavaScriptCore/Target.pri || die

	# apply patches
	[[ ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"
	epatch_user
}

