all: compare
	
compare: good.stamp head.stamp
	diff -u -r Output/good Output/head

good.stamp: Good-Source good.pl
	perl good.pl

Good-Source:
	svn export svn://svn.berlios.de/web-cpan/nav-menu/branches/old-fangled Good-Source

head.stamp: head.pl
	perl head.pl

good-update-source: good-delete-source Good-Source

good-delete-source:
	rm -fr Good-Source

