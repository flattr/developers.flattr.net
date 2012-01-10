!function () {
	var $nav, $navItems, offset, $headers, $headersLength,
		$body = $('body'),
		fixed = false,
		inSection = false,
		fixedSupported, setSection;

	// Creating menu without leaking too many vars into the upper namespace
	!function () {
		$headers = $('h2');
		$headersLength = $headers.length;

		$nav = $('<ul />').addClass('nav');
		$headers.each(function (elem, i) {
			var $elem = $(elem),
				$link = $('<a />').attr('href', '#' + $elem.attr('id')).text($elem.text());
			$('<li />').append($link).appendTo($nav);
		});
		$('<div />').addClass('nav-wrapper').append($nav).insertAfter('.header');
		$nav = $('.nav');
		$navItems = $nav.find('li');
		offset = $nav.offset();
	}();

	// From http://kangax.github.com/cft/#IS_POSITION_FIXED_SUPPORTED
	fixedSupported = function () {
		var container = document.body;
		if (document.createElement &&
			container && container.appendChild && container.removeChild) {
			var el = document.createElement("div");
			if (!el.getBoundingClientRect) {
				return null;
			}
			el.innerHTML = "x";
			el.style.cssText = "position:fixed;top:100px;";
			container.appendChild(el);
			var originalHeight = container.style.height, originalScrollTop = container.scrollTop;
			container.style.height = "3000px";
			container.scrollTop = 500;
			var elementTop = el.getBoundingClientRect().top;
			container.style.height = originalHeight;
			var isSupported = elementTop === 100;
			container.removeChild(el);
			container.scrollTop = originalScrollTop;
			return isSupported;
		}
		return null;
	};

	if (fixedSupported()) {
		setSection = function (section) {
			if (inSection !== false) {
				$($navItems[inSection]).removeClass('active');
			}
			if (section !== false) {
				$($navItems[section]).addClass('active');
			}
			inSection = section;
		};

		$(window).scroll(function () {
			var $this = $(this),
				scrollTop = $this.scrollTop(),
				i,
				newSection;
			if (!fixed && scrollTop > offset.top) {
				$body.addClass('fixed-nav');
				fixed = true;
			}
			else if (fixed && scrollTop <= offset.top) {
				$body.removeClass('fixed-nav');
				fixed = false;
			}

			scrollTop = scrollTop + offset.height + 20; // 20 = the margin-bottom of the nav

			if (scrollTop < $($headers[0]).offset().top) {
				if (inSection !== false) {
					setSection(false);
				}
			}
			else if (inSection === false || (inSection !== $headersLength - 1 && scrollTop > $($headers[inSection]).offset().top && scrollTop >= $($headers[inSection + 1]).offset().top)) {
				newSection = (inSection === false ? 0 : inSection + 1);
				for (i = newSection + 1; i < $headersLength; i++) {
					if (scrollTop >= $($headers[i]).offset().top) {
						newSection = i;
					}
					else {
						break;
					}
				}
				setSection(newSection);
			}
			else if (inSection !== false && scrollTop < $($headers[inSection]).offset().top) {
				newSection = inSection - 1;
				for (i = newSection - 1; i >= 0; i--) {
					if (scrollTop >= $($headers[i]).offset().top) {
						newSection = i;
					}
					else {
						break;
					}
				}
				setSection(newSection);
			}
		});
	}
}();