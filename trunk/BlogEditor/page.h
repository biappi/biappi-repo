/*
 *  page.h
 *  Untitled
 *
 *  Created by Antonio "Willy" Malara on 17/08/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

NSString * page = @"<?xml version=\"1.0\"?>\
<methodResponse>\
<params>\
<param>\
<value>\
<array>\
<data>\
<value>\
<struct>\
<member>\
<name>permaLink</name>\
<value>\
<string>http://biappi.nnva.org/blog/my-google-interview-experience</string>\
</value>\
</member>\
<member>\
<name>description</name>\
<value>\
<string>&lt;p&gt;It's crazy!&lt;/p&gt;\
&lt;p&gt;A while ago, circa january 2008, i was coming back home drank as hell. Before going to bed, i've peeked at the email client and there was an email labeled \"Google Engineering\".&lt;/p&gt;\
&lt;p&gt;Clearly i've drank that much to have hallucinations.&lt;/p&gt;\
&lt;p&gt;So, after a good sleep, i came back at my terminal, and the mail was still here!!&lt;/p&gt;\
&lt;p&gt;A Google recruiter actually contacted me to send a C.V.!! I couldn't miss that occasion and for a weekend i was the happier person in the earth.&lt;/p&gt;\
&lt;p&gt;It turned out that they wanted only graduated persons, and while i've spent 6 years in two universities, i still don't have my fscking degree. They asked me an estimate on my graduation (which i missed, of course..) and to my GREAT surprise, they recalled me!!!&lt;/p&gt;\
&lt;p&gt;So yesterday, after some days of chasing, i got the screening call from the recruiter.&lt;/p&gt;\
&lt;p&gt;I was nervous as hell, and after the WWDC experience, i do not trust my spoken english anymore, so just to loose my nerves i've drank a beer =), i don't know if it helped, tought.&lt;/p&gt;\
&lt;p&gt;I had to choose from three main topics, i don't remember the first, maybe system administration, TCP/IP stuff, and general computer science questions.&lt;/p&gt;\
&lt;p&gt;I choose the last one, feeling like a guest in a TV quiz game.&lt;/p&gt;\
&lt;p&gt;The questions started, to my surprise they was all really easy, maybe because it was the non-technical interview, by the was that's more or less how the conversation felt like.&lt;/p&gt;\
&lt;p&gt;&lt;strong&gt;What's the quicksort complexity?&lt;/strong&gt; Quicksort? Easy one: that's a comparison sort, so it have its O(nlogn) and Theta(n squared). She liked the fast response i gave, or at least that's what i'd like to think. =) (i was so nervous my hands was shaking)&lt;/p&gt;\
&lt;p&gt;&lt;strong&gt;Order from quicker to slower the following: context switch, memory write, disk seek, register read.&lt;/strong&gt; (Thinking...) What's that? I'm really in \"Who wants to be a millionarie? (Speaking) Ok, of course register read, then memory write, now i'm in doubt between context switch and disk seek, it should depend on machine architecture, but i'd say first context switch then disk seek. I hope that last note was appreciated! (despite i did know the answer, my voice was flickering)&lt;/p&gt;\
&lt;p&gt;&lt;strong&gt;Algorithms: you've a 10000 int array, you've to write a fast algorithm to count all the bits set to 1, and you've got unlimited RAM&lt;/strong&gt; Oh... let'see the first algo i can think of is a linear search counting the bits of one integer using 32 bitmasks, which is constant time... i'd say you can go faster, but i can't think of a way right now. (shaking, flickering voice, soaked  in sweat).&lt;/p&gt;\
&lt;p&gt;&lt;strong&gt;How you'd use the hint that you've got how many ram you'd like?&lt;/strong&gt; Uh, i think i'd broke the integer some way, putting the pieces in some known buckets and count them... (ockay i reckon that was really non sense but she stopped me anyway...)&lt;/p&gt;\
&lt;p&gt;&lt;strong&gt;Now this is an hard question choose your best language... &lt;/strong&gt; Argh... &lt;strong&gt;C, C++, Python?&lt;/strong&gt; Err.. C! &lt;strong&gt;What is a void *?&lt;/strong&gt; HEAJ? And that's an hard question, it's a pointer to an unkown type!!&lt;/p&gt;\
&lt;p&gt;&lt;strong&gt;Ah, by the way, our answer to that algorithm was: you divide the int by two bytes, and you made a lookup table to count byte per byte, so your answer was indeed on the right track!!&lt;/strong&gt;&lt;/p&gt;\
&lt;p&gt;Wow, right now i'm pretty happy with this talk... I've answered correctly in basically no time. Now i know that those was really basic questions, still they managed to tickle my reality distortion field! =). (mine is not triggered only by Steve).&lt;/p&gt;\
&lt;p&gt;Now i'm waiting a written questionnaire, then i'll have to do two highly technical 45 minutes phone talks, and if i'll prove to be good enough for the Big G, i'll get an interview in person!! WOO&lt;/p&gt;\
&lt;p&gt;I don't know what will happen... But so far, i'm really happy!!! Even if they'll dump me, after all i still have no BS, being contacted by Google, and getting to have even the screening interview for me is like being in heaven =).&lt;/p&gt;\
&lt;p&gt;Thanks Alice!&lt;/p&gt;</string>\
</value>\
</member>\
<member>\
<name>title</name>\
<value>\
<string>My Google Interview Experience</string>\
</value>\
</member>\
<member>\
<name>userId</name>\
<value>\
<string>biappi</string>\
</value>\
</member>\
<member>\
<name>dateCreated</name>\
<value>\
<dateTime.iso8601>20080725T09:27:37</dateTime.iso8601>\
</value>\
</member>\
<member>\
<name>link</name>\
<value>\
<string>http://biappi.nnva.org/blog/my-google-interview-experience</string>\
</value>\
</member>\
<member>\
<name>postId</name>\
<value>\
<int>30</int>\
</value>\
</member>\
<member>\
<name>categories</name>\
<value>\
<array>\
<data>\
<value>\
<string>Personal</string>\
</value>\
<value>\
<string>The Future</string>\
</value>\
<value>\
<string>Google</string>\
</value>\
</data>\
</array>\
</value>\
</member>\
</struct>\
</value>\
<value>\
<struct>\
<member>\
<name>permaLink</name>\
<value>\
<string>http://biappi.nnva.org/blog/damn-im-looking-good</string>\
</value>\
</member>\
<member>\
<name>description</name>\
<value>\
<string>&lt;p&gt;&lt;strong&gt;Update:&lt;/strong&gt; here is the &lt;a href=\"http://biappi.nnva.org/media/sole.articolo.jpg\"&gt;whole article&lt;/a&gt; appeared today on Nova 24, which is a spinoff of &lt;a href=\"http://www.ilsole24ore.com/\"&gt;Il Sole 24 Ore&lt;/a&gt;.&lt;/p&gt;\
\
&lt;p&gt;Impressive... my mugshot appeared on the national buisness newspaper!!!&lt;/p&gt;\
&lt;p&gt;&lt;img src=\"http://biappi.nnva.org/media/sole.jpg\" alt=\"Sole 24 Hours\"/&gt;&lt;/p&gt;</string>\
</value>\
</member>\
<member>\
<name>title</name>\
<value>\
<string>Damn, i'm looking good</string>\
</value>\
</member>\
<member>\
<name>userId</name>\
<value>\
<string>biappi</string>\
</value>\
</member>\
<member>\
<name>dateCreated</name>\
<value>\
<dateTime.iso8601>20080717T09:11:05</dateTime.iso8601>\
</value>\
</member>\
<member>\
<name>link</name>\
<value>\
<string>http://biappi.nnva.org/blog/damn-im-looking-good</string>\
</value>\
</member>\
<member>\
<name>postId</name>\
<value>\
<int>29</int>\
</value>\
</member>\
<member>\
<name>categories</name>\
<value>\
<array>\
<data>\
<value>\
<string>Personal</string>\
</value>\
<value>\
<string>iPhone</string>\
</value>\
</data>\
</array>\
</value>\
</member>\
</struct>\
</value>\
<value>\
<struct>\
<member>\
<name>permaLink</name>\
<value>\
<string>http://biappi.nnva.org/blog/feed-couch-revisited</string>\
</value>\
</member>\
<member>\
<name>description</name>\
<value>\
<string>&lt;p&gt;Remember my &lt;a href=\"http://biappi.nnva.org/blog/feed-couch-my-front-row-esque-feed-reader/\"&gt;feed reader&lt;/a&gt;?&lt;/p&gt;\
&lt;p&gt;Well, i had to add more eye-candiness to get my grade, and it seems Cisternis' liked it, i got 30/30 cum laude =)&lt;/p&gt;\
&lt;p&gt;This is a screencast:&lt;/p&gt;\
&lt;p&gt;&lt;object width=\"425\" height=\"344\"&gt;&lt;param name=\"movie\" value=\"http://www.youtube.com/v/puq76L4ZLRw&amp;hl=en&amp;fs=1\"&gt;&lt;/param&gt;&lt;param name=\"allowFullScreen\" value=\"true\"&gt;&lt;/param&gt;&lt;embed src=\"http://www.youtube.com/v/puq76L4ZLRw&amp;hl=en&amp;fs=1\" type=\"application/x-shockwave-flash\" allowfullscreen=\"true\" width=\"425\" height=\"344\"&gt;&lt;/embed&gt;&lt;/object&gt;&lt;/p&gt;\
&lt;p&gt;The concept is quite simple, you get the last 5 entries of the Safari's subscribed feeds, and you navigate them with the Apple Remote.&lt;/p&gt;\
&lt;p&gt;The code has a little... ehm.. \"shortcut\" i don't like at all, but i had to do it really fast, and i didnt want to refactor the code 30 minutes before the exam, but...&lt;/p&gt;\
&lt;p&gt;You can &lt;a href=\"http://biappi.nnva.org/media/code/Feed%20Couch.zip\"&gt;downoad Feed Couch Source Code&lt;/a&gt;&lt;/p&gt;\
&lt;p&gt;It includes the MIT-Licensed &lt;a href=\"http://martinkahr.com/2007/07/26/remote-control-wrapper-20/index.html\"&gt;Remote Control Wrapper&lt;/a&gt; by &lt;a href=\"http://www.martinkahr.com\"&gt;Martin Kahr&lt;/a&gt;. Thanks, Martin!&lt;/p&gt;</string>\
</value>\
</member>\
<member>\
<name>title</name>\
<value>\
<string>Feed Couch, Revisited</string>\
</value>\
</member>\
<member>\
<name>userId</name>\
<value>\
<string>biappi</string>\
</value>\
</member>\
<member>\
<name>dateCreated</name>\
<value>\
<dateTime.iso8601>20080704T20:19:41</dateTime.iso8601>\
</value>\
</member>\
<member>\
<name>link</name>\
<value>\
<string>http://biappi.nnva.org/blog/feed-couch-revisited</string>\
</value>\
</member>\
<member>\
<name>postId</name>\
<value>\
<int>28</int>\
</value>\
</member>\
<member>\
<name>categories</name>\
<value>\
<array>\
<data>\
<value>\
<string>Coding</string>\
</value>\
<value>\
<string>Safari</string>\
</value>\
<value>\
<string>Core Animation</string>\
</value>\
</data>\
</array>\
</value>\
</member>\
</struct>\
</value>\
<value>\
<struct>\
<member>\
<name>permaLink</name>\
<value>\
<string>http://biappi.nnva.org/blog/first-post-from-mars-edit</string>\
</value>\
</member>\
<member>\
<name>description</name>\
<value>\
<string>&lt;p&gt;I wanted to try this for a long time, but i never had the willings to implement the protocol bits. Don't know how, but i'm in a hack-my-blog mood, so here we are...&lt;/p&gt;\
&lt;p&gt;I've implemented a partially working &lt;a href=\"http://www.xmlrpc.com/metaWeblogApi\"&gt;Meta Weblog API&lt;/a&gt; that allows me to use a blogging client like Mars Edit to write my blog posts!&lt;/p&gt;\
&lt;p&gt;Working with Python is really a pleasure... &lt;/p&gt;\
&lt;p&gt;Right now my implementation lacks a proper authentication, i just check my credentials as \"magic numbers\", edit and tag support.&lt;/p&gt;\
&lt;p&gt;I don't think i'll ever address the auth thing, but if i'm in the mood of completing this thing, at least to allow basic post editing, i'll release the script...&lt;/p&gt;\
&lt;p&gt;Well, don't know if it will be useful to anyone, since it's tied to my model classes, but maybe it will be a good starting point, or an example, i don't know. &lt;/p&gt;\
&lt;p&gt;Of course, if you want it right now, just shout in the comments =).&lt;/p&gt;</string>\
</value>\
</member>\
<member>\
<name>title</name>\
<value>\
<string>First post from Mars Edit!</string>\
</value>\
</member>\
<member>\
<name>userId</name>\
<value>\
<string>biappi</string>\
</value>\
</member>\
<member>\
<name>dateCreated</name>\
<value>\
<dateTime.iso8601>20080625T02:57:18</dateTime.iso8601>\
</value>\
</member>\
<member>\
<name>link</name>\
<value>\
<string>http://biappi.nnva.org/blog/first-post-from-mars-edit</string>\
</value>\
</member>\
<member>\
<name>postId</name>\
<value>\
<int>27</int>\
</value>\
</member>\
<member>\
<name>categories</name>\
<value>\
<array>\
<data>\
<value>\
<string>The Future</string>\
</value>\
<value>\
<string>Coding</string>\
</value>\
<value>\
<string>Django</string>\
</value>\
</data>\
</array>\
</value>\
</member>\
</struct>\
</value>\
<value>\
<struct>\
<member>\
<name>permaLink</name>\
<value>\
<string>http://biappi.nnva.org/blog/website-redesign</string>\
</value>\
</member>\
<member>\
<name>description</name>\
<value>\
<string>&lt;p&gt;When someone has to study, you know, he will find a great number of excuses to slaking off in peace with his consciousness.&lt;/p&gt;\
&lt;p&gt;That's why this site sports a whole new design.  It's more flexible, so code should be more readable, and i think it'll scale well with non-blog kind of content.&lt;/p&gt;\
&lt;p&gt;Next steps: collect all the mini-scripts and things i've hidden in the Net and collect 'em here.&lt;/p&gt;\
&lt;p&gt;Yeah, something to do in the hot days here in Calabria!&lt;/p&gt;</string>\
</value>\
</member>\
<member>\
<name>title</name>\
<value>\
<string>Website Redesign!</string>\
</value>\
</member>\
<member>\
<name>userId</name>\
<value>\
<string>biappi</string>\
</value>\
</member>\
<member>\
<name>dateCreated</name>\
<value>\
<dateTime.iso8601>20080622T17:13:21</dateTime.iso8601>\
</value>\
</member>\
<member>\
<name>link</name>\
<value>\
<string>http://biappi.nnva.org/blog/website-redesign</string>\
</value>\
</member>\
<member>\
<name>postId</name>\
<value>\
<int>26</int>\
</value>\
</member>\
<member>\
<name>categories</name>\
<value>\
<array>\
<data>\
<value>\
<string>Personal</string>\
</value>\
<value>\
<string>bla-bla</string>\
</value>\
</data>\
</array>\
</value>\
</member>\
</struct>\
</value>\
<value>\
<struct>\
<member>\
<name>permaLink</name>\
<value>\
<string>http://biappi.nnva.org/blog/memory-management-and-garbage-collection</string>\
</value>\
</member>\
<member>\
<name>description</name>\
<value>\
<string>&lt;p&gt;\
At WWDC i've had the chance to meet many different kinds of developers: the \"shareware student\", the indie \"bigs\", the employee of big companies, even some IT guys.\
&lt;/p&gt;&lt;p&gt;\
For me, with the little experience i have, it was a big chance to relate with others, and get inspired. I've realized that living in a rich environment stimulates you, it makes you more productive by putting you in \"the right mood\" to actually start and getting some things done!\
&lt;/p&gt;&lt;p&gt;\
Talking to some people, conversation naturally shifts to the tools we use, as computer programmers, developers and scientists. And as anyone knows, those topics are a rough equivalent of religion. Church of VIM, church of Emacs, the Ruby vs Emacs... you name it!\
&lt;/p&gt;&lt;p&gt;\
After the light fights of text editors, the turn of programming languages arrived, and i got really \"ignited\" when i've heard something in the line of \"i hate objective-c because it lacks garbage collection, objective-c 2.0 is muuuuuuuuuuuuuuuuuch better.. why i have to manage my memory!\".\
&lt;/p&gt;&lt;p&gt;\
Now, let me state that i &lt;em&gt;love&lt;/em&gt; GC and i use it actively, &lt;strong&gt;BUT&lt;/strong&gt; as i say, \"as a programmer you've got to know every other byte in the address space your application run\".\
&lt;/p&gt;&lt;p&gt;\
Now i really was the guy from the outer space, actually liking all that &lt;code&gt;retain&lt;/code&gt; and &lt;code&gt;release&lt;/code&gt; methods, &lt;code&gt;malloc()&lt;/code&gt; and &lt;code&gt;free()&lt;/code&gt; functions... i really had to be some strange, uncommon alien.\
&lt;/p&gt;&lt;p&gt;\
But now, let me exapand a little on this, which i meant to be this post's topic.\
&lt;/p&gt;&lt;p&gt;\
&lt;em&gt;Of course&lt;/em&gt; you'll use GC, automatic memory managment and a whole set of tools to make your job easier and less error-prone, but you do not have to forget what you're actually doing, you've to carefully know what choices you've made, yourself or by using a determined set of tools.\
&lt;/p&gt;&lt;p&gt;\
A computer really is nothing more than a thing that computes things on memory, just that. Every other piece of software or hardware is just something that can be seen as piece of memory or piece of \"something that computes\".\
&lt;/p&gt;&lt;p&gt;\
The monitor you see this website is basically a matrix of pixel in memory, the mouse and keyboard are really a small number between other 2^32, disks, something more, but substance doesn't change that much.\
&lt;/p&gt;&lt;p&gt;\
It's not by chance that the kernel of an operating system simply is nothing but a manager for the computational resources - the scheduling part - and the memory resources - the virtual memory, paging on disk, et cetera.\
&lt;/p&gt;&lt;p&gt;\
Managing computational resources &lt;em&gt;used to be&lt;/em&gt; simple, you take the processor do some work, then kindly release it so other can use it.\
&lt;/p&gt;&lt;p&gt;\
We know this is changing with time: we're heading at multicore machines, and bla bla bla.. all things you already know if you're not living inside a bunker.\
&lt;/p&gt;&lt;p&gt;\
Scaling &lt;em&gt;used to be&lt;/em&gt; very easy too... just wait til intel or amd build a faster cpu and your program run faster.\
&lt;/p&gt;&lt;p&gt;\
Memory is really another beast.\
&lt;/p&gt;&lt;p&gt;\
First thing first, memory &lt;strong&gt;costs&lt;/strong&gt;. Because of that cost we've designed a memory hierarchy, exploiting the fact that memory the slower is, the cheaper is, and usually at minus cost per bytes.\
&lt;/p&gt;&lt;p&gt;\
Because of that hierarchy we have introduced a bit of time delays in transferring chunks of memory between layers, if you do opengl stuff just look at texture management.\
&lt;/p&gt;&lt;p&gt;\
Sometimes when programming it's useful to have in mind that memory caching *does* affect performance. One notable example, the radix sort: despite being linear, it's execution time is often greater than comparison sorts, with their O(nlogn) scores. [&lt;a href=\"http://www.lamarca.org/anthony/pubs/cachesort.pdf\"&gt;The Influence of Caches on the Performance of Sorting&lt;/a&gt; - LaMarca and Ladner]\
&lt;/p&gt;&lt;p&gt;\
Translation: because of caching, a program theoretically blazing fast, is actually slower than a program theoretically fast, but not blazing.\
&lt;/p&gt;&lt;p&gt;\
Then, as a consequence of memory being costly, memory is small. And already packed up with code and resources. And our dataset. But that's an abstraction, in reality we have that our memory is shared between all the other programs, and we have to play nicely on that!\
&lt;/p&gt;&lt;p&gt;\
In particular, allocation and deallocation of memory are operations that take some time to do, so it's better to do it well.\
&lt;/p&gt;&lt;p&gt;\
Even if you're using garbage collection, you need to know what it does, and how. Like any other tool you have to know its strenght and weakness in order to master it.\
&lt;/p&gt;</string>\
</value>\
</member>\
<member>\
<name>title</name>\
<value>\
<string>On Memory Management And Garbage Collection</string>\
</value>\
</member>\
<member>\
<name>userId</name>\
<value>\
<string>biappi</string>\
</value>\
</member>\
<member>\
<name>dateCreated</name>\
<value>\
<dateTime.iso8601>20080619T10:28:08</dateTime.iso8601>\
</value>\
</member>\
<member>\
<name>link</name>\
<value>\
<string>http://biappi.nnva.org/blog/memory-management-and-garbage-collection</string>\
</value>\
</member>\
<member>\
<name>postId</name>\
<value>\
<int>25</int>\
</value>\
</member>\
<member>\
<name>categories</name>\
<value>\
<array>\
<data>\
<value>\
<string>bla-bla</string>\
</value>\
<value>\
<string>Coding</string>\
</value>\
</data>\
</array>\
</value>\
</member>\
</struct>\
</value>\
<value>\
<struct>\
<member>\
<name>permaLink</name>\
<value>\
<string>http://biappi.nnva.org/blog/uncompress-mac-os-x-packages-without-pacifist</string>\
</value>\
</member>\
<member>\
<name>description</name>\
<value>\
<string>&lt;p&gt;This has been really an awesome week, i've met really nice persons and all the WWDC's\
sessions were really awesome, even if some were really basic... you know for all the\
newbies that are jumping in the whole iPhone thing.&lt;/p&gt;\
\
&lt;p&gt;Right now i'm in the plane from SFO to JFK playing around with my copy of the awesome\
Snow Leopard Developer Preview, but do not worry or get too excited, you know all the NDA\
things.&lt;/p&gt;\
\
&lt;p&gt;Instead, i want to talk you about Installer Packages.&lt;/p&gt;\
\
&lt;p&gt;I've not yet installed 10.6 but i'm on a really, really long flight and, guess what,\
really bored, but i don't want to install a whole OS running on batteries, but however i\
slapped the cd in the Xantia's drive, and i just realized what i had to do: i cannot install\
the os, at least let's see the documentation of the magnificent new features, [REDACTED] someone\
might say =).&lt;/p&gt;\
\
&lt;p&gt;Then, of course, the problem: my copy of Pacifist kept crashing and i couldn't extract the\
documents i want to read, after a couple of tries i fired up my terminal to investigate\
another solution.&lt;/p&gt;\
\
&lt;p&gt;First thing first, let's guess the file format of the package. I tought it was a bundle \
of some sort, but it turned out it was a plain data file.&lt;/p&gt;\
\
&lt;p&gt;&lt;code&gt;&lt;pre&gt;\
Xanthia:devs willy$ file DevDocumentation.pkg \
DevDocumentation.pkg: data\
Xanthia:devs willy$ \
&lt;/pre&gt;&lt;/code&gt;&lt;/p&gt;\
\
&lt;p&gt;Wow, not even a clue! let's dive deeper.&lt;/p&gt;\
\
&lt;p&gt;&lt;code&gt;&lt;pre&gt;\
Xanthia:devs willy$ hexdump -C DevDocumentation.pkg  | head\
00000000  78 61 72 21 00 1c 00 01  00 00 00 00 00 00 02 9f  |xar!............|\
00000010  00 00 00 00 00 00 0a 6b  00 00 00 01 78 da ec 96  |.......k....x??.|\
00000020  4b 6f 9b 40 10 c7 ef f9  14 88 bb cb be 1f 16 26  |Ko.@.???..?&#x2FE;..&amp;|\
00000030  6a 0f 55 7b ab 94 f4 d2  db 3e 66 6d 14 30 16 e0  |j.U{?.???&amp;gt;fm.0.?|\
00000040  d4 c9 a7 ef 82 ed 3c 1d  27 4a 9a 2a 87 9e 98 99  |?&#x267;?.?&amp;lt;.'J.*....|\
00000050  fd 33 fb 5f f8 69 20 3f  dd d4 55 72 09 6d 57 36  |?3?_?i ???Ur.mW6|\
00000060  cb 59 8a 3f a1 34 81 a5  6b 7c b9 9c cf d2 9f e7  |?Y.??4.?k|?.??.?|\
00000070  5f 27 2a 3d 2d 4e f2 8d  69 8b 93 24 ef 1b 17 2f  |_'*=-N?.i..$?../|\
00000080  49 ee 16 e0 2e ba 75 9d  74 fd 55 05 b3 b4 5b 18  |I?.?.?u.t?U.??[.|\
00000090  9c 0e 2b 49 de 84 d0 41  5f a0 3c db 45 63 b5 2b  |..+I?.?A_?&amp;gt;?Ec?+|\
Xanthia:devs willy$ \
&lt;/pre&gt;&lt;/code&gt;&lt;/p&gt;\
\
&lt;p&gt;Now, not that i really read that kind of hex, but the first 3 chars are \"xar\", which\
i remember it should be a new archive format, maybe we have a command to mangle with it?!&lt;/p&gt;\
\
&lt;p&gt;&lt;code&gt;&lt;pre&gt;\
Xanthia:devs willy$ xar | head\
Usage: xar -[ctx][v] -f &lt;archive&gt; ...\
-c               Creates an archive\
-x               Extracts an archive\
-t               Lists an archive\
[...]\
&lt;/pre&gt;&lt;/code&gt;&lt;/p&gt;\
\
&lt;p&gt;Yay! Sounds like \"Bingo\" to me!&lt;/p&gt;\
\
&lt;p&gt;&lt;code&gt;&lt;pre&gt;\
Xanthia:devs willy$ xar -t -f DevDocumentation.pkg \
Bom\
PackageInfo\
Payload\
Scripts\
Xanthia:devs willy$ \
&lt;/pre&gt;&lt;/code&gt;&lt;/p&gt;\
\
&lt;p&gt;Here is the file archive content. How did i know how to use that xar thingie if a minute ago\
i didn't even know of its existance on my system?! RTFM!&lt;/p&gt;\
&lt;p&gt;On to extraction.&lt;/p&gt;\
\
&lt;p&gt;&lt;code&gt;&lt;pre&gt;\
Xanthia:devs willy$ xar -xf DevDocumentation.pkg \
Xanthia:devs willy$ \
&lt;/pre&gt;&lt;/code&gt;&lt;/p&gt;\
\
&lt;p&gt;Now that \"Payload\" is like flashing light wanting attention.&lt;/p&gt;\
\
&lt;p&gt;&lt;code&gt;&lt;pre&gt;\
Xanthia:devs willy$ file Payload \
Payload: gzip compressed data, from Unix \
Xanthia:devs willy$ \
&lt;/pre&gt;&lt;/code&gt;&lt;/p&gt;\
\
&lt;p&gt;Ahh... good old toys...&lt;/p&gt;\
\
&lt;p&gt;&lt;code&gt;&lt;pre&gt;\
Xanthia:devs willy$ mv Payload Payload.gz\
Xanthia:devs willy$ gunzip Payload.gz\
Xanthia:devs willy$ file Payload\
Payload: ASCII cpio archive (pre-SVR4 or odc)\
Xanthia:devs willy$\
&lt;/pre&gt;&lt;/code&gt;&lt;/p&gt;\
\
&lt;p&gt;Ahh... even more good old toys...&lt;/p&gt;\
\
&lt;p&gt;&lt;code&gt;&lt;pre&gt;\
Xanthia:devs willy$ cat Payload | cpio -i\
Xanthia:devs willy$ \
&lt;/pre&gt;&lt;/code&gt;&lt;/p&gt;\
\
&lt;p&gt;Wow, here we go!&lt;/p&gt;\
&lt;p&gt;We've extracted all the files from the package without installing it, and using only tools\
already available in every installation of OS X!!&lt;/p&gt;\
\
&lt;p&gt;Quick recap: Package files are a XAR file that bundles control files and a Payload,\
which is a .cpio.gzip file&lt;/p&gt;</string>\
</value>\
</member>\
<member>\
<name>title</name>\
<value>\
<string>Uncompress Mac Os X Packages Without Pacifist</string>\
</value>\
</member>\
<member>\
<name>userId</name>\
<value>\
<string>biappi</string>\
</value>\
</member>\
<member>\
<name>dateCreated</name>\
<value>\
<dateTime.iso8601>20080615T17:09:26</dateTime.iso8601>\
</value>\
</member>\
<member>\
<name>link</name>\
<value>\
<string>http://biappi.nnva.org/blog/uncompress-mac-os-x-packages-without-pacifist</string>\
</value>\
</member>\
<member>\
<name>postId</name>\
<value>\
<int>24</int>\
</value>\
</member>\
<member>\
<name>categories</name>\
<value>\
<array>\
<data>\
<value>\
<string>Apple</string>\
</value>\
<value>\
<string>Leopard</string>\
</value>\
<value>\
<string>Sysadmin</string>\
</value>\
<value>\
<string>Snow Leopard</string>\
</value>\
</data>\
</array>\
</value>\
</member>\
</struct>\
</value>\
<value>\
<struct>\
<member>\
<name>permaLink</name>\
<value>\
<string>http://biappi.nnva.org/blog/and-finally</string>\
</value>\
</member>\
<member>\
<name>description</name>\
<value>\
<string>&lt;p&gt;&lt;a href=\"http://picasaweb.google.com/biappi/WWDC08/photo#5209624846402656722\"&gt;&lt;img src=\"http://lh4.ggpht.com/biappi/SExOMi7hGdI/AAAAAAAABEg/hDDKzQteMIM/s288/IMG_0179.JPG\" /&gt;&lt;/a&gt;&lt;/p&gt;</string>\
</value>\
</member>\
<member>\
<name>title</name>\
<value>\
<string>And finally...</string>\
</value>\
</member>\
<member>\
<name>userId</name>\
<value>\
<string>biappi</string>\
</value>\
</member>\
<member>\
<name>dateCreated</name>\
<value>\
<dateTime.iso8601>20080609T13:32:54</dateTime.iso8601>\
</value>\
</member>\
<member>\
<name>link</name>\
<value>\
<string>http://biappi.nnva.org/blog/and-finally</string>\
</value>\
</member>\
<member>\
<name>postId</name>\
<value>\
<int>23</int>\
</value>\
</member>\
<member>\
<name>categories</name>\
<value>\
<array>\
<data>\
<value>\
<string>Personal</string>\
</value>\
<value>\
<string>Apple</string>\
</value>\
</data>\
</array>\
</value>\
</member>\
</struct>\
</value>\
<value>\
<struct>\
<member>\
<name>permaLink</name>\
<value>\
<string>http://biappi.nnva.org/blog/virgin-mary-and-speed-light</string>\
</value>\
</member>\
<member>\
<name>description</name>\
<value>\
<string>&lt;p&gt;Just a cool excerpt of a chat log with me and a friend of mine... =)&lt;/p&gt;\
&lt;p&gt;&lt;em&gt;N.P.:&lt;/em&gt;&lt;br/&gt;\
in 1950 they estabilished that the Virgin Mary ascended in body and soul to heaven.\
soul aside, assuming restricted relativity, where the maximum speed of a body is the speed\
of light, the Virgin Mary should be now within a ~1950 light years radius...&lt;/p&gt;\
&lt;p&gt;&lt;em&gt;Biappi:&lt;/em&gt;&lt;br/&gt;\
she didn't get burned during the atmosphere exit?&lt;/p&gt;\
&lt;p&gt;&lt;em&gt;N.P.:&lt;/em&gt;&lt;br/&gt;\
i don't know... she was a virgin before, during and after the birth of Christ, she can even\
exit atmosphere at the speed of light&lt;/p&gt;</string>\
</value>\
</member>\
<member>\
<name>title</name>\
<value>\
<string>The Virgin Mary And The Speed Of Light</string>\
</value>\
</member>\
<member>\
<name>userId</name>\
<value>\
<string>biappi</string>\
</value>\
</member>\
<member>\
<name>dateCreated</name>\
<value>\
<dateTime.iso8601>20080527T01:25:19</dateTime.iso8601>\
</value>\
</member>\
<member>\
<name>link</name>\
<value>\
<string>http://biappi.nnva.org/blog/virgin-mary-and-speed-light</string>\
</value>\
</member>\
<member>\
<name>postId</name>\
<value>\
<int>22</int>\
</value>\
</member>\
<member>\
<name>categories</name>\
<value>\
<array>\
<data>\
<value>\
<string>bla-bla</string>\
</value>\
</data>\
</array>\
</value>\
</member>\
</struct>\
</value>\
<value>\
<struct>\
<member>\
<name>permaLink</name>\
<value>\
<string>http://biappi.nnva.org/blog/runtime-dynamism-objective-c</string>\
</value>\
</member>\
<member>\
<name>description</name>\
<value>\
<string>&lt;p&gt;Ok, this blog is rarely updated, do i have to apologize every time? No, i don't. :P&lt;/p&gt;\
&lt;p&gt;With this new iPhone/iPod SDK some friends of mine began writing in Objective-C\
after ages of Java or C++. Yay for them!&lt;/p&gt;\
&lt;p&gt;I wanted to show 'em a lil bit of dynamism the objc runtime offers to us. Today, my fellow\
readers (do i have even one?), we'll try to instantiate an object of a class unknown at compile\
time.&lt;/p&gt;\
&lt;p&gt;So, let's start with a basic objc class (no cocoa there)&lt;/p&gt;\
&lt;p&gt;&lt;code&gt;&lt;pre&gt;\
@interface UsefulClass : NSObject\
{\
}\
\
-(void)doSomething;\
\
@end;\
\
@implementation UsefulClass\
\
-(void)doSomething;\
{\
NSLog(@\"Hello, World!\");\
}\
\
@end;\
&lt;/pre&gt;&lt;/code&gt;&lt;/p&gt;\
&lt;p&gt;Indeed this class is really useful.&lt;/p&gt;\
&lt;p&gt;Let's instantiate it, shall we?&lt;/p&gt;\
&lt;p&gt;&lt;code&gt;&lt;pre&gt;\
UsefulClass * uno = [[UsefulClass alloc] init];\
[uno doSomething];\
&lt;/pre&gt;&lt;/code&gt;&lt;/p&gt;\
&lt;p&gt;Nihil sub sole novum, that's just Obj-C 1-0-1, but what if we want to instantiate another\
object the same class of \"uno\"?&lt;/p&gt;\
&lt;p&gt;We can track \"uno\"'s type just by declaring a &lt;code&gt;class&lt;/code&gt; variable, then just asking\
\"uno\" itself!&lt;/p&gt;\
&lt;p&gt;&lt;code&gt;&lt;pre&gt;\
Class unknownClassToInstantiate = [uno class];\
id trallalla = [[unknownClassToInstantiate alloc] init];\
&lt;/pre&gt;&lt;/code&gt;&lt;/p&gt;\
&lt;p&gt;Yep, it's that simple!&lt;/p&gt;\
&lt;p&gt;We find out the class with the &lt;code&gt;class&lt;/code&gt; message provided by all NSObject-compliant\
object, which appens to be all objects in a Cocoa environment, then we treat the &lt;code&gt;class&lt;/code&gt;\
variable just like a \"real\" class name!&lt;/p&gt;\
&lt;p&gt;It's a matter of alloc/initing the new object!&lt;/p&gt;\
&lt;p&gt;Now just do that in C++ ;).&lt;/p&gt;</string>\
</value>\
</member>\
<member>\
<name>title</name>\
<value>\
<string>Runtime Dynamism With Objective-C</string>\
</value>\
</member>\
<member>\
<name>userId</name>\
<value>\
<string>biappi</string>\
</value>\
</member>\
<member>\
<name>dateCreated</name>\
<value>\
<dateTime.iso8601>20080520T04:08:58</dateTime.iso8601>\
</value>\
</member>\
<member>\
<name>link</name>\
<value>\
<string>http://biappi.nnva.org/blog/runtime-dynamism-objective-c</string>\
</value>\
</member>\
<member>\
<name>postId</name>\
<value>\
<int>21</int>\
</value>\
</member>\
<member>\
<name>categories</name>\
<value>\
<array>\
<data>\
<value>\
<string>Coding</string>\
</value>\
</data>\
</array>\
</value>\
</member>\
</struct>\
</value>\
</data>\
</array>\
</value>\
</param>\
</params>\
</methodResponse>\
";
