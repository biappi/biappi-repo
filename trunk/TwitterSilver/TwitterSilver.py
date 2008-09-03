import objc
import os

from Foundation import NSLog
from Cocoa import NSRunAlertPanel

import twitter

QSActionProvider = objc.lookUpClass("QSActionProvider")
QSObject = objc.lookUpClass("QSObject")

class SendTweetAction(QSActionProvider):
	def performActionOnObject_(self, object):
		try:
			file = open(os.path.expanduser("~/Library/Preferences/org.nnva.biappi.TwitterSilver"), "r")
			the_user, the_pass = file.readline().strip().split()

			api = twitter.Api(username=the_user, password=the_pass)
			api.PostUpdate(object.stringValue())

		except IOError:
			NSRunAlertPanel("No configuration found", "Sorry, i know this is a bit weird, but for configuration you have to put a file named 'org.nnva.biappi.TwitterSilver' in your Library/Preferences folder that contains your credential separated by a space: e.g. 'username password'. If i'll get the time i'll find a way to do a proper config pane", "Ok", None, None)
		
		return QSObject.alloc().init()
