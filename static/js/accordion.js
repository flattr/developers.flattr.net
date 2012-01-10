!function () {
	var $resources = $('.resource'), vendorPrefixes = ['-webkit', '-moz', '-o', ''],
		addTransition, removeTransition, throttle, updateSearch, groupH4s, hideResource,
		lastSearch = '';

	throttle = function (fn, delay) {
		var timer = null;
		return function () {
			var context = this, args = arguments;
			clearTimeout(timer);
			timer = setTimeout(function () {
				fn.apply(context, args);
			}, delay);
		};
	};

	addTransition = function ($elem) {
		for (var i = 0, length = vendorPrefixes.length; i < length; i++) {
			$elem.css(vendorPrefixes[i] + '-transition', 'height ease .5s');
		}
	};

	removeTransition = function ($elem) {
		for (var i = 0, length = vendorPrefixes.length; i < length; i++) {
			$elem.css(vendorPrefixes[i] + '-transition', '');
		}
	};

	updateSearch = throttle(function (event) {
		var lastSearchLength = lastSearch.length,
			newSearch = $(this).val().toLowerCase(),
			newSearchLength = newSearch.length,
			refine;

		if (!newSearchLength) {
			$('body').removeClass('filtered');
			$resources.removeClass('matches');
		}
		else if (newSearch !== lastSearch) {
			refine = lastSearchLength && newSearchLength > lastSearchLength && newSearch.substr(0, lastSearchLength) === lastSearch;
			$('body').addClass('filtered');
			$resources.each(function () {
				var $this = $(this);
				if ((!refine || $this.hasClass('matches')) && $this.text().toLowerCase().indexOf(newSearch) !== -1) {
					$this.addClass('matches');
				}
				else {
					$this.removeClass('matches');
					if (!$this.hasClass('hidden')) {
						addTransition($this);
						$this.addClass('hidden').css('height', $this.find('h3').offset().height + 'px');
					}
				}
			});
		}

		lastSearch = newSearch;
	}, 200);

	groupH4s = function (group) {
		var $container, $content, i, length;

		$container = $('<div />').addClass('method').addClass('hidden');
		$container.insertBefore(group[0]);
		$container.append(group[0]);

		$content = $('<div />').addClass('content');
		for (i = 1, length = group.length; i < length; i++) {
			$content.append(group[i]);
		}
		$container.append($content);
	};

	$resources.find('.content').each(function () {
		var $this = $(this),
			$children = $this.children(),
			child, group, i, length;
		for (i = 0, length = $children.length; i < length; i++) {
			child = $children[i];
			if (typeof group === 'object') {
				if (child.tagName === 'H4') {
					//groupH4s(group);
					group = [child];
				}
				else {
					group[group.length] = child;
				}
			}
			else if (child.tagName === 'H4') {
				group = [child];
			}
		}
		if (typeof group === 'object') {
			//groupH4s(group);
		}

		$this.find('.method').css('height', $this.find('h4').offset().height + 'px');
	});

	hideContainer = function ($container, headerHeight) {
		removeTransition($container);
		console.log($container.offset().height);
		$container.addClass('hidden').css('height', $container.offset().height + 'px');
		setTimeout(function () {
			addTransition($container);
			$container.css('height', headerHeight + 'px');
		}, 1);
	};

	$resources.addClass('hidden').find('h3,h4').click(function () {
			var $this = $(this), method, $methodResource, $container, currentHeight, targetHeight, headerHeight;

			method = (this.tagName === 'H4');
			$container = $this.closest(method ? '.method' : '.resource');
			headerHeight = $this.offset().height;

			if (method) {
				$methodResource = $container.closest('.resource');
				removeTransition($methodResource);
				$methodResource.css('height', 'auto');
			}

			if ($container.hasClass('hidden')) {
				// Hide others
				(method ? $methodResource.find('.method') : $resources).each(function () {
					if (this !== $container[0]) {
						hideContainer($(this), headerHeight);
					}
				});

				// Show this one
				currentHeight = $container.offset().height;
				removeTransition($container);
				$container.removeClass('hidden').css('height', 'auto');
				targetHeight = $container.offset().height;
				$container.css('height', currentHeight + 'px');
				//TODO: Could we use offsetHeight to trigger reflow like @fat said?
				setTimeout(function () {
					addTransition($container);
					$container.css('height', targetHeight + 'px');
				}, 1);
			} else {
				hideContainer($container, headerHeight);
			}
		});

	$resources.css('height', $($resources[0]).find('h3').offset().height + 'px');

	$('<input />').attr({
		type : 'search',
		placeholder : 'Enter keywords to filter resources'
	}).appendTo($('<div />').addClass('search').insertAfter('#resources')).keypress(updateSearch).change(updateSearch).click(updateSearch);
	$resources.find('h3').each(function(m){
		if(location.hash &&  m.innerHTML.toLowerCase() == location.hash.substr(1).toLowerCase()) {
			$(m).click();
			$(m).parents('div').prepend('<a href="#categories" name="'+m.innerHTML.toLowerCase()+'"></a>')
		}
	});
}();
