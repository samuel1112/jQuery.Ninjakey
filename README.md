jQuery.NinjaKey
===============

A Simple jQuery shortcuts library

add es6 / commonJS support.

### supported keys
For modifier keys you can use `a-z`,`A-Z`,`0-9`,`shift`,`ctrl/command` and `alt/option`.
Other keys are `home`,`left`,`up`,`right`,`down`,`enter`,`esc`,`space`,`backspace`,`delete`

###how to use

1. Include ninjakey on your page before the closing `</body>` tag

	```
		<script src="/path/to/jQuery.min.js"></script>
		<script src="/path/to/jQuery.ninjakey.js"></script>
	```
2. Add some keyboard events

	```

		NinjaKey('ctrl+m',function(){
			console.log("ctrl m");
		});

		// binding multiple keys
		NinjaKey(['ctrl+m','alt+m'],function(){
			console.log("ctrl m");
		});

		// binding to elem
		NinjaKey('ctrl+shift+q','.elem',function(){
			var $this = this;
			$this.html('use ctrl+shift+q');
		});

		// or you can kill one ninja.
		var _nin = NinjaKey('ctrl+shift+v','.elem',function(){
			var $this = this;
			$this.html('use ctrl+shift+v');
			_nin.kill();
		});

	```

###important

only test in chrome / safari!

###BUGS

If you are having trouble, have found a bug, or want to contribute don't be shy.
Open a ticket on Github.
