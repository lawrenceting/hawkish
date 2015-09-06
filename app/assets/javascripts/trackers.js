//= require underscore
//= require moment
//= require highstock

//new tracker
$(function(){
	$('#website a').click(function(e) { e.preventDefault(); });
	
	var $clicked = []; //get clicked elements
	var $click_first; //get first clicked elements
	var nodes = []; //store tagname & attribute of clicked elements
	var nodes_copy = []; //clone nodes
	submit_tracker();
	
	$("#website *").click(function(e) {
		
		var $this = $(this);
		$clicked.push($(this));

		//push tagname, attribute name, attribute value
		if ($this[0].attributes.length === 0){
			nodes.push($this[0].tagName, "[no_attr_name]", "[no_attr_val]");

		} else {
			$( $this[0].attributes ).each(function( i, attr ) {
				nodes.push(
					$this[0].tagName.trim(), 
					attr.name.trim(), 
					(attr.value.trim() == "") ? "[no_attr_val]" : attr.value.trim()
				);
			});			
		}
		
		if ($this.parent()[0].id === "website") { //if last node
			nodes_copy = nodes.slice(0);
			$click_first = $clicked[0];
			nodes = [];
			$clicked = [];
			$('#website').trigger("submit_tracker");
			submit_tracker();
		}
	});

	function submit_tracker(){
		$('#website').one("submit_tracker", function(e){ 
			
			if(nodes_copy.length % 3 === 0){
				$('#tracker_nodes').val(nodes_copy.join("[split]"));
				$('#tracker_content').val($click_first.text());
				
			} else {
				$('#tracker_nodes, #tracker_content').val("Error!");
			}
		});
	}
})

//show tracker
$(function () {
	var tracker = {
		id: $('.page-data').data('id'),
		url: $('.page-data').data('url')
	};

	Highcharts.setOptions({
		//plots, change Date axis to local timezone
		global : {
			useUTC : false
		}	
	}); 	
	
	$.getJSON('/trackers/' + tracker.id + '/updates.json', function (data) {

		var datetime = data.map(function(obj) {
			return moment.utc(obj.date).valueOf();
		});
		var content = data.map(function(obj) {
			return parseFloat(obj.content.replace(/[^0-9\.]+/g,''));
		});			
		var combined_data = _.zip(datetime, content)

		// Create the chart
		$('#chart').highcharts('StockChart', {
			
			rangeSelector : {
				selected : 1
			},

			title : {
				text : tracker.url
			},

			credits: {
				enabled: false
			},
			
			series : [{
				name : "" , //tracker.url 
				data : combined_data,
                marker : {
                    enabled : true,
                    radius : 5
                },
                shadow : true,				
				tooltip: {
					valueDecimals: 2
				}
			}]
		});
	});
});