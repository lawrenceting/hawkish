/*
requires:
	jQuery (tested with version 1.11.2), 
	custom css file
*/

(function(saySomething){
	window.Tracker = function Tracker(wrapperId){
		var me = this;
		this.wrapperSelector = '#'+wrapperId;
		this.click = new function(){
			this.reset = (function(){
				this.$now = null;
				this.$prev = $j();
				this.index = null;
			}).bind(this); //Tracker's this
			this.reset();
		};
		this.removeMouseoverClass = function(elem, arr){
			if ($j(elem).hasClass("mouseover_1")) arr.push("mouseover_1");
				else if ($j(elem).hasClass("mouseover_2")) arr.push("mouseover_2");
				else arr.push("");
			$j(elem).removeClass("mouseover_1 mouseover_2");	
		};
		this.render_box = function($el, className, color, spread){
			var render = function(){
				$j("."+className).remove();

				var width = $el.outerWidth();
				var height = $el.outerHeight();
				var pos = $el.offset();

				var top = document.createElement("canvas");
					top.className = className;
					top.width = width;
					top.height = 0;
					top.style.top = pos.top + "px";
					top.style.left = pos.left + "px";
					top.style["box-shadow"] = color + " 0px -1px 0px " + spread;

				var right = document.createElement("canvas");
					right.className = className;
					right.width = 0;
					right.height = height;
					right.style.top = pos.top + "px";
					right.style.left = pos.left + width + "px";
					right.style["box-shadow"] = color + " 1px 0px 0px " + spread;

				var left = document.createElement("canvas");
					left.className = className;
					left.width = 0;
					left.height = height;
					left.style.top = pos.top + "px";
					left.style.left = pos.left + "px";
					left.style["box-shadow"] = color + " -1px 0px 0px " + spread;

				var bottom = document.createElement("canvas");
					bottom.className = className;
					bottom.width = width;
					bottom.height = 0;
					bottom.style.top = pos.top + height + "px";
					bottom.style.left = pos.left + "px";
					bottom.style["box-shadow"] = color + " 0px 1px 0px " + spread;

				$j(me.wrapperSelector).append(top, right, left, bottom);	
			}
			render();
			$j(window).off('resize.'+className).on('resize.'+className, {}, render);
			$j(window).off('scroll.'+className).on('scroll.'+className, {}, render);		
		};
		this.render_btn = function(){
			var render = function(){
				var pos = me.click.$now.offset();

				var btn = document.createElement('canvas');
					btn.className = "selected";
					btn.width = 30;
					btn.height = 30;
					btn.style.top = pos.top - 9 + "px";
					btn.style.left = pos.left + me.click.$now.outerWidth() + "px";

				var ctx = btn.getContext("2d");
					ctx.font = "20px Arial";
					ctx.lineWidth = 5;
					ctx.strokeText("✕", 6, 23);
					ctx.shadowColor = "black";
					ctx.shadowOffsetX = 0; 
					ctx.shadowOffsetY = 0; 
					ctx.shadowBlur = 7;
					ctx.textBaseline = 'alphabetic';
					ctx.scale(1,1);
					ctx.fillStyle = "white";
					ctx.fillText("✕", 6, 23);

				var link = document.createElement('a');
					link.href = "#/";
					link.appendChild(btn);

				$j(me.wrapperSelector).append(link);

				$j(link).click(function(){
					$j(".selected").remove();
					me.click.reset(); //reset values
				});	
			}
			render();
			$j(window).off('resize.close_btn').on('resize.close_btn', {}, render);
			$j(window).off('scroll.close_btn').on('scroll.close_btn', {}, render);			
		};
		this.highlight = function($hovered, e){ // highlight hovered
			e.stopPropagation();
			var isWrapper = false;
			$hovered.parents().addBack().map(function(){
				if (this.id==wrapperId) isWrapper = true;
				if (isWrapper) return this;
			}).children().each(addMouseoverClass = function(i){
				$j(this).removeClass("mouseover_1 mouseover_2");
				this.className += " mouseover_" + ((i+1)%2==0?1:2);
			});
			$hovered.find("*").each(addMouseoverClass);
			me.render_box($hovered, "hovered", "blue", "2px");		
		};
		this.unhighlight = function(e){ 
			e.stopPropagation();
			$j(me.wrapperSelector).find('*').removeClass("mouseover_1 mouseover_2");
			$j(".hovered").remove();		
		};
		this.run = function(){
			if ($j(me.wrapperSelector).length){
				
			// record whether element has class
			// disable event
				$j(me.wrapperSelector).find('*').off().unbind().each(function(i, elem){
					$j(this).data("hasClass", elem.attributes.getNamedItem("class"));				
				}).click(function(e){return false;});

			// 1. save attribute name and value
			// 2. replace attribue value 
				$j(me.wrapperSelector).find('a').each(function(){
					$j(this).data("href", this.href);
					$j(this).data("onclick", this.onclick);
						this.href = "#/";
						this.onclick = "return false;";
				});
				$j(me.wrapperSelector).find("input[type=submit], button").each(function(){
					$j(this).data("disabled", this.disabled) //save attribute name and value 
						this.disabled = "disabled"; //replace attribue value 
				});

			// 1. stops the browsers default behaviour.
			// 2. prevents the event from propagating (or “bubbling up”) the DOM.
			// 3. Stops callback execution and returns immediately when called.
			// 4. perform action when elment is clicked
				$j(me.wrapperSelector).find('*').click(function(e) {
					e.stopPropagation();
					me.click.$now = $j(this); //reset
					if (!me.click.$now.is(me.click.$prev)){ //if current clicked element is not the same as previous clicked element
						
						me.click.$prev = me.click.$now;
						var parentsOfElems = []; //parents of clicked
						var selectors = [];
						var nodes = []; //store tagname & attribute of clicked elements, for nokogiri
						var $searchNode = $j();

					// remove all mouseover classes
						me.unhighlight(e);
						
					// revert back to original attribute value/
						$j(me.wrapperSelector).find('a', "input[type=submit], button").each(function(){
							this["href"] = $j(this).data("href");
							this["onclick"] = $j(this).data("onclick");
							this["disabled"] = $j(this).data("disabled");
						});
						
					// remove classes so it won't turn up in submitted data
						me.click.$now.parents().addBack().get().reverse().some(function(elem){  //reverse - start from clicked element, transvers down until id is found
							if (elem.id == wrapperId) return true;
							if (!$j(elem).data("hasClass")) elem.removeAttribute("class");
							parentsOfElems.push(elem);
							return elem.attributes.getNamedItem("id"); //if id is found break from loop
						});
						me.click.$now.find("*").each(function(){
							if (!$j(this).data("hasClass")) this.removeAttribute("class");							
						});

					// save nodes
						parentsOfElems.forEach(function(elem){ //clicked element + parents in reverse order
							var tagName = elem.tagName.toLowerCase();

							if (elem.attributes.length == 0){ 
								nodes.push(tagName, "[no_attr_name]", "[no_attr_val]"); //
								selectors.push(tagName);

							} else {
								$j(elem.attributes).each(function(i, attr){
									if (tagName == 'a' && attr.name == "href") attr.value = $j(elem).data("href");
									if (tagName == 'a' && attr.name == "onclick") attr.value = $j(elem).data("onclick");
									if (tagName == 'button' && attr.name == "disabled") attr.value = $j(elem).data("disabled");
									if (tagName == 'input' && elem.type == "submit" && attr.name == "disabled") attr.value = $j(elem).data("disabled");

									var hasId = elem.attributes.getNamedItem("id"); //
									var s = '[' + attr.name + (attr.value.length ? ('="' + attr.value + '"') : '') + ']' //e.g. div[class='main']
									
									if ((hasId && attr.name=='id') || !hasId){ //
										nodes.push(tagName, attr.name, attr.value.length ? attr.value : "[no_attr_val]");
									}									

									if (i == 0) selectors.push(tagName + s);
									else if (s!='[]') selectors[selectors.length-1] += s;
								});
							} //end if
						});
		
					// find if selected is unique, if not, get index, index may not be accurate so record, text
						$j.each(selectors.slice(0).reverse(), function(i, s) {
							if (i==0) return ($searchNode = $j(me.wrapperSelector).find(s));
							$searchNode = $searchNode.children(s);
						});
						$searchNode.each(function(i){
							me.click.index = i;
							return !me.click.$now.is(this); //break if index is found, return false
						});

					// record text in html
						var innerHTML = $j(me.click.$now)[0].innerHTML;

					// record no. of children
						var numberOfChilren = $j(me.click.$now)[0].children.length;

					// update & submit nodes, attributes
						$j('#tracker_nodes').val(nodes.join("[split]")); //update form
						
					// reverse to default value of href and onclick, refer to .data
						$j('#tracker_content').val(this.outerHTML); //return outerHTML of first clicked
						console.log(me.click.index);
						console.log(numberOfChilren);
						console.log(innerHTML);
						//return selectors compatible with nokogiri format
						//then compare in ruby
						//http://stackoverflow.com/questions/3593237/using-nokogiri-and-xpath-to-get-nodes-with-multiple-attributes
						//http://stackoverflow.com/questions/20239129/nokogiri-find-xml-node-with-multiple-attributes-and-change-text
						//removes nodes, rename to selectors
						
					// add box / highlight 
						me.highlight(me.click.$now, e);
						me.render_box(me.click.$now, "selected", "black", "3px"); //create box when clicked
						me.render_btn(); //create close button
						
					// revert back to stored attribute value
						$j(me.wrapperSelector).find('a', "input[type=submit], button").each(function(){
							this.href = "#/";
							this.onclick = "return false;";
							this.disabled = "disabled";
						});
					} //end if
				}).mouseover(function(e) {
					me.highlight($j(this), e);
					//use .bind
				}).mouseout(me.unhighlight);	
			} //end if
		};
	}
	function replaceAll(find, replace, str){
		for (i = 0; i < find.length; i++) { 
			str = str.replace( new RegExp(find[i], 'g'), replace[i] );
		}
		return str;
	} // Find replace string
})("fuck");