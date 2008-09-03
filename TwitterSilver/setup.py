from distutils.core import setup
import py2app

setup(
    plugin = ['TwitterSilver.py'],
    options = dict(py2app=dict(extension='.qsplugin',
        plist=dict
        (
            NSPrincipalClass='TwitterSilver',
            QSPlugin=
            {
                'author': 'Biappi',
                'categories': ['Text', 'Web'],
                'description': 'Tweet straight from QuickSilver',
                'hidden': False
            },
            QSActions= dict(SendTweet={
                'actionClass': 'SendTweetAction',
                'actionSelector': 'performActionOnObject:',
                'directTypes': ['NSStringPboardType'],
                'name': 'Send Tweet to Twitter',
                'enabled': True,
                'validatesObjects': False
            }),
        )),
))

