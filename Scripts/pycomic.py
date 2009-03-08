#!/usr/bin/env python
# -*- Python -*-

import pygtk
pygtk.require('2.0')
import gtk

import httplib
import formatter
import htmllib
import string
import os
import re
import ConfigParser

configuration_file = os.path.expanduser('~/.pycomic')
images_dir = os.path.expanduser('~/Comics/')

configuration = ConfigParser.ConfigParser()
configuration.readfp(open(configuration_file))
images_dir = os.path.expanduser('~/Comics/')

class comic:
	def __init__(self):
		self.area = gtk.VBox(gtk.FALSE, 0)
		self.area.show()

		self.window = gtk.ScrolledWindow()
		self.window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
		self.window.show()

		self.image = gtk.Image()
		self.image.show()

		self.window.add_with_viewport(self.image)

		self.hadj = self.window.get_hadjustment()
		self.vadj = self.window.get_vadjustment()

		box = gtk.HBox(gtk.TRUE, 0)
		box.show()

		first = gtk.Button("First", gtk.STOCK_GOTO_FIRST)
		first.show()

		prev = gtk.Button("Prev", gtk.STOCK_GO_BACK)
		prev.show()

		next = gtk.Button("Next", gtk.STOCK_GO_FORWARD)
		next.show()

		last = gtk.Button("Last", gtk.STOCK_GOTO_LAST)
		last.show()

		box.pack_start(first,   gtk.FALSE, gtk.TRUE, 0)
		box.pack_start(prev,    gtk.FALSE, gtk.TRUE, 0)
		box.pack_start(next,    gtk.FALSE, gtk.TRUE, 0)
		box.pack_start(last,    gtk.FALSE, gtk.TRUE, 0)

		anotha_box = gtk.HBox(gtk.FALSE, 0)
		anotha_box.show()

		refresh = gtk.Button("Refresh", gtk.STOCK_REFRESH)
		refresh.show()

		self.label = gtk.Label()
		self.label.show()

		anotha_box.pack_start (refresh,    gtk.FALSE, gtk.TRUE, 0)
		anotha_box.pack_start (self.label, gtk.TRUE,  gtk.TRUE, 0)

		self.area.pack_start (self.window, gtk.TRUE,  gtk.TRUE, 0)
		self.area.pack_start (box,         gtk.FALSE, gtk.TRUE, 0)
		self.area.pack_start (anotha_box,  gtk.FALSE, gtk.TRUE, 0)

		first.connect   ("clicked", self.first)
		prev.connect    ("clicked", self.prev)
		next.connect    ("clicked", self.next)
		last.connect    ("clicked", self.last)
		refresh.connect ("clicked", self.refresh)

	def change_image (self, filename):
		self.hadj.set_value(0)
		self.image.set_from_file(filename)
		self.window.set_size_request(self.image.get_pixbuf().get_width() + 25, 500)
		self.label.set_text(self.name+": strip "+str(self.current_issue)+" out of "+str(self.last_issue))

	def save(self, comicn, filename, server, path):
		if os.access (images_dir+comicn, os.F_OK) == 0:
			os.mkdir (images_dir+comicn)
		if os.access (images_dir+comicn+'/'+filename, os.F_OK) == 1:
			return

		c = httplib.HTTPConnection(server)
		c.request ("GET", path)
		response = c.getresponse()
		
		if response.status == 200:
			strip = file (images_dir+comicn+'/'+filename, "wb")
			strip.write (response.read())
			strip.close ()

	def first (self, widget, data=None):
		self.current_issue = 1
		self.show()
	
	def prev (self, widget, data=None):
		if self.current_issue > 1:
			self.current_issue = self.current_issue - 1

		self.show()
	
	def next (self, widget, data=None):
		self.current_issue = self.current_issue + 1
		self.show()

	def last (self, widget, data=None):
		self.current_issue = self.last_issue
		self.show()

	def refresh (self, widget, data=None):
		self.check_last()
		self.show()

class megatokyo_parser (htmllib.HTMLParser):
	def handle_image (self, source, alt, ismap, align, width, height):
		reg = re.compile("/strips/0*(.{4})\.gif").search(source)
		if reg:
			self.issue = reg.group(1)

class machall_parser (htmllib.HTMLParser):
	def handle_image (self, source, alt, ismap, align, width, height):
		reg = re.compile("strip_id=(.{3})").search(source)
		if reg:
			self.issue = reg.group(1)
			self.path = source

class applegeeks_parser (htmllib.HTMLParser):
	def handle_image (self, source, alt, ismap, align, width, height):
		reg = re.compile("/comics/issue(.{,3}).jpg").search(source)
		if reg:
			self.issue = reg.group(1)

class megatokyo (comic):
	name = "Megatokyo"
	most_recent_issue_seen = 1
	current_issue = 1
	last_issue = 1
	auto_fetch = 0
	fetch_all = 0

	def check_last (self):
		connection = httplib.HTTPConnection("www.megatokyo.com")
		connection.request ("GET",  "/")
		response = connection.getresponse()
		if response.status == 200:
			parser = megatokyo_parser(formatter.NullFormatter())
			parser.feed(response.read()) 
			self.last_issue = int(parser.issue)

	def show (self):
		if self.most_recent_issue_seen < self.current_issue:
			self.most_recent_issue_seen = self.current_issue

		current_issue = str(self.current_issue).zfill(4)+'.gif'
		self.save(self.name, current_issue, "www.megatokyo.com", '/strips/'+current_issue)
		self.change_image(images_dir+self.name+'/'+current_issue)

class applegeeks (comic):
	name = "AppleGeeks"
	most_recent_issue_seen = 1
	current_issue = 1
	last_issue = 1
	auto_fetch = 0
	fetch_all = 0

	def check_last (self):
		connection = httplib.HTTPConnection("www.applegeeks.com")
		connection.request ("GET",  "/")
		response = connection.getresponse()
		if response.status == 200:
			parser = applegeeks_parser(formatter.NullFormatter())
			parser.feed(response.read()) 
			self.last_issue = int(parser.issue)

	def show (self):
		if self.most_recent_issue_seen < self.current_issue:
			self.most_recent_issue_seen = self.current_issue

		current_issue = str(self.current_issue)+'.jpg'

		self.save(self.name, current_issue, "www.applegeeks.com", '/comics/issue'+current_issue)
		self.change_image(images_dir+self.name+'/'+current_issue)

class machall (comic):
	name = "MacHall"
	most_recent_issue_seen = 1
	current_issue = 1
	last_issue = 1
	auto_fetch = 0
	fetch_all = 0

	def get_index (self, strip_id=None):
		if strip_id == None:
			path = "/"
		else:
			path = "/index.php?strip_id="+str(strip_id).zfill(3)

		connection = httplib.HTTPConnection("www.machall.com")
		connection.request ("GET",  path)
		response = connection.getresponse()
		if response.status == 200:
			parser = machall_parser(formatter.NullFormatter())
			parser.feed(response.read()) 
			return parser.path

	def check_last (self):
		path = self.get_index()
		reg = re.compile("strip_id=(.{3})").search(path)
		self.last_issue = int(reg.group(1))
		self.last_path = path
		self.save(self.name, str(self.last_issue).zfill(3)+".jpg", "www.machall.com", self.last_path)

	def show (self):
		if self.most_recent_issue_seen < self.current_issue:
			self.most_recent_issue_seen = self.current_issue

		current_filename = str(self.current_issue).zfill(3)+".jpg"

		if os.access (images_dir+self.name+'/'+current_filename, os.F_OK) == 0:
			self.save(self.name, current_filename, "www.machall.com", self.get_index(self.current_issue))
		self.change_image(images_dir+self.name+'/'+current_filename)

	def next (self, widget, data=None):
		if self.current_issue < self.last_issue:
			self.current_issue = self.current_issue + 1
			self.show()

class pyComic:	
	def destroy_callback (self, widget, data = None):
		gtk.main_quit()	

	def __init__(self):
		window = gtk.Window(gtk.WINDOW_TOPLEVEL)

		box = gtk.VBox(gtk.FALSE, 0)
		box.show()

		self.comicarea = gtk.Notebook()
		self.comicarea.show()

		quit = gtk.Button ("Quit", gtk.STOCK_QUIT)
		quit.show()

		box.pack_start(self.comicarea, gtk.TRUE, gtk.TRUE, 0)
		box.pack_start(quit, gtk.FALSE, gtk.FALSE, 0)

		window.add(box)
		window.show()

		window.connect ("destroy", self.destroy_callback)
		quit.connect   ("clicked", self.destroy_callback)

	def get_configuration(self, a_comic):
		if configuration.has_section(a_comic.name):
			a_comic.current_issue = configuration.getint(a_comic.name, "current_issue")
			a_comic.last_issue    = configuration.getint(a_comic.name, "last_issue")
			a_comic.auto_fetch    = configuration.getint(a_comic.name, "auto_fetch")
			a_comic.fetch_all     = configuration.getint(a_comic.name, "fetch_all")

		a_comic.show()

	def set_configuration(self, a_comic):
		if not configuration.has_section(a_comic.name):
			configuration.add_section(a_comic.name)

		configuration.set(a_comic.name, "current_issue", a_comic.current_issue)
		configuration.set(a_comic.name, "last_issue",    a_comic.last_issue)
		configuration.set(a_comic.name, "auto_fetch",    a_comic.auto_fetch)
		configuration.set(a_comic.name, "fetch_all",     a_comic.fetch_all)

	def main (self):
		if os.access (images_dir, os.F_OK) == 0:
			os.mkdir (images_dir)

		mega = megatokyo()
		self.get_configuration(mega)
		self.comicarea.append_page(mega.area, gtk.Label(mega.name))

		ag = applegeeks()
		self.get_configuration(ag)
		self.comicarea.append_page(ag.area, gtk.Label(ag.name))

		mac = machall()
		self.get_configuration(mac)
		self.comicarea.append_page(mac.area, gtk.Label(mac.name))

		gtk.main()

		self.set_configuration(mega)
		self.set_configuration(ag)
		self.set_configuration(mac)
		configuration.write(open(configuration_file, "w"))

if __name__ == "__main__":
	app = pyComic()
	app.main()
