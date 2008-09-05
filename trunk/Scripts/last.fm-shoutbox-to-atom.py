from HTMLParser import HTMLParser

def class_contains(attrs, to_find):
	for attr, value in attrs:
		if attr == 'class' and value.find(to_find) != -1:
			return True

	return False

class microformatparser(HTMLParser):

	def __init__(self):
		HTMLParser.__init__(self)
		
		self.entries = []
		self.current_entry = {}
		
		self.got_list = False
		self.got_entry = False
				
		self.getting = None
		self.string = ""
		
	def handle_starttag(self, tag, attrs):
		if tag == 'ul' and class_contains(attrs, 'hfeed'):
			self.got_list = True

		elif tag == 'li' and class_contains(attrs, 'hentry') and self.got_list:
			self.got_entry = True
			for attr, value in attrs:
				if attr == 'id':
					self.current_entry.update({'id': value})

		if self.got_entry:
			if class_contains(attrs, 'entry-title'):
				self.getting = 'entry-title'
			
			elif class_contains(attrs, 'entry-content'):
				self.getting = 'entry-content'

			elif class_contains(attrs, 'updated'):
				for attr, value in attrs:
					if attr == 'title':
						self.current_entry.update({'updated': value})
			
			elif class_contains(attrs, 'fn userIcon'):
				self.getting = 'author'
			
	def handle_data(self, data):
		if self.getting:
			self.string += data #.strip()
	
	def handle_entityref(self, data):
		if self.getting:
			self.string += "&%s;" % data
	
	def handle_endtag(self, tag):
		if tag == 'ul' and self.got_list:
			self.got_list = False
			
		elif tag == 'li' and self.got_entry:
			self.got_entry = False
			self.entries.append(self.current_entry)
			self.current_entry = {}
		
		if self.getting is not None:
			self.current_entry.update({self.getting: self.string})
			self.string = ''
			self.getting = None


import urllib

mf = microformatparser()
mf.feed(urllib.urlopen('http://www.lastfm.it/group/Students+at+University+of+Pisa+addicted+by+drugs+or+fictions+or+social+network+sites+or+some+other+activities+that+don%27t+require+great+physics+movements').read())

print """<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">

 <title>Shoutbox gruppo</title>
 <id>http://www.lastfm.it/group/Students+at+University+of+Pisa+addicted+by+drugs+or+fictions+or+social+network+sites+or+some+other+activities+that+don%27t+require+great+physics+movements</id>
 <link>http://www.lastfm.it/group/Students+at+University+of+Pisa+addicted+by+drugs+or+fictions+or+social+network+sites+or+some+other+activities+that+don%27t+require+great+physics+movements</link>"""

print " <updated>%s</updated>" % mf.entries[0]['updated']

for entry in mf.entries:
	print " <entry>"
	print "   <title>%s</title>" % entry['entry-title']
	print "   <author><name>%s</name></author>" % entry['author']
	print "   <id>urn:id:%s</id>" % entry['id']
	print "   <updated>%s</updated>" % entry['updated']
	print "   <summary>%s</summary>" % entry['entry-content']
	print " </entry>"

print "</feed>"