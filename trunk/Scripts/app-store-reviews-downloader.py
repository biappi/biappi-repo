import os
import urllib2
import popen2
import sys

from  xml.dom import minidom


HTTPUserAgent  = "iTunes/4.2 (Macintosh; U; PPC Mac OS X 10.2"
UserReviewsUrl = "http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%s&pageNumber=0&sortOrdering=2&type=Purple+Software"

iTunesStores = {
"143441": "United States",
"143505": "Argentina",
"143460": "Australia",
"143446": "Belgium",
"143503": "Brazil",
"143455": "Canada",
"143483": "Chile",
"143465": "China",
"143501": "Colombia",
"143495": "Costa Rica",
"143494": "Croatia",
"143489": "Czech Republic",
"143458": "Denmark",
"143443": "Deutschland",
"143506": "El Salvador",
"143454": "Espana",
"143447": "Finland",
"143442": "France",
"143448": "Greece",
"143504": "Guatemala",
"143463": "Hong Kong",
"143482": "Hungary",
"143467": "India",
"143476": "Indonesia",
"143449": "Ireland",
"143491": "Israel",
"143450": "Italia",
"143466": "Korea",
"143493": "Kuwait",
"143497": "Lebanon",
"143451": "Luxembourg",
"143473": "Malaysia",
"143468": "Mexico",
"143452": "Nederland",
"143461": "New Zealand",
"143457": "Norway",
"143445": "Osterreich",
"143477": "Pakistan",
"143485": "Panama",
"143507": "Peru",
"143474": "Phillipines",
"143478": "Poland",
"143453": "Portugal",
"143498": "Qatar",
"143487": "Romania",
"143469": "Russia",
"143479": "Saudi Arabia",
"143459": "Schweitz/Suisse",
"143464": "Singapore",
"143496": "Slovakia",
"143499": "Slovenia",
"143472": "South Africa",
"143486": "Sri Lanka",
"143456": "Sweden",
"143470": "Taiwan",
"143475": "Thailand",
"143480": "Turkey",
"143481": "United Arab Emirates",
"143444": "United Kingdom",
"143502": "Venezuela",
"143471": "Vietnam",
"143462": "Japan"}

def downloadCommentFileForApplicationId(applicationId, storeId):
	## Downloading The Store
	req = urllib2.Request(UserReviewsUrl % applicationId)
	req.add_header('X-Apple-Store-Front', '%s-1' % storeId)
	response = urllib2.urlopen(req)

	## Saving The Apple File
	if os.path.exists(applicationId) == False:
		os.makedirs(applicationId)

	filename = "%s/%s.apple.xml.gz" % (applicationId, storeId)
	fileout = file(filename, "w")
	fileout.write(response.read())
	fileout.close()
	response.close()

	## Clean It, For The Sake Of God
	child_out, child_in = popen2.popen2("gzcat %s | xsltproc apple-sanitizer.xslt -" % filename)
	filename = "%s/%s.sanitized.xml" % (applicationId, storeId)
	fileout = file(filename, "w")
	fileout.write(child_out.read())
	fileout.close()
	child_out.close()
	child_in.close()

def downloadAllStoresCommentFileForApplicationId(applicationId):
	print "Attempting to download comments file from %d stores" % len(iTunesStores)
	i = 1
	for storeId in iTunesStores:
		print "Downloading comments in the %s iTunes Store (%d of %d) ..." % (iTunesStores[storeId], i, len(iTunesStores))
		downloadCommentFileForApplicationId(applicationId, storeId)
		i += 1

def joinCommentsFiles(applicationId):
	print "Creating XML file"
	allComments = minidom.Document()

	storesElement = allComments.createElement("stores")
	allComments.appendChild(storesElement)

	for filename in os.listdir(applicationId):
		if 'sanitized' not in filename:
			continue

		temporary = minidom.parse('%s/%s' % (applicationId, filename))
		comments = temporary.getElementsByTagName('comments')[0]
		comments.setAttribute('store', iTunesStores[filename[:-(len('.sanitized.xml'))]])
		storesElement.appendChild(comments)

	file(applicationId + '.comments.xml', 'w').write(allComments.toprettyxml().encode("utf-8"))

def deleteTempDirectory(applicationId):
	for filename in os.listdir(applicationId):
		os.unlink('%s/%s' % (applicationId, filename))
	os.rmdir(applicationId)

def convertToHtml(applicationId):
	print "Converting to HTML"
	os.system('xsltproc to-html.xslt %s.comments.xml > %s.comments.html' % (applicationId, applicationId))

def ensureSanitizerXSLT():
	if os.path.exists('apple-sanitizer.xslt') == False:
		print 'Sanitizer stylesheet not present, creating it'
		file('apple-sanitizer.xslt', 'w').write("""<?xml version="1.0" encoding="UTF-8"?>
		<xsl:stylesheet xmlns:i="http://www.apple.com/itms/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
			<xsl:output method="xml" indent="yes"/>
			<xsl:template match="/">
				<comments>
					<xsl:for-each select="/i:Document/i:View[1]/i:ScrollView[1]/i:VBoxView[1]/i:View[1]/i:MatrixView[1]/i:VBoxView[1]/i:VBoxView[1]/i:VBoxView">
						<comment>
							<title>
								<xsl:value-of select="i:HBoxView/i:TextView/i:SetFontStyle/i:b"/>
							</title>
							<person>
								<xsl:value-of select="i:GotoURL/i:HBoxView/i:TextView/i:SetFontStyle/i:b"/>
							</person>
							<comment>
								<xsl:value-of select="i:TextView/i:SetFontStyle"/>
							</comment>
							<rating>
								<xsl:for-each select="i:HBoxView/i:HBoxView/i:HBoxView/i:PictureView">&#x2605;</xsl:for-each>
							</rating>
						</comment>
					</xsl:for-each>
				</comments>
			</xsl:template>
		</xsl:stylesheet>
		""")


def ensurePresentationXSLT():
	if os.path.exists('to-html.xslt') == False:
		print "XML to HTML stylesheet not present, creating it"
		file('to-html.xslt', 'w').write("""<?xml version="1.0" encoding="utf-8"?>
		<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
			<xsl:output method="html" version="1.0" encoding="utf-8" indent="no"/>
			<xsl:template match="/">
				<html>
					<head>
						<title>Comments in iTunes Application Store</title>
						<style> {font-family: Futura;text-transform: uppercase;}body {font-family: sans-serif;}.store
		{background: #eeeeee;min-height: 100px;margin-left: 200px;margin-right:20px;position:relative;
		margin-bottom: 20px;padding:20px;padding-top:5px;pading-bottom:5px;} .country {display:block;width:
		150px;position: absolute;left: -160px;font-family: Futura; text-align:right;} .countryLabel
		{display:block;font-size: smaller;color: #555555;}.countryName {display:block;text-transform:
		uppercase;} li{margin-bottom: 20px;} .title {font-family: Futura;text-transform:uppercase;
		display:block;} .person {font-family: Futura;font-size:smaller;display:block;margin-bottom:10px;}
		.comment {font-family:Serif;font-style: Italic;} .toEnglish a {color: #555;font-size: 0.8em;}
		</style>
						<script type="text/javascript" src="http://www.google.com/jsapi"/>
						<script><![CDATA[
		google.load("language", "1");google.load("jquery", "1");
		google.setOnLoadCallback(function() {$('.review').each(function() {var review = this;
		var a = $('<a href="#">Translate to English</a>').click(function() {$(this).empty();
		var title = $('.title', review).text();var comment = $('.comment', review).text();
		google.language.detect(title + " " + comment, function(result) {if (!result.error &&
		result.language) {google.language.translate(title, result.language, 'en', function(result) {
		if (result.translation)$('.title', review).html("<strong>Translated</strong>: " +
		result.translation);});google.language.translate(comment, result.language, 'en', function(result)
		{if (result.translation)$('.comment', review).html("<strong>Translated</strong>: " +
		result.translation);});}});return false;});$('.toEnglish', this).append(a);});});]]></script>
					</head>
					<body>
						<h1>Comments in iTunes Application Store</h1>
						<xsl:for-each select="/stores/*">
							<div class="store">
								<span class="country">
									<span class="countryLabel">country: </span>
									<span class="countryName">
										<xsl:value-of select="@store"/>
									</span>
								</span>
								<ol>
									<xsl:for-each select="comment">
										<li class="review">
											<span class="title">
												<xsl:value-of select="title"/>
											</span>
											<span class="rating">
												<xsl:value-of select="rating"/>
											</span>
											<span class="person">
												<xsl:value-of select="person"/>
											</span>
											<span class="comment">
												<xsl:value-of select="comment"/>
											</span>
											<span class="toEnglish"/>
										</li>
									</xsl:for-each>
								</ol>
							</div>
						</xsl:for-each>
					</body>
				</html>
			</xsl:template>
		</xsl:stylesheet>
		""")

if __name__ == '__main__':
	if len(sys.argv) == 1:
		print "Usage: %s <itunes store application id>" % sys.argv[0]
		print
		print "this script will leave a applicationid.comments.xml file"
	else:
		ensureSanitizerXSLT()
		ensurePresentationXSLT()
		downloadAllStoresCommentFileForApplicationId(sys.argv[1])
		joinCommentsFiles(sys.argv[1])
		deleteTempDirectory(sys.argv[1])
		convertToHtml(sys.argv[1])
		print "'Njoy"
